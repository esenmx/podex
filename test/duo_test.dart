import 'package:mockito/mockito.dart';
import 'package:podex/podex.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:test_utils/test_utils.dart';

final debounced = StateNotifierProvider((ref) => DuoNotifier<int>(0, 1));

void main() async {
  test('Duo', () async {
    final container = createProviderContainer();
    final listener = PreviousNextListener();

    final notifier = container.read(debounced.notifier);
    container.listen(debounced, listener);
    verifyZeroInteractions(listener);
    expect(container.read(debounced), 0);
    expect(notifier.previous, 1);

    notifier.state = 2;
    listener.verifyCalledOnce(0, 2);
    notifier.state = 2;
    listener.verifyNotCalled(2, 2);

    notifier.state = 3;
    listener.verifyCalledOnce(2, 3);

    verifyNoMoreInteractions(listener);
  });
}
