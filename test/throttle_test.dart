import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podex/podex.dart';
import 'package:test_utils/test_utils.dart';

const duration = Duration(milliseconds: 5);

final firstProvider = StateNotifierProvider(
    (ref) => ThrottleFirstStateNotifier(0, duration: duration));

final lastProvider = StateNotifierProvider(
    (ref) => ThrottleLastStateNotifier(0, duration: duration));

final latestProvider = StateNotifierProvider(
    (ref) => ThrottleLatestStateNotifier(0, duration: duration));

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

  test('ThrottleFirstStateNotifier', () async {
    container.listen(firstProvider, listener, fireImmediately: true);
    final notifier = container.read(firstProvider.notifier);
    listener.verifyCalledOnce(null, 0);

    notifier.update(1);
    listener.verifyCalledOnce(0, 1);

    final elements = Generator.seqElements(100, 2);
    elements.forEach(notifier.update);
    await Future.delayed(duration);
    for (var i in elements) {
      listener.verifyNotCalled(1, i);
    }

    notifier.update(2);
    listener.verifyCalledOnce(1, 2);

    notifier.update(2);
    listener.verifyNotCalled(2, 2);
  });

  test('ThrottleLastStateNotifier', () async {
    container.listen(lastProvider, listener, fireImmediately: true);
    listener.verifyCalledOnce(null, 0);
    final notifier = container.read(lastProvider.notifier);

    notifier.update(1);
    listener.verifyNotCalled(0, 1);

    await Future.delayed(duration);
    listener.verifyCalledOnce(0, 1);

    Generator.seqElements(100, 2).forEach(notifier.update);
    await Future.delayed(duration);
    for (var i in Generator.seqElements(99, 2)) {
      listener.verifyNotCalled(1, i);
    }
    listener.verifyCalledOnce(1, 101);

    notifier.update(101);
    await Future.delayed(duration);
    listener.verifyNotCalled(101, 101);
  });

  test('ThrottleLatestStateNotifier', () async {
    container.listen(latestProvider, listener, fireImmediately: true);
    listener.verifyCalledOnce(null, 0);
    final notifier = container.read(latestProvider.notifier);

    notifier.update(1);
    listener.verifyCalledOnce(0, 1);
    notifier.update(2);
    listener.verifyNotCalled(1, 2);

    await Future.delayed(duration);
    listener.verifyCalledOnce(1, 2);

    Generator.seqElements(98, 3).forEach(notifier.update);
    listener.verifyCalledOnce(2, 3);
    await Future.delayed(duration);
    listener.verifyCalledOnce(3, 100);

    notifier.update(101);
    listener.verifyCalledOnce(100, 101);
    await Future.delayed(duration ~/ 2);
    notifier.update(101);
    await Future.delayed(duration ~/ 4);
    notifier.update(102);
    await Future.delayed(duration ~/ 4);
    listener.verifyNotCalled(100, 101);
    listener.verifyCalledOnce(101, 102);
  });
}
