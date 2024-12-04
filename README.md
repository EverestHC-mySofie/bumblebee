# Bumblebee

Bumblebee is the Dart & Flutter client library for
[Pollen](https://github.com/EverestHC-mySofie/pollen),
an HTTP pubsub and streaming engine for Rails.

## Features

Subscribe to Pollen streams and be notified of message events,
streams completion and failure.

## Getting started

```bash
flutter pub add bumblebee
```

## Usage

### Subscribing to a stream

```dart
import 'package:bumblebee/bumblebee.dart' as bumblebee;

void subscribe(String streamId) async {
  bumblebee.Event? event = await bumblebee.Client(server: Uri.parse('https://pollen.server.local')).
    .listen(streamId);
  print("Stream completed: ${event?.type}");
}
```

### Listening to stream updates

```dart
import 'package:bumblebee/bumblebee.dart' as bumblebee;

void subscribe(String streamId) async {
  bumblebee.Event? event = await bumblebee.Client(server: Uri.parse('https://pollen.server.local'))
    .onHeartbeat(() {
      print('Received an heartbeat');
    }).onTerminate(() {
      print('Received the "terminated" event');
    }).onMessage((bumblebee.Event event) {
      print('Received an event of type ${event.type}');
      print('Payload: ${event.data()}');
    }).listen(streamId);
  print("Stream completed: ${event?.type}");
  print('Payload: ${event?.data()}');
}
```

### Handle errors

Connection timeouts and stream failures fired server-side throw
`TimeoutException` and `FailureException` exceptions, respectively.
As Bumblebee uses the http package under the hood, network connectivity
issues will throw `http.ClientException` exceptions.

### License

This library is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
