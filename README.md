# FunctionCallManager Flutter Plugin

A powerful Flutter utility for **managing concurrent function/execution calls with cancellation and queuing strategies**.

---

## Overview

`FunctionCallManager` helps handle multiple asynchronous calls keyed by unique identifiers and supports 3 execution strategies:

- **singleExecution**: Ensures only one function executes for a given key at a time. Further requests with the same key are skipped until the active one finishes.
- **cancelAll**: Cancels all active requests for a key before running the new request.
- **forceCall**: Allows multiple requests for the same key to be run in parallel or queued per the implementation.

This is useful for debouncing, request cancellation, avoiding duplicate API calls, or queuing calls in Flutter apps.

---

## Features

- Manage simultaneous async calls per unique keys.
- Cancel ongoing requests gracefully.
- Prevent redundant or overlapping request execution.
- Support queuing and forced multiple call processing.
- Uses `CancelableOperation` from `package:async` for better cancellation handling.

---

## Installation

Add to your `pubspec.yaml`:

dependencies:
async: ^2.10.0
function_call_manager_plugin: ^0.0.1 # Replace with actual plugin name and version



Run:

flutter pub get


---

## Usage

import 'package:function_call_manager_plugin/function_call_manager_plugin.dart';

final manager = FunctionCallManager();

Future<String> fetchData() async {
// Simulate network delay
await Future.delayed(Duration(seconds: 2));
return "Data fetched";
}

void example() async {
// Run with singleExecution (skip duplicates)
try {
String result = await manager.execute<String>(
function: fetchData,
type: RequestType.singleExecution,
key: 'fetchData',
);
print(result);
} catch(e) {
print('Request skipped: $e');
}

// Run with cancelAll (cancel previous calls before new call)
String result2 = await manager.execute<String>(
function: fetchData,
type: RequestType.cancelAll,
key: 'fetchData',
);
print(result2);

// Run with forceCall (allow multiple simultaneous calls)
String result3 = await manager.execute<String>(
function: fetchData,
type: RequestType.forceCall,
key: 'fetchData',
);
print(result3);
}


---

## API

### `Future<T> execute<T>({required Future<T> Function() function, RequestType type = RequestType.singleExecution, required String key})`

Runs the given async function with the specified execution strategy under the provided key.


---

## Contributing

Contributions and bug reports are welcome via GitHub.

---

**Thank you for using FunctionCallManager!**
