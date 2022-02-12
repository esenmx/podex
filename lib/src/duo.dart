part of podex;

/// Useful for relative animations like stock price up/down flash
class DuoStateNotifier<T> extends StateNotifier<T> {
  DuoStateNotifier(initialValue, {this.comparator, T? initialPrevious})
      : _previous = initialPrevious,
        super(initialValue);

  final Comparator? comparator;
  T? _previous;

  @override
  set state(T value) {
    _previous = state;
    super.state = value;
  }

  T? get previous => _previous;

  bool? get isIncreased {
    if (comparator == null || _previous == null) {
      return null;
    }
    return comparator!(state, _previous!) > 0;
  }
}
