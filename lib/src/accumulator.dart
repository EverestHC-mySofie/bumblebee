import 'package:bumblebee/bumblebee.dart';
import 'package:bumblebee/src/line_parser.dart';

class Bridge {
  Function(Event)? onMessage;
  Function? onHeartbeat;
  Function? onTerminate;
}

class Accumulator {
  Event? _currentEvent;
  Event? completionEvent;

  final Bridge _bridge;

  Accumulator(this._bridge);

  nextLine(dataLine) {
    if (LineParser.isEvent(dataLine)) {
      _handleEvent(dataLine);
    } else if (LineParser.isData(dataLine)) {
      _handleData(dataLine);
    } else if (LineParser.isComment(dataLine)) {
      _handleHeartbeat(dataLine);
    } else if (LineParser.isEmptyLine(dataLine)) {
      _handleClose(dataLine);
    }
  }

  _handleHeartbeat(dataLine) {
    _bridge.onHeartbeat!();
  }

  _handleEvent(dataLine) {
    if (_currentEvent != null) {
      throw InvalidStateException(
          'Creating an event when previous one has not been properly closed');
    }
    String? type = LineParser.value(dataLine);
    if (type == null) {
      throw InvalidStateException('Creating an event without a type');
    }
    _currentEvent = Event(type);
  }

  _handleData(dataLine) {
    if (_currentEvent == null) {
      throw InvalidStateException('Attempting to push data to a null event');
    }
    _currentEvent!.append(LineParser.value(dataLine));
  }

  _handleClose(dataLine) {
    if (_currentEvent != null) {
      _yield(_currentEvent);
    }
    _currentEvent = null;
  }

  _yield(Event? currentEvent) {
    if (_currentEvent != null) {
      switch (currentEvent!.type) {
        case 'completed' || 'failed':
          completionEvent = _currentEvent;
          _terminateOrComplete();
        case 'terminated':
          _onTerminate();
        default:
          _onMessage();
      }
    }
  }

  _terminateOrComplete() {
    completionEvent = _currentEvent;
    _onMessage();
  }

  _onMessage() {
    if (_bridge.onMessage != null) {
      _bridge.onMessage!(_currentEvent!);
    }
  }

  _onTerminate() {
    if (_bridge.onTerminate != null) {
      _bridge.onTerminate!();
    }
  }
}
