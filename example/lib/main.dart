import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:function_call_handler/function_call_handler.dart';

/// -- Paste your FunctionCallManager code here --

/// Use this example async function for testing

void main() {
  runApp(FunctionManagerDemoApp());
}

class FunctionManagerDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FunctionCallManager Demo',
      debugShowCheckedModeBanner: false,
      home: FunctionManagerHome(),
    );
  }
}

class FunctionManagerHome extends StatefulWidget {
  @override
  State<FunctionManagerHome> createState() => _FunctionManagerHomeState();
}

class _FunctionManagerHomeState extends State<FunctionManagerHome> {
  final _manager = FunctionCallManager();
  final List<String> _logs = [];

  void _addLog(String txt) {
    setState(() {
      _logs.insert(0, txt);
    });
  }

  Future<String> fakeApiCall(String id, Duration dur) async {
    await Future.delayed(dur);
    return "Completed $id at ${DateTime.now().toIso8601String()}";
  }

  Future<void> _testSingleExecution() async {
    _addLog('SingleExecution: Request 1');
    _manager
        .execute<String>(
          function: () => fakeApiCall('Single1', Duration(seconds: 2)),
          type: RequestType.singleExecution,
          key: 'single',
        )
        .then(_addLog)
        .catchError((e) => _addLog('Error: $e'));

    await Future.delayed(Duration(milliseconds: 400));
    _addLog('SingleExecution: Request 2 (should skip)');
    _manager
        .execute<String>(
          function: () => fakeApiCall('Single2', Duration(seconds: 2)),
          type: RequestType.singleExecution,
          key: 'single',
        )
        .then(_addLog)
        .catchError((e) => _addLog('Error: $e'));
  }

  Future<void> _testCancelAll() async {
    _addLog('CancelAll: Request 1');
    _manager
        .execute<String>(
          function: () => fakeApiCall('Cancel1', Duration(seconds: 2)),
          type: RequestType.cancelAll,
          key: 'cancel',
        )
        .then(_addLog)
        .catchError((e) => _addLog('Error: $e'));

    await Future.delayed(Duration(milliseconds: 400));
    _addLog('CancelAll: Request 2 (should cancel previous)');
    _manager
        .execute<String>(
          function: () => fakeApiCall('Cancel2', Duration(seconds: 2)),
          type: RequestType.cancelAll,
          key: 'cancel',
        )
        .then(_addLog)
        .catchError((e) => _addLog('Error: $e'));
  }

  Future<void> _testForceCall() async {
    _addLog('ForceCall: Request 1');
    _manager
        .execute<String>(
          function: () => fakeApiCall('Force1', Duration(seconds: 2)),
          type: RequestType.forceCall,
          key: 'force',
        )
        .then(_addLog)
        .catchError((e) => _addLog('Error: $e'));

    _addLog('ForceCall: Request 2 (should run independently)');
    _manager
        .execute<String>(
          function: () => fakeApiCall('Force2', Duration(seconds: 2)),
          type: RequestType.forceCall,
          key: 'force',
        )
        .then(_addLog)
        .catchError((e) => _addLog('Error: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FunctionCallManager Demo')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _testSingleExecution,
              child: Text('Test SingleExecution'),
            ),
            ElevatedButton(
              onPressed: _testCancelAll,
              child: Text('Test CancelAll'),
            ),
            ElevatedButton(
              onPressed: _testForceCall,
              child: Text('Test ForceCall'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                reverse: true,
                children: _logs.map((l) => Text(l)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
