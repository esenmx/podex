part of podex;

class ThrottleFirstNotifier<T> extends StateNotifier<T> with _Mixin<T> {
  ThrottleFirstNotifier(super.state, {required this.duration});

  final Duration duration;

  Timer? _timer;

  @override
  set state(T value) {
    if (_timer?.isActive != true) {
      super.state = value;
      _timer = Timer(duration, () {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class ThrottleLastNotifier<T> extends StateNotifier<T> with _Mixin<T> {
  ThrottleLastNotifier(super.state, {required this.duration});

  final Duration duration;

  Timer? _timer;
  late T _last;

  @override
  set state(T value) {
    _last = value;
    if (_timer?.isActive != true) {
      _timer = Timer(duration, () => super.state = _last);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class ThrottleLatestNotifier<T> extends StateNotifier<T> with _Mixin<T> {
  ThrottleLatestNotifier(super.state, {required this.duration});

  final Duration duration;

  Timer? _timer;
  T? _pending;

  @override
  set state(T value) {
    if (_timer?.isActive != true) {
      super.state = value;
      _timer = Timer(duration, () {
        if (_pending != null) {
          super.state = _pending as T;
          _pending = null;
        }
      });
    } else {
      _pending = value;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
