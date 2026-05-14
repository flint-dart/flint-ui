import 'node.dart';

/// Function signature used by the FlintStateUpdater API.
typedef FlintStateUpdater = void Function();

/// Represents the FlintComponent API in Flint UI.
abstract class FlintComponent {
  /// Runs the Function operation.
  void Function()? _scheduleRender;

  /// Runs the build operation.
  FlintNode build();

  /// Runs the setState operation.
  void setState(FlintStateUpdater update) {
    update();
    _scheduleRender?.call();
  }

  /// Runs the didMount operation.
  void didMount() {}

  /// Runs the didUpdate operation.
  void didUpdate() {}

  /// Runs the willUnmount operation.
  void willUnmount() {}

  /// Runs the attach operation.
  void attach(void Function() scheduleRender) {
    _scheduleRender = scheduleRender;
  }
}

/// Represents the FunctionalComponent API in Flint UI.
class FunctionalComponent extends FlintComponent {
  /// The builder value.
  final FlintNode Function() builder;

  /// Creates a FunctionalComponent instance.
  FunctionalComponent(this.builder);

  @override
  /// Runs the build operation.
  FlintNode build() => builder();
}
