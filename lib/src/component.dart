import 'node.dart';

typedef FlintStateUpdater = void Function();

abstract class FlintComponent {
  void Function()? _scheduleRender;

  FlintNode build();

  void setState(FlintStateUpdater update) {
    update();
    _scheduleRender?.call();
  }

  void didMount() {}

  void didUpdate() {}

  void willUnmount() {}

  void attach(void Function() scheduleRender) {
    _scheduleRender = scheduleRender;
  }
}

class FunctionalComponent extends FlintComponent {
  final FlintNode Function() builder;

  FunctionalComponent(this.builder);

  @override
  FlintNode build() => builder();
}
