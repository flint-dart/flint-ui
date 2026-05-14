part of '../style.dart';

class DartStyle {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Object? width;
  final Object? height;
  final Object? minWidth;
  final Object? maxWidth;
  final Object? minHeight;
  final Object? maxHeight;
  final Display? display;
  final Object? gap;
  final AlignItems? alignItems;
  final Object? justifyItems;
  final JustifyContent? justifyContent;
  final Object? flex;
  final FlexDirection? flexDirection;
  final Object? flexWrap;
  final Object? flexGrow;
  final Object? flexShrink;
  final Object? flexBasis;
  final String? gridTemplateColumns;
  final Position? position;
  final Object? top;
  final Object? right;
  final Object? bottom;
  final Object? left;
  final int? zIndex;
  final Object? overflow;
  final Object? boxSizing;
  final Object? scrollBehavior;
  final Object? aspectRatio;
  final Object? objectFit;
  final Object? transform;
  final Object? backdropFilter;
  final Object? fontFamily;
  final Object? fontSize;
  final Object? fontWeight;
  final Object? lineHeight;
  final Object? color;
  final TextAlign? textAlign;
  final Object? textTransform;
  final Object? textDecoration;
  final Object? cursor;
  final Object? resize;
  final Object? background;
  final Object? radius;
  final Border? border;
  final Border? borderTop;
  final Border? borderRight;
  final Border? borderBottom;
  final Border? borderLeft;
  final Object? shadow;
  final double? opacity;
  final Object? gradient;
  final Object? transition;
  final Object? animation;
  final Object? willChange;
  final DartStyle? hover;
  final DartStyle? focus;
  final DartStyle? focusVisible;
  final DartStyle? active;
  final DartStyle? disabled;
  final DartStyle? checked;
  final DartStyle? selected;
  final DartStyle? expanded;
  final DartStyle? invalid;
  final DartStyle? sm;
  final DartStyle? md;
  final DartStyle? lg;
  final DartStyle? xl;

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

  bool get hasBreakpoints =>
      sm != null || md != null || lg != null || xl != null;

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

  bool get hasScopedStyles => hasBreakpoints || hasStateStyles;

  Map<Breakpoint, DartStyle> get breakpointStyles => {
    if (sm != null) Breakpoint.sm: sm!,
    if (md != null) Breakpoint.md: md!,
    if (lg != null) Breakpoint.lg: lg!,
    if (xl != null) Breakpoint.xl: xl!,
  };

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
