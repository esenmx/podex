import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:podex/podex.dart';
import 'package:test_utils/test_utils.dart';

const duration = Duration(milliseconds: 10);

final debounced = StateNotifierProvider(
    (ref) => DebouncedStateNotifier<String>('', duration: duration));

void main() async {
  test('Debounced', () async {
    final container = ProviderContainer();
    final listener = PreviousNextListener();
    addTearDown(container.dispose);

    container.listen(debounced, listener);
    expect(container.read(debounced), '');
    verifyNoMoreInteractions(listener);

    container.read(debounced.notifier).update('asd');
    listener.verifyNotCalled('', 'asd');
    await Future.delayed(duration);
    listener.verifyCalledOnce('', 'asd');
    for (int i = 0; i < 10; i++) {
      await Future.delayed(duration ~/ 2);
      container.read(debounced.notifier).update(i.toString());
    }
    await Future.delayed(duration);
    for (int i = 1; i < 10; i++) {
      listener.verifyNotCalled((i - 1).toString(), i.toString());
    }
  });
}
