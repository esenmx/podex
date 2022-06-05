part of podex;

class DuoNotifier<T> extends StateNotifier<T> with _Mixin {
  DuoNotifier(T initialState, [T? initialPrevious])
      : _previous = initialPrevious,
        super(initialState);

  T? _previous;

  @override
  set state(value) {
    _previous = state;
    super.state = value;
  }

  T? get previous => _previous;

  @override
  String toString() {
    return '$runtimeType{state: $state, previous: $_previous}';
  }
}
