part of podex;

class DebouncedStateNotifier<T> extends StateNotifier<T> {
  DebouncedStateNotifier(T value, {required this.duration}) : super(value);

  final Duration duration;
  Timer? _debounce;

  @override
  set state(T value) {
    if (_debounce?.isActive == true) {
      _debounce?.cancel();
    }
    _debounce = Timer(duration, () => super.state = value);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  String toString() {
    return 'DebouncedStateNotifier{state: $state}';
  }
}
