part of podex;

class DuoNotifier<T> extends StateNotifier<T> with _Mixin {
  DuoNotifier(super.state, [this._previous]);

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
