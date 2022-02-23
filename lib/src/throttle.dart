part of podex;

class ThrottleFirstStateNotifier<T> extends StateNotifier<T>
    with _StateNotifierUpdateMixin<T> {
  ThrottleFirstStateNotifier(T state, {required this.duration}) : super(state);

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

class ThrottleLastStateNotifier<T> extends StateNotifier<T>
    with _StateNotifierUpdateMixin<T> {
  ThrottleLastStateNotifier(T state, {required this.duration}) : super(state);

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

class ThrottleLatestStateNotifier<T> extends StateNotifier<T>
    with _StateNotifierUpdateMixin<T> {
  ThrottleLatestStateNotifier(T state, {required this.duration}) : super(state);

  final Duration duration;
  Timer? _timer;
  late T _latest;
  bool _hasLatest = false;

  @override
  set state(T value) {
    if (_timer?.isActive != true) {
      super.state = value;
      _timer = Timer(duration, () {
        if (_hasLatest) {
          _hasLatest = false;
          super.state = _latest;
        }
      });
    } else {
      _hasLatest = true;
      _latest = value;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
