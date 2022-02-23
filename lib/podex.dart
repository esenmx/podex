library podex;

import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
mixin _StateNotifierUpdateMixin<T> on StateNotifier<T> {
  void update(T value) {
    state = value;
  }
}
