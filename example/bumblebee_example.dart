import 'package:bumblebee/bumblebee.dart' as bumblebee;

// Usage
// dart run example/bumblebee_example.dart <pollen-server-url> <stream-id>
// dart run example/bumblebee_example.dart https://pollen.server.org b9800156-d4d3-4f89-8c40-292eb01e58b2
void main(List<String> args) async {
  try {
    final client = bumblebee.Client(server: Uri.parse(args[0]));
    bumblebee.Event? event = await client.onHeartbeat(() {
      print('Received an heartbeat');
    }).onTerminate(() {
      print('Received the "terminated" event');
    }).onMessage((bumblebee.Event event) {
      print('Received a message of type ${event.type}');
      print('Payload: ${event.data()}');
    }).listen(args[1], (request) {
      request.headers['authorization'] = 'Bearer: <TOKEN>';
    });
    print('Stream completed with signal "${event?.type}"');
    print("Payload: ${event?.data()}");
  } on bumblebee.BumblebeeException catch (e) {
    print(e.message);
    rethrow;
  }
}
