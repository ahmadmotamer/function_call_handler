import 'package:async/async.dart';

/// Request execution strategy
enum RequestType { singleExecution, cancelAll, forceCall }

class FunctionCallManager {
  // Singleton instance
  static final FunctionCallManager _instance = FunctionCallManager._internal();

  factory FunctionCallManager() => _instance;

  FunctionCallManager._internal();

  /// Store ongoing requests mapped by key
  final Map<String, List<CancelableOperation>> _requests = {};

  /// Execute a function with request type and key
  Future<T> execute<T>({
    required Future<T> Function() function,
    RequestType type = RequestType.singleExecution,
    required String key,
  }) async {
    switch (type) {
      case RequestType.singleExecution:
        return _handleSingleExecution(function, key);
      case RequestType.cancelAll:
        return _handleCancelAll(function, key);
      case RequestType.forceCall:
        return _handleForceCall(function, key);
    }
  }

  /// --- Handlers ---

  Future<T> _handleSingleExecution<T>(
      Future<T> Function() function,
      String key,
      ) async {
    // If there is already an active request with the same key, skip
    if (_requests[key]?.isNotEmpty == true) {
      return Future.error("Skipped: request with key '$key' already running");
    }

    return _startOperation(function, key);
  }

  Future<T> _handleCancelAll<T>(
      Future<T> Function() function,
      String key,
      ) async {
    // Cancel all existing requests with the same key
    await _cancelAll(key);

    return _startOperation(function, key);
  }

  Future<T> _handleForceCall<T>(
      Future<T> Function() function,
      String key,
      ) async {
    // Just start another request, keep stack
    return _startOperation(function, key);
  }

  /// Start a cancelable operation and track it
  Future<T> _startOperation<T>(Future<T> Function() function, String key) {
    final completer = CancelableOperation<T>.fromFuture(
      function(),
      onCancel: () {
        // Debug log
        print("Request with key '$key' was cancelled");
      },
    );

    _requests.putIfAbsent(key, () => []).add(completer);

    // When finished, remove from list
    completer.value.whenComplete(() {
      _requests[key]?.remove(completer);
      if (_requests[key]?.isEmpty ?? false) {
        _requests.remove(key);
      }
    });

    return completer.value;
  }

  /// Cancel all requests for a given key
  Future<void> _cancelAll(String key) async {
    if (_requests.containsKey(key)) {
      for (final op in _requests[key]!) {
        await op.cancel();
      }
      _requests.remove(key);
    }
  }

  /// Cancel absolutely everything
  Future<void> cancelEverything() async {
    for (final key in _requests.keys.toList()) {
      await _cancelAll(key);
    }
  }
}
