import 'dart:developer';
import 'dart:isolate';
import 'package:isolate/isolate_runner.dart';

typedef IsolateProgressCallback = void Function(int progress, int total,
    [double? speed]);

typedef FluIsolateCallback<I, O> = Future<O> Function(
    I input, IsolateProgressCallback progressCallback);
class _IsolateData<I, O> {
  ///Passing data through isolate lost the parameterized types of classes and functions
  final Function computation;
  final SendPort sendPort;

  final bool sendProgress;
  final I? data;
  final String isolateName;
  final String computationIdentifier;

  const _IsolateData(
      FluIsolateCallback<I, O> computation,
      this.sendPort, {
        required this.sendProgress,
        this.data,
        this.isolateName = "Unknown",
        this.computationIdentifier = "Unknown",
      })  : assert(computation != null),
        this.computation = computation,
        assert(sendPort != null),
        assert(sendProgress != null);
}

class FluIsolate<I, O> {
  final String name;

  ///Must be a top-level or static function
  final FluIsolateCallback<I, O> callback;

  IsolateRunner? _isolateRunner;

  bool get _isSpawned => _isolateRunner != null;
  int computationIndex = 1;

  FluIsolate(this.name, this.callback)
      : assert(name != null && name.isNotEmpty),
        assert(callback != null);

  Future<void> startIsolate() async {
    if (_isolateRunner == null) _isolateRunner = await IsolateRunner.spawn();
  }

  Future<void> closeIsolate() async {
    if (_isolateRunner == null) return Future.value();

    await _isolateRunner!.kill(timeout: Duration(milliseconds: 500));
    _isolateRunner = null;
  }

  Future<O?> compute({
    I? input,
    IsolateProgressCallback? progressCallback,
    bool once = true,
  }) async {
    assert(once != null);
    await startIsolate();

    final receiveFromIsolate = ReceivePort();

    //get actual computation index anc increment
    final actualIndex = computationIndex;
    computationIndex++;

    final _isolateData = _IsolateData<I, O>(
      callback,
      receiveFromIsolate.sendPort,
      isolateName: name,
      computationIdentifier: actualIndex.toString(),
      sendProgress: progressCallback != null,
      data: input,
    );

    O? result;

    try {
      Future computation = _isolateRunner!.run(_isolateMain, _isolateData);

      Future messages = Future.sync(() async {
        await for (var data in receiveFromIsolate) {
          if (progressCallback != null && data is _IsolateProgress) {
            progressCallback(data.progress, data.total, data.speed);
          } else if (data is O) {
            result = data;
            break;
          } else if (data is bool) {
            //If data is true, the callback completed successfully but returned anything
            //If data is false, the callback failed with an error
            result = null;
            break;
          }
        }
      });

      await messages;
      await computation;
    } catch (e) {
      rethrow;
    } finally {
      if (once) await closeIsolate();
      receiveFromIsolate.close();
    }

    return result;
  }
}

class _IsolateProgress {
  final int progress;
  final int total;
  final double? speed;

  const _IsolateProgress({required this.progress, required this.total, this.speed});
}

void _logIsolateComputation(String name, String computation, String message) {
  log(message, name: "isolate $name - $computation");
}
void _sendProgressThroughPort(SendPort port, int progress, int total, double? speed) {
  port.send(_IsolateProgress(progress: progress, total: total, speed: speed));
}

void _emptyProgressCallback(int progress, int total, [double? speed]) {}

Future<void> _isolateMain(_IsolateData isolateData) async {
  const unknownObject = "Unknown";
  final isolateName = isolateData.isolateName ?? unknownObject;
  final computationIdentifier =
      isolateData.computationIdentifier ?? unknownObject;

  final log = (String message) =>
      _logIsolateComputation(isolateName, computationIdentifier, message);

  log("started");

  final sendPort = isolateData.sendPort;

  try {
    ///The process will initially send the port to receive the data
    ///Then on every progress send an _IsolateProgress event
    ///When the callback ends, it sends the data if it's not null, or true if it's null
    ///If the callback throws an exception false is sent
    //sendPort.send(isolatePort.sendPort);

    //_IsolateData isolateData = await isolatePort.first;

    final data = isolateData.data;

    final output = await isolateData.computation(
      data,
      isolateData.sendProgress
          ? (int progress, int total, [double? speed]) =>
          _sendProgressThroughPort(sendPort, progress, total, speed)
          : _emptyProgressCallback,
    );

    log("finished with result $output");

    ///When the callback ends, it sends the data if it's not null, or true if it's null
    if (output == null)
      sendPort.send(true);
    else
      sendPort.send(output);
  } catch (e) {
    log("finished with error $e");
    sendPort.send(false);
    rethrow;
  }
}