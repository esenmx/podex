part of podex;

class DebouncedNotifier<T> extends StateNotifier<T> with _Mixin<T> {
  DebouncedNotifier(super.state, {required this.duration});

  final Duration duration;

  Timer? _timer;

  @override
  set state(T value) {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    _timer = Timer(duration, () => super.state = value);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// TODO
/// https://twitter.com/remi_rousselet/status/1493522569005305858
///
// extension DebounceRefExtension on Ref {
//   Future<void> debounce(Duration duration) async {
//     final completer = Completer<void>();
//     final timer = Timer(duration, () {
//       if (!completer.isCompleted) {
//         completer.complete();
//       }
//     });
//     onDispose(() {
//       timer.cancel();
//       if (!completer.isCompleted) {
//         completer.completeError(StateError('completed'));
//       }
//     });
//     return completer.future;
//   }
// }
