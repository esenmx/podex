part of podex;

class ThrottleFirstNotifier<T> extends StateNotifier<T>
    with _PodexStateNotifierMixin<T> {
  ThrottleFirstNotifier(T state, {required this.duration}) : super(state);

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

class ThrottleLastNotifier<T> extends StateNotifier<T>
    with _PodexStateNotifierMixin<T> {
  ThrottleLastNotifier(T state, {required this.duration}) : super(state);

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

class ThrottleLatestNotifier<T> extends StateNotifier<T>
    with _PodexStateNotifierMixin<T> {
  ThrottleLatestNotifier(T state, {required this.duration}) : super(state);

  final Duration duration;
  Timer? _timer;
  late T _temp;
  bool _hasLatest = false;

  @override
  set state(T value) {
    if (_timer?.isActive != true) {
      super.state = value;
      _timer = Timer(duration, () {
        if (_hasLatest) {
          super.state = _temp;
          _hasLatest = false;
        }
      });
    } else {
      _temp = value;
      _hasLatest = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
