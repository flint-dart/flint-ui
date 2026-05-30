import 'node.dart';

/// Callback used to mutate component state before a rerender is scheduled.
typedef FlintStateUpdater = void Function();

/// Backwards-compatible alias for [StatefulComponent].
///
/// Prefer extending [StatefulComponent] or [StatelessComponent] in new code so
/// state preservation is explicit at the class declaration.
typedef Component = StatefulComponent;

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

  /// Whether Flint should preserve this component instance across parent
  /// rerenders when the runtime type and tree position match.
  ///
  /// Stateful components keep the default so local fields, controllers, and
  /// subscriptions survive rerenders. Components that only display constructor
  /// values should extend [StatelessComponent] instead.
  bool get preserveState => true;

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

/// Base class for components that own local state or lifecycle resources.
///
/// Flint preserves stateful component instances across parent rerenders when
/// the runtime type and tree position match. Use this for pages, controllers,
/// sockets, subscriptions, text editing controllers, and other local state.
abstract class StatefulComponent extends FlintComponent {}

/// Base class for components that only render constructor-provided values.
///
/// Flint replaces stateless component instances during parent rerenders so
/// final fields naturally receive the newest values without an [updateFrom]
/// override.
abstract class StatelessComponent extends FlintComponent {
  @override
  bool get preserveState => false;
}

/// Component wrapper for a function that returns renderable output.
class FunctionalComponent extends StatelessComponent {
  /// Builds the node tree for this functional component.
  final View Function() builder;

  /// Creates a component backed by [builder].
  FunctionalComponent(this.builder);

  /// Builds this component by calling [builder].
  @override
  View build() => builder();
}
