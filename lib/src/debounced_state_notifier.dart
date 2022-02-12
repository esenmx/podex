part of podex;

class DebouncedStateNotifier<S> extends StateNotifier<S> {
  DebouncedStateNotifier(S value, {this.duration = const Duration(milliseconds: 300)}) : super(value);

  final Duration duration;
  Timer? _debounce;

  @override
  set state(S value) {
    if (_debounce?.isActive == true) {
      _debounce?.cancel();
    }
    _debounce = Timer(duration, () => super.state = value);
  }

  @override
  String toString() {
    return 'DebouncedStateNotifier{state: $state}';
  }
}
