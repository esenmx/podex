part of podex;

class DebouncedStateNotifier<T> extends StateNotifier<T> {
  DebouncedStateNotifier(T value, {required this.duration}) : super(value);

  final Duration duration;
  Timer? _timer;

  @override
  set state(T value) {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
    _timer = Timer(duration, () => super.state = value);
  }

  void update(T value) {
    state = value;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  String toString() {
    return 'DebouncedStateNotifier{state: $state}';
  }
}
