
import 'debouncer.dart';

class FunctionDeBouncer extends DeBouncer<Function> {
  FunctionDeBouncer([super.duration]);

  @override
  void doOnListen(event) {
    event.call();
  }
}
