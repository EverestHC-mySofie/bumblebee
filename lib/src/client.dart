part of 'package:bumblebee/bumblebee.dart';

/// Checks if you are awesome. Spoiler: you are.
class Client {
  late http.Client? httpClient;
  final Uri server;
  late String? channelPrefix;
  late Bridge? _bridge;

  Client({required this.server, this.channelPrefix, this.httpClient}) {
    httpClient ??= http.Client();
    channelPrefix ??= "pollen/streams";
    _bridge = Bridge();
  }

  Client onMessage(Function(Event) func) {
    _bridge!.onMessage = func;
    return this;
  }

  Client onTerminate(Function() func) {
    _bridge!.onTerminate = func;
    return this;
  }

  Client onHeartbeat(Function() func) {
    _bridge!.onHeartbeat = func;
    return this;
  }

  Future<Event?> listen(String streamId,
      [http.Request Function(Uri)? requestBuilder]) async {
    Completer<Event?> completer = Completer();
    Accumulator accumulator = Accumulator(_bridge!);

    _openStream(streamId, requestBuilder).listen((data) {
      _lineStream(data).listen((line) {
        accumulator.nextLine(line);
      }).onDone(() {
        if (accumulator.completionEvent == null) {
          completer.completeError(StreamTimeoutException(
              "The remote server closed connection without a completion event"));
        } else if (accumulator.completionEvent!.type == 'failed') {
          completer.completeError(FailureException(accumulator.completionEvent!,
              "The remote server marked the stream as failed"));
        } else {
          completer.complete(accumulator.completionEvent);
        }
      });
    });
    return completer.future;
  }

  Stream<http.StreamedResponse> _openStream(
      String streamId, http.Request Function(Uri)? requestBuilder) {
    Uri streamUri = server.resolve("$channelPrefix/$streamId");
    http.Request request;
    if (requestBuilder != null) {
      request = requestBuilder(streamUri);
    } else {
      request = http.Request("GET", streamUri);
    }
    Future<http.StreamedResponse> response = httpClient!.send(request);
    return response.asStream();
  }

  Stream<String> _lineStream(http.StreamedResponse data) {
    return data.stream.transform(Utf8Decoder()).transform(LineSplitter());
  }
}

abstract class BumblebeeException implements Exception {
  final String message;

  BumblebeeException(this.message);
}

class InvalidStateException extends BumblebeeException {
  InvalidStateException(super.message);
}

class FailureException extends BumblebeeException {
  final Event event;
  FailureException(this.event, super.message);
}

class StreamTimeoutException extends BumblebeeException {
  StreamTimeoutException(super.message);
}
