import 'node.dart';

/// Callback used to mutate component state before a rerender is scheduled.
typedef FlintStateUpdater = void Function();

/// Base class for reusable Flint UI components.
abstract class FlintComponent {
  void Function()? _scheduleRender;

  /// Builds the node tree for this component.
  FlintNode build();

  /// Applies [update] and schedules this component to render again.
  void setState(FlintStateUpdater update) {
    update();
    _scheduleRender?.call();
  }

  /// Called after the component is first mounted in the browser.
  void didMount() {}

  /// Called after the component updates following a rerender.
  void didUpdate() {}

  /// Called before the component is removed from the tree.
  void willUnmount() {}

  /// Attaches the render scheduler used by [setState].
  void attach(void Function() scheduleRender) {
    _scheduleRender = scheduleRender;
  }
}

/// Component wrapper for a function that returns a [FlintNode].
class FunctionalComponent extends FlintComponent {
  /// Builds the node tree for this functional component.
  final FlintNode Function() builder;

  /// Creates a component backed by [builder].
  FunctionalComponent(this.builder);

  /// Builds this component by calling [builder].
  @override
  FlintNode build() => builder();
}
