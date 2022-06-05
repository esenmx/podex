library podex;

import 'dart:async';
import 'dart:collection';

import 'package:state_notifier/state_notifier.dart';

part 'src/debounced.dart';
part 'src/duo.dart';
part 'src/replay.dart';
part 'src/throttle.dart';

/// Syntax sugar for referential assignment;
/// Instead:
/// ```dart
/// onSelect: (x) => ref.read(stateProvider.notifier).state = x
/// ```
/// Do:
/// ```dart
/// onSelect: ref.read(stateProvider.notifier).update
/// ```
mixin _Mixin<T> on StateNotifier<T> {
  void update(T value) {
    state = value;
  }

  @override
  String toString() {
    return '$runtimeType{state: $state}';
  }
}
