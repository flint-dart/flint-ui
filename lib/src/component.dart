import 'node.dart';

/// Callback used to mutate component state before a rerender is scheduled.
typedef FlintStateUpdater = void Function();

/// Short public alias for [FlintComponent] in app code and examples.
typedef Component = FlintComponent;

/// Return type for component build methods.
///
/// A view can be a node, another component, text, or an iterable of renderable
/// values. Flint normalizes it before rendering.
typedef View = Object?;

/// Base class for reusable Flint UI components.
abstract class FlintComponent extends FlintNode {
  /// Creates a reusable Flint UI component.
  FlintComponent();

  void Function()? _scheduleRender;

  /// Builds this component's renderable output.
  ///
  /// App code can return a node, another component, text, or an iterable of
  /// renderable values. The renderer normalizes the value internally.
  View build();

  /// Applies [update] and schedules this component to render again.
  void setState(FlintStateUpdater update) {
    update();
    _scheduleRender?.call();
  }

  /// Called after the component is first mounted in the browser.
  void didMount() {}

  /// Called after the component updates following a rerender.
  void didUpdate() {}

  /// Receives the next component instance when Flint preserves this instance.
  ///
  /// Override this in stateful components that also accept constructor values.
  /// Flint keeps the existing instance so local state survives, then gives it
  /// the newly-created component so props-like fields can be copied in.
  void updateFrom(covariant FlintComponent next) {}

  /// Called before the component is removed from the tree.
  void willUnmount() {}

  /// Attaches the render scheduler used by [setState].
  void attach(void Function() scheduleRender) {
    _scheduleRender = scheduleRender;
  }
}

/// Component wrapper for a function that returns renderable output.
class FunctionalComponent extends FlintComponent {
  /// Builds the node tree for this functional component.
  final View Function() builder;

  /// Creates a component backed by [builder].
  FunctionalComponent(this.builder);

  /// Builds this component by calling [builder].
  @override
  View build() => builder();
}
