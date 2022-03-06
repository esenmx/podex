# podex

Collection of custom `StateNotifier`s. [Riverpod](https://pub.dev/packages/riverpod)
/ [StateNotifierProvider](https://pub.dev/documentation/riverpod/latest/riverpod/StateNotifierProvider-class.html)
or [Provider](https://pub.dev/packages/provider)
/ [LocatorMixin](https://pub.dev/documentation/state_notifier/latest/state_notifier/LocatorMixin-mixin.html)

Notifiers:

### ReplayNotifier

Similar to [ReplaySubject](http://reactivex.io/RxJava/3.x/javadoc/io/reactivex/rxjava3/subjects/ReplaySubject.html).
Keeps previous states as many as `capacity` allows. Has `undo()`, `redo()` methods.

### DebouncedNotifier

Similar to Rx.debounce(). See docs: [debounce()](https://reactivex.io/documentation/operators/debounce.html)

![ThrottleFirst!](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/debounce.png)

### ThrottleFirstNotifier

![ThrottleFirst!](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/throttleFirst.png)

### ThrottleLastNotifier

![ThrottleFirst!](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/throttleLast.png)

### ThrottleLatestNotifier

![ThrottleFirst!](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/throttleLatest.png)