import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mx_notifiers/mx_notifiers.dart';
import 'package:test_utils/test_utils.dart';

final replay = StateNotifierProvider((ref) => ReplayNotifier<int>(1));

void main() async {
  test('Replay', () async {
    final container = ProviderContainer();
    final listener = PreviousNextListener();
    addTearDown(container.dispose);
    final notifier = container.read(replay.notifier);

    container.listen(replay, listener);
    expect(container.read(replay), 1);
    expect(notifier.canRedo, false);
    expect(notifier.canUndo, false);

    /// Update
    notifier.update(2);
    listener.verifyCalledOnce(1, 2);
    expect(container.read(replay), 2);
    expect(notifier.canUndo, true);
    expect(notifier.canRedo, false);

    /// Undo
    notifier.undo();
    listener.verifyCalledOnce(2, 1);
    expect(container.read(replay), 1);
    expect(notifier.canUndo, false);
    expect(notifier.canRedo, true);

    expect(() => notifier.undo(), throwsA(isA<StateError>()));

    /// Redo
    notifier.redo();
    listener.verifyCalledOnce(1, 2);
    expect(container.read(replay), 2);
    expect(notifier.canUndo, true);
    expect(notifier.canRedo, false);

    expect(() => notifier.redo(), throwsA(isA<StateError>()));

    /// Fill
    for (int i = 3; i <= 10; i++) {
      notifier.update(i);
      expect(container.read(replay), i);
      expect(notifier.canUndo, true);
      expect(notifier.canRedo, false);
    }

    /// Clear
    for (int i = 10; i > 1; i--) {
      expect(container.read(replay), i);
      expect(notifier.canUndo, i > 1);
      expect(notifier.canRedo, i < 10);
      notifier.undo();
    }

    /// Break Sequence
    notifier
      ..update(2) // [1, 2]
      ..update(3) // [1, 2, 3]
      ..undo() // [1, 2]
      ..update(4); // [1, 2, 4]
    expect(container.read(replay), 4);
    notifier.undo();
    expect(container.read(replay), 2);
    notifier.undo();
    expect(container.read(replay), 1);
    expect(() => notifier.undo(), throwsA(isA<StateError>()));
    notifier.redo();
    expect(container.read(replay), 2);
    notifier.redo();
    expect(container.read(replay), 4);
    expect(() => notifier.redo(), throwsA(isA<StateError>()));

    /// OverFill
    for (int i = 0; i < 100; i++) {
      notifier.update(i);
    }
    expect(container.read(replay), 99);
    for (int i = 1; i < 10; i++) {
      notifier.undo();
      expect(container.read(replay), 99 - i);
    }
    expect(() => notifier.undo(), throwsA(isA<StateError>()));
  });
}
