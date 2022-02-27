import 'package:mockito/mockito.dart';
import 'package:podex/podex.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:test_utils/test_utils.dart';

const duration = Duration(milliseconds: 20);

final firstProvider = StateNotifierProvider(
    (ref) => ThrottleFirstNotifier(0, duration: duration));

final lastProvider =
    StateNotifierProvider((ref) => ThrottleLastNotifier(0, duration: duration));

final latestProvider = StateNotifierProvider(
    (ref) => ThrottleLatestNotifier(0, duration: duration));

void main() async {
  late ProviderContainer container;
  late PreviousNextListener listener;

  setUp(() {
    container = ProviderContainer();
    listener = PreviousNextListener();
  });
  tearDownAll(() {
    container.dispose();
  });

  test('ThrottleFirstNotifier', () async {
    container.listen(firstProvider, listener, fireImmediately: true);
    final notifier = container.read(firstProvider.notifier);
    listener.verifyCalledOnce(null, 0);

    notifier.update(1);
    listener.verifyCalledOnce(0, 1);

    100.range(2).forEach(notifier.update);
    await Future.delayed(duration);
    for (var i in 100.range(2)) {
      listener.verifyNotCalled(1, i);
    }

    notifier.update(2);
    listener.verifyCalledOnce(1, 2);

    notifier.update(2);
    listener.verifyNotCalled(2, 2);

    expect(notifier.toString(), 'ThrottleFirstNotifier<int>{state: 2}');

    verifyNoMoreInteractions(listener);
  });

  test('ThrottleLastNotifier', () async {
    container.listen(lastProvider, listener, fireImmediately: true);
    listener.verifyCalledOnce(null, 0);
    final notifier = container.read(lastProvider.notifier);

    notifier.update(1);
    listener.verifyNotCalled(0, 1);

    await Future.delayed(duration);
    listener.verifyCalledOnce(0, 1);

    100.range(2).forEach(notifier.update);
    await Future.delayed(duration);
    for (var i in 99.range(2)) {
      listener.verifyNotCalled(1, i);
    }
    listener.verifyCalledOnce(1, 101);

    notifier.update(101);
    await Future.delayed(duration);
    listener.verifyNotCalled(101, 101);

    expect(notifier.toString(), 'ThrottleLastNotifier<int>{state: 101}');

    verifyNoMoreInteractions(listener);
  });

  test('ThrottleLatestNotifier', () async {
    container.listen(latestProvider, listener, fireImmediately: true);
    listener.verifyCalledOnce(null, 0);
    final notifier = container.read(latestProvider.notifier);

    notifier.update(1);
    listener.verifyCalledOnce(0, 1);
    notifier.update(2);
    listener.verifyNotCalled(1, 2);

    await Future.delayed(duration);
    listener.verifyCalledOnce(1, 2);

    98.range(3).forEach(notifier.update);
    listener.verifyCalledOnce(2, 3);
    await Future.delayed(duration);

    97.range(4).forEach((i) {
      listener.verifyNotCalled(i - 1, i);
    });
    listener.verifyCalledOnce(3, 100);

    notifier.update(101);
    listener.verifyCalledOnce(100, 101);
    await Future.delayed(duration ~/ 2);
    notifier.update(102);
    await Future.delayed(duration ~/ 4);
    notifier.update(-1);
    await Future.delayed(duration ~/ 4);
    listener.verifyNotCalled(101, 102);
    listener.verifyCalledOnce(101, -1);

    /// Multi Cycle
    for (int i = 0; i < 10; i++) {
      notifier.update(i);
      await Future.delayed(duration);
      listener.verifyCalledOnce(i - 1, i);
    }

    expect(notifier.toString(), 'ThrottleLatestNotifier<int>{state: 9}');

    verifyNoMoreInteractions(listener);
  });
}
