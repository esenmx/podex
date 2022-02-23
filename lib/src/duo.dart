part of podex;

typedef DuoStateCallback<T> = void Function(T? previous, T next);

/// Useful for relative animations like stock price up/down flash
/// or relative animations for indexed stacks etc.
class DuoStateNotifier<T> extends StateNotifier<T>
    with _StateNotifierUpdateMixin<T> {
  DuoStateNotifier(
    initialState, {
    T? initialPrevious,
    this.comparator,
    this.onIncrease,
    this.onDecrease,
  })  : _previous = initialPrevious,
        assert((comparator == null) == (onIncrease == null),
            'comparator required for onIncrease'),
        assert((comparator == null) == (onDecrease == null),
            'comparator required for onDecrease'),
        super(initialState);

  T? _previous;
  final Comparator? comparator;
  final DuoStateCallback? onIncrease;
  final DuoStateCallback? onDecrease;

  @override
  set state(T value) {
    switch (isIncreased(value, state)) {
      case true:
        onIncrease?.call(value, state);
        break;
      case false:
        onDecrease?.call(value, state);
        break;
    }
    _previous = state;
    super.state = value;
  }

  T? get previous => _previous;

  bool? isIncreased(T? previous, T next) {
    if (comparator == null || previous == null) {
      return null;
    }
    return comparator!(state, previous) > 0;
  }
}
