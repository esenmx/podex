part of podex;

class StopwatchNotifier extends StateNotifier<Duration> {
  StopwatchNotifier({
    required this.period,
    this.stopAt,
    @visibleForTesting Stopwatch? stopwatch,
  })  : stopwatch = stopwatch ?? Stopwatch(),
        super(Duration.zero);

  final Duration period;
  final Duration? stopAt;

  final Stopwatch stopwatch;
  Timer? _ticker;

  void _setTicker() {
    _ticker = Timer.periodic(period, (timer) {
      state = stopwatch.elapsed;
      if (stopAt != null) {
        if (state >= stopAt!) {
          stopwatch.stop();
          timer.cancel();
        }
      }
    });
  }

  void start() {
    if (stopwatch.isRunning) {
      throw StateError('start() called consecutively');
    }
    stopwatch.start();
    _setTicker();
  }

  void stop() {
    assert(stopwatch.isRunning, 'stop() called when stopwatch is not running');
    stopwatch.stop();
    _ticker?.cancel();
  }

  void reset() {
    _ticker?.cancel();
    state = Duration.zero;
    stopwatch.reset();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    stopwatch.stop();
    super.dispose();
  }
}
