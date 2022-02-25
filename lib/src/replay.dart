part of podex;

class ReplayNotifier<T> extends StateNotifier<T>
    with _StateNotifierUpdateMixin<T> {
  ReplayNotifier(T initialState, {this.capacity = 10})
      : _queue = Queue<T>.of([initialState]),
        super(initialState);

  final int capacity;

  Queue<T> _queue;
  int _currentIndex = 0;

  @override
  set state(T value) {
    if (_currentIndex > 0) {
      _queue = Queue<T>.of(_queue.skip(_currentIndex));
      _queue.addFirst(value);
      _currentIndex = 0;
    } else {
      _queue.addFirst(value);
      if (_queue.length > capacity) {
        _queue.removeLast();
      }
    }
    super.state = value;
  }

  void redo() {
    if (_currentIndex == 0) {
      throw StateError('''
      not able to `redo()`, if you cannot control the state,
       please use `canRedo` getter for checking the state
      ''');
    }
    super.state = _queue.elementAt(--_currentIndex);
  }

  void undo() {
    if (_currentIndex + 1 == _queue.length) {
      throw StateError('''
      not able to `undo()`, if you cannot control the state,
       please use `canUndo` getter for checking the state
      ''');
    }
    super.state = _queue.elementAt(++_currentIndex);
  }

  bool get canUndo => _currentIndex < (_queue.length - 1);

  bool get canRedo => _currentIndex > 0;
}
