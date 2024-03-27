
import 'dart:async';
import 'dart:ui';

class Debouncer {
  Duration? delay;
  VoidCallback? _action;
  Timer? _timer;

  Debouncer({this.delay});

  void run(VoidCallback action) {
    _action = action;
    _timer?.cancel();
    if (delay != null) {
      _timer = Timer(delay!, () {
        if (_action != null) {
          _action!();
        }
      });
    }
  }

  void cancel() {
    _timer?.cancel();
    _action = null;
  }
}
