part of podex;

class ReplayNotifier<T> extends StateNotifier<T>
    with _StateNotifierUpdateMixin<T> {
  ReplayNotifier(state, {this.size = 10})
      : _queue = Queue.from([state]),
        super(state) {
    throw UnimplementedError();
  }

  @override
  set state(T value) {
    _queue.addFirst(value);
    super.state = value;
  }

  final int size;

  final Queue<T> _queue;

  void undo() {
    // todo
  }

  void redo() {
    // todo
  }
}
