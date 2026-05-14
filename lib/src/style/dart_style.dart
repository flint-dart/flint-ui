part of '../style.dart';

/// Represents the DartStyle API in Flint UI.
class DartStyle {
  /// The padding value.
  final EdgeInsets? padding;

  /// The margin value.
  final EdgeInsets? margin;

  /// The width value.
  final Object? width;

  /// The height value.
  final Object? height;

  /// The minWidth value.
  final Object? minWidth;

  /// The maxWidth value.
  final Object? maxWidth;

  /// The minHeight value.
  final Object? minHeight;

  /// The maxHeight value.
  final Object? maxHeight;

  /// The display value.
  final Display? display;

  /// The gap value.
  final Object? gap;

  /// The alignItems value.
  final AlignItems? alignItems;

  /// The justifyItems value.
  final Object? justifyItems;

  /// The justifyContent value.
  final JustifyContent? justifyContent;

  /// The flex value.
  final Object? flex;

  /// The flexDirection value.
  final FlexDirection? flexDirection;

  /// The flexWrap value.
  final Object? flexWrap;

  /// The flexGrow value.
  final Object? flexGrow;

  /// The flexShrink value.
  final Object? flexShrink;

  /// The flexBasis value.
  final Object? flexBasis;

  /// The gridTemplateColumns value.
  final String? gridTemplateColumns;

  /// The position value.
  final Position? position;

  /// The top value.
  final Object? top;

  /// The right value.
  final Object? right;

  /// The bottom value.
  final Object? bottom;

  /// The left value.
  final Object? left;

  /// The zIndex value.
  final int? zIndex;

  /// The overflow value.
  final Object? overflow;

  /// The boxSizing value.
  final Object? boxSizing;

  /// The scrollBehavior value.
  final Object? scrollBehavior;

  /// The aspectRatio value.
  final Object? aspectRatio;

  /// The objectFit value.
  final Object? objectFit;

  /// The transform value.
  final Object? transform;

  /// The backdropFilter value.
  final Object? backdropFilter;

  /// The fontFamily value.
  final Object? fontFamily;

  /// The fontSize value.
  final Object? fontSize;

  /// The fontWeight value.
  final Object? fontWeight;

  /// The lineHeight value.
  final Object? lineHeight;

  /// The color value.
  final Object? color;

  /// The textAlign value.
  final TextAlign? textAlign;

  /// The textTransform value.
  final Object? textTransform;

  /// The textDecoration value.
  final Object? textDecoration;

  /// The cursor value.
  final Object? cursor;

  /// The resize value.
  final Object? resize;

  /// The background value.
  final Object? background;

  /// The radius value.
  final Object? radius;

  /// The border value.
  final Border? border;

  /// The borderTop value.
  final Border? borderTop;

  /// The borderRight value.
  final Border? borderRight;

  /// The borderBottom value.
  final Border? borderBottom;

  /// The borderLeft value.
  final Border? borderLeft;

  /// The shadow value.
  final Object? shadow;

  /// The opacity value.
  final double? opacity;

  /// The gradient value.
  final Object? gradient;

  /// The transition value.
  final Object? transition;

  /// The animation value.
  final Object? animation;

  /// The willChange value.
  final Object? willChange;

  /// The hover value.
  final DartStyle? hover;

  /// The focus value.
  final DartStyle? focus;

  /// The focusVisible value.
  final DartStyle? focusVisible;

  /// The active value.
  final DartStyle? active;

  /// The disabled value.
  final DartStyle? disabled;

  /// The checked value.
  final DartStyle? checked;

  /// The selected value.
  final DartStyle? selected;

  /// The expanded value.
  final DartStyle? expanded;

  /// The invalid value.
  final DartStyle? invalid;

  /// The sm value.
  final DartStyle? sm;

  /// The md value.
  final DartStyle? md;

  /// The lg value.
  final DartStyle? lg;

  /// The xl value.
  final DartStyle? xl;

  /// Creates a DartStyle instance.
  const DartStyle({
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.display,
    this.gap,
    this.alignItems,
    this.justifyItems,
    this.justifyContent,
    this.flex,
    this.flexDirection,
    this.flexWrap,
    this.flexGrow,
    this.flexShrink,
    this.flexBasis,
    this.gridTemplateColumns,
    this.position,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.zIndex,
    this.overflow,
    this.boxSizing,
    this.scrollBehavior,
    this.aspectRatio,
    this.objectFit,
    this.transform,
    this.backdropFilter,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.color,
    this.textAlign,
    this.textTransform,
    this.textDecoration,
    this.cursor,
    this.resize,
    this.background,
    this.radius,
    this.border,
    this.borderTop,
    this.borderRight,
    this.borderBottom,
    this.borderLeft,
    this.shadow,
    this.opacity,
    this.gradient,
    this.transition,
    this.animation,
    this.willChange,
    this.hover,
    this.focus,
    this.focusVisible,
    this.active,
    this.disabled,
    this.checked,
    this.selected,
    this.expanded,
    this.invalid,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  });

  /// Runs the toMap operation.
  Map<String, Object?> toMap() {
    return _withoutNulls({
      'padding': padding?.toCss(),
      'margin': margin?.toCss(),
      'width': cssValue(width),
      'height': cssValue(height),
      'min-width': cssValue(minWidth),
      'max-width': cssValue(maxWidth),
      'min-height': cssValue(minHeight),
      'max-height': cssValue(maxHeight),
      'display': display?.css,
      'gap': cssValue(gap),
      'align-items': alignItems?.css,
      'justify-items': cssValue(justifyItems, unitlessNumber: true),
      'justify-content': justifyContent?.css,
      'flex': cssValue(flex, unitlessNumber: true),
      'flex-direction': flexDirection?.css,
      'flex-wrap': cssValue(flexWrap, unitlessNumber: true),
      'flex-grow': cssValue(flexGrow, unitlessNumber: true),
      'flex-shrink': cssValue(flexShrink, unitlessNumber: true),
      'flex-basis': cssValue(flexBasis),
      'grid-template-columns': gridTemplateColumns,
      'position': position?.css,
      'top': cssValue(top),
      'right': cssValue(right),
      'bottom': cssValue(bottom),
      'left': cssValue(left),
      'z-index': zIndex,
      'overflow': cssValue(overflow, unitlessNumber: true),
      'box-sizing': cssValue(boxSizing, unitlessNumber: true),
      'scroll-behavior': cssValue(scrollBehavior, unitlessNumber: true),
      'aspect-ratio': cssValue(aspectRatio, unitlessNumber: true),
      'object-fit': cssValue(objectFit, unitlessNumber: true),
      'transform': cssValue(transform, unitlessNumber: true),
      'backdrop-filter': cssValue(backdropFilter, unitlessNumber: true),
      'font-family': cssValue(fontFamily, unitlessNumber: true),
      'font-size': cssValue(fontSize),
      'font-weight': cssValue(fontWeight, unitlessNumber: true),
      'line-height': cssValue(lineHeight, unitlessNumber: true),
      'color': cssValue(color),
      'text-align': textAlign?.css,
      'text-transform': cssValue(textTransform, unitlessNumber: true),
      'text-decoration': cssValue(textDecoration, unitlessNumber: true),
      'cursor': cssValue(cursor, unitlessNumber: true),
      'resize': cssValue(resize, unitlessNumber: true),
      'background': cssValue(gradient ?? background),
      'border-radius': cssValue(radius),
      'border': border?.toCss(),
      'border-top': borderTop?.toCss(),
      'border-right': borderRight?.toCss(),
      'border-bottom': borderBottom?.toCss(),
      'border-left': borderLeft?.toCss(),
      'box-shadow': shadow is Shadow
          ? (shadow as Shadow).toCss()
          : cssValue(shadow),
      'opacity': opacity,
      'transition': cssValue(transition, unitlessNumber: true),
      'animation': cssValue(animation, unitlessNumber: true),
      'will-change': cssValue(willChange, unitlessNumber: true),
    });
  }

  /// Returns the hasBreakpoints value.
  bool get hasBreakpoints =>
      sm != null || md != null || lg != null || xl != null;

  /// Returns the hasStateStyles value.
  bool get hasStateStyles =>
      hover != null ||
      focus != null ||
      focusVisible != null ||
      active != null ||
      disabled != null ||
      checked != null ||
      selected != null ||
      expanded != null ||
      invalid != null;

  /// Returns the hasScopedStyles value.
  bool get hasScopedStyles => hasBreakpoints || hasStateStyles;

  /// Returns the breakpointStyles value.
  Map<Breakpoint, DartStyle> get breakpointStyles => {
    if (sm != null) Breakpoint.sm: sm!,
    if (md != null) Breakpoint.md: md!,
    if (lg != null) Breakpoint.lg: lg!,
    if (xl != null) Breakpoint.xl: xl!,
  };

  /// Returns the stateStyles value.
  Map<String, DartStyle> get stateStyles => {
    if (hover != null) ':hover': hover!,
    if (focus != null) ':focus': focus!,
    if (focusVisible != null) ':focus-visible': focusVisible!,
    if (active != null) ':active': active!,
    if (disabled != null) ':disabled': disabled!,
    if (disabled != null) '[aria-disabled="true"]': disabled!,
    if (checked != null) ':checked': checked!,
    if (selected != null) '[aria-selected="true"]': selected!,
    if (expanded != null) '[aria-expanded="true"]': expanded!,
    if (invalid != null) '[aria-invalid="true"]': invalid!,
  };

  /// Runs the merge operation.
  DartStyle merge(DartStyle? override) {
    if (override == null) return this;

    return DartStyle(
      padding: override.padding ?? padding,
      margin: override.margin ?? margin,
      width: override.width ?? width,
      height: override.height ?? height,
      minWidth: override.minWidth ?? minWidth,
      maxWidth: override.maxWidth ?? maxWidth,
      minHeight: override.minHeight ?? minHeight,
      maxHeight: override.maxHeight ?? maxHeight,
      display: override.display ?? display,
      gap: override.gap ?? gap,
      alignItems: override.alignItems ?? alignItems,
      justifyItems: override.justifyItems ?? justifyItems,
      justifyContent: override.justifyContent ?? justifyContent,
      flex: override.flex ?? flex,
      flexDirection: override.flexDirection ?? flexDirection,
      flexWrap: override.flexWrap ?? flexWrap,
      flexGrow: override.flexGrow ?? flexGrow,
      flexShrink: override.flexShrink ?? flexShrink,
      flexBasis: override.flexBasis ?? flexBasis,
      gridTemplateColumns: override.gridTemplateColumns ?? gridTemplateColumns,
      position: override.position ?? position,
      top: override.top ?? top,
      right: override.right ?? right,
      bottom: override.bottom ?? bottom,
      left: override.left ?? left,
      zIndex: override.zIndex ?? zIndex,
      overflow: override.overflow ?? overflow,
      boxSizing: override.boxSizing ?? boxSizing,
      scrollBehavior: override.scrollBehavior ?? scrollBehavior,
      aspectRatio: override.aspectRatio ?? aspectRatio,
      objectFit: override.objectFit ?? objectFit,
      transform: override.transform ?? transform,
      backdropFilter: override.backdropFilter ?? backdropFilter,
      fontFamily: override.fontFamily ?? fontFamily,
      fontSize: override.fontSize ?? fontSize,
      fontWeight: override.fontWeight ?? fontWeight,
      lineHeight: override.lineHeight ?? lineHeight,
      color: override.color ?? color,
      textAlign: override.textAlign ?? textAlign,
      textTransform: override.textTransform ?? textTransform,
      textDecoration: override.textDecoration ?? textDecoration,
      cursor: override.cursor ?? cursor,
      resize: override.resize ?? resize,
      background: override.background ?? background,
      radius: override.radius ?? radius,
      border: override.border ?? border,
      borderTop: override.borderTop ?? borderTop,
      borderRight: override.borderRight ?? borderRight,
      borderBottom: override.borderBottom ?? borderBottom,
      borderLeft: override.borderLeft ?? borderLeft,
      shadow: override.shadow ?? shadow,
      opacity: override.opacity ?? opacity,
      gradient: override.gradient ?? gradient,
      transition: override.transition ?? transition,
      animation: override.animation ?? animation,
      willChange: override.willChange ?? willChange,
      hover: override.hover ?? hover,
      focus: override.focus ?? focus,
      focusVisible: override.focusVisible ?? focusVisible,
      active: override.active ?? active,
      disabled: override.disabled ?? disabled,
      checked: override.checked ?? checked,
      selected: override.selected ?? selected,
      expanded: override.expanded ?? expanded,
      invalid: override.invalid ?? invalid,
      sm: override.sm ?? sm,
      md: override.md ?? md,
      lg: override.lg ?? lg,
      xl: override.xl ?? xl,
    );
  }
}
