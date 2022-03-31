import 'package:podex/podex.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:test_utils/test_utils.dart';

const duration = Duration(milliseconds: 5);

final debounced = StateNotifierProvider(
    (ref) => DebouncedNotifier<String>('', duration: duration));

void main() async {
  test('Debounced', () async {
    final container = createProviderContainer();
    final listener = PreviousNextListener();
    final notifier = container.read(debounced.notifier);

    container.listen(debounced, listener);
    expect(container.read(debounced), '');

    notifier.update('asd');
    listener.verifyNotCalled('', 'asd');
    await Future.delayed(duration);
    listener.verifyCalledOnce('', 'asd');

    // Sequential update within debounce duration
    for (int i = 0; i < 10; i++) {
      await Future.delayed(duration ~/ 2);
      notifier.update(i.toString());
    }
    // Ensuring state is not updated except the last update
    await Future.delayed(duration);
    for (int i = 1; i < 10; i++) {
      listener.verifyNotCalled((i - 1).toString(), i.toString());
    }
    // Ensuring last update is emitted
    listener.verifyCalledOnce('asd', '9');

    // toString
    expect(notifier.toString(), 'DebouncedNotifier<String>{state: 9}');
  });
}
