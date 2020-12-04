// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * Concurrent programming using _isolates_:
 * independent workers that are similar to threads
 * but don't share memory,
 * communicating only via messages.
 *
 * To use this library in your code:
 *
 *     import 'dart:isolate';
 *
 * {@category VM}
 */
library dart.isolate;

import "dart:async";
import "dart:_internal" show Since;
import "dart:typed_data" show ByteBuffer, TypedData, Uint8List;

part "capability.dart";

/**
 * Thrown when an isolate cannot be created.
 */
class IsolateSpawnException implements Exception {
  /** Error message reported by the spawn operation. */
  final String message;
  @pragma("vm:entry-point")
  IsolateSpawnException(this.message);
  String toString() => "IsolateSpawnException: $message";
}

/**
 * An isolated Dart execution context.
 *
 * All Dart code runs in an isolate, and code can access classes and values
 * only from the same isolate. Different isolates can communicate by sending
 * values through ports (see [ReceivePort], [SendPort]).
 *
 * An `Isolate` object is a reference to an isolate, usually different from
 * the current isolate.
 * It represents, and can be used to control, the other isolate.
 *
 * When spawning a new isolate, the spawning isolate receives an `Isolate`
 * object representing the new isolate when the spawn operation succeeds.
 *
 * Isolates run code in its own event loop, and each event may run smaller tasks
 * in a nested microtask queue.
 *
 * An `Isolate` object allows other isolates to control the event loop
 * of the isolate that it represents, and to inspect the isolate,
 * for example by pausing the isolate or by getting events when the isolate
 * has an uncaught error.
 *
 * The [controlPort] identifies and gives access to controlling the isolate,
 * and the [pauseCapability] and [terminateCapability] guard access
 * to some control operations.
 * For example, calling [pause] on an `Isolate` object created without a
 * [pauseCapability], has no effect.
 *
 * The `Isolate` object provided by a spawn operation will have the
 * cont