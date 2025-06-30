import 'package:rxdart/rxdart.dart';

abstract class DeBouncer<T> {
  final BehaviorSubject<T> _behaviorSubject = BehaviorSubject();

  DeBouncer([int? duration]) {
    _behaviorSubject
        .debounce((event) =>
            TimerStream(true, Duration(milliseconds: duration ?? 450)))
        .listen(doOnListen);
  }

  void doOnListen(T event);

  void add(T event) {
    _behaviorSubject.add(event);
  }

  void dispose() {
    _behaviorSubject.close();
  }
}
