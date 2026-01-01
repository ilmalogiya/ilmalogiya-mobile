import 'dart:async';
import 'dart:ui';

class SearchDelayer {
  Timer? _timer;

  void run(
    VoidCallback action, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
