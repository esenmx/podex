// import 'package:clock/clock.dart';
// import 'package:fake_async/fake_async.dart';
// import 'package:podex/podex.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:test/expect.dart';
// import 'package:test/scaffolding.dart';

// const d = Duration(seconds: 1);

// final stopwatch = StateNotifierProvider<StopwatchNotifier, Duration>(
//     (ref) => StopwatchNotifier(period: d, stopwatch: clock.stopwatch()));

// void main() {
//   group('StopwatchNotifier', () {
//     late ProviderContainer container;
//     late StopwatchNotifier notifier;
//     setUpAll(() {
//       container = ProviderContainer(
//         overrides: [
//           stopwatch.overrideWithValue(StopwatchNotifier(
//             period: d,
//             stopwatch: clock.stopwatch(),
//           )),
//         ],
//       );
//       notifier = container.read(stopwatch.notifier);
//     });
//     test('double start error', () {
//       notifier.start();
//       expect(() => notifier.start(), throwsA(isA<StateError>()));
//     });
//     test('double stop', () {
//       runWithTiming(() {
//         fakeAsync((async) {
//           async.elapse(d * 10);
//           expect(container.read(stopwatch), equals(d * 10));
//           expect(() => notifier.stop(), throwsA(isA<AssertionError>()));
//         });
//       });
//     });
//   });
// }

// T runWithTiming<T>(T Function() callback) {
//   var stopwatch = clock.stopwatch()..start();
//   var result = callback();
//   print('It took ${stopwatch.elapsed}!');
//   return result;
// }
