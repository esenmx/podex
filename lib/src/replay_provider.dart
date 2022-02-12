part of podex;

class ReplayProvider<S> extends StateNotifier<S> {
  ReplayProvider(state, {this.size = 10})
      : _queue = Queue.from([state]),
        super(state);

  @override
  set state(S value) {
    _queue.addFirst(value);
    super.state = value;
  }

  final int size;

  final Queue<S> _queue;

  void undo() {
    throw UnimplementedError();
  }

  void redo() {
    throw UnimplementedError();
  }
}
