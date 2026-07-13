import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// A customizable SVG-based Line Chart widget for displaying trends.
class LineChart extends FlintElement {
  LineChart({
    required List<double> data,
    required List<String> labels,
    double height = 200.0,
    String strokeColor = '#6366f1',
    String fillColor = 'rgba(99, 102, 241, 0.08)',
    double strokeWidth = 2.5,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: const {'width': '100%'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: [
           _buildSvg(data, labels, height, strokeColor, fillColor, strokeWidth),
         ],
       );

  static FlintNode _buildSvg(
    List<double> data,
    List<String> labels,
    double height,
    String strokeColor,
    String fillColor,
    double strokeWidth,
  ) {
    if (data.isEmpty) {
      return FlintElement(
        'div',
        props: const {
          'style': {
            'padding': '20px',
            'text-align': 'center',
            'color': '#94a3b8',
          },
        },
        children: [FlintText('No data available')],
      );
    }

    final double width = 600.0;
    final double padLeft = 50.0;
    final double padRight = 20.0;
    final double padTop = 20.0;
    final double padBottom = 30.0;

    final double graphWidth = width - padLeft - padRight;
    final double graphHeight = height - padTop - padBottom;

    // Find min and max values to scale
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    double minVal = data.reduce((a, b) => a < b ? a : b);
    if (maxVal == minVal) maxVal = minVal + 10.0;

    // Round max value up slightly for clean axis lines
    final double yMax = maxVal * 1.05;
    final double yMin = minVal * 0.95 > 0 ? minVal * 0.95 : 0.0;

    // Y grid values
    final yGridLines = <double>[];
    for (int i = 0; i <= 3; i++) {
      yGridLines.add(yMin + (yMax - yMin) * (i / 3));
    }

    // Points calculation
    final points = <String>[];
    final fillPoints = <String>[];

    // Add start fill point
    fillPoints.add('$padLeft,${height - padBottom}');

    for (int i = 0; i < data.length; i++) {
      final double pctX = data.length > 1 ? (i / (data.length - 1)) : 0.0;
      final double x = padLeft + (pctX * graphWidth);

      final double pctY = (data[i] - yMin) / (yMax - yMin);
      final double y = padTop + ((1.0 - pctY) * graphHeight);

      points.add('$x,$y');
      fillPoints.add('$x,$y');
    }

    // Add end fill point
    fillPoints.add('${padLeft + graphWidth},${height - padBottom}');

    return FlintElement(
      'svg',
      props: {
        'viewBox': '0 0 $width $height',
        'width': '100%',
        'height': '${height}px',
        'style': {'display': 'block', 'overflow': 'visible'},
      },
      children: [
        // Grid Lines & Y labels
        for (final gridVal in yGridLines) ...[
          FlintElement(
            'line',
            props: {
              'x1': padLeft.toString(),
              'y1':
                  (padTop +
                          (1.0 - (gridVal - yMin) / (yMax - yMin)) *
                              graphHeight)
                      .toString(),
              'x2': (width - padRight).toString(),
              'y2':
                  (padTop +
                          (1.0 - (gridVal - yMin) / (yMax - yMin)) *
                              graphHeight)
                      .toString(),
              'stroke': 'rgba(255, 255, 255, 0.05)',
              'stroke-width': '1',
              'stroke-dasharray': '4 4',
            },
          ),
          FlintElement(
            'text',
            props: {
              'x': (padLeft - 8).toString(),
              'y':
                  (padTop +
                          (1.0 - (gridVal - yMin) / (yMax - yMin)) *
                              graphHeight +
                          4)
                      .toString(),
              'fill': '#94a3b8',
              'font-size': '10px',
              'font-family': 'sans-serif',
              'text-anchor': 'end',
            },
            children: [
              FlintText(
                gridVal >= 1000
                    ? '\$${(gridVal / 1000).toStringAsFixed(1)}k'
                    : '\$${gridVal.toStringAsFixed(0)}',
              ),
            ],
          ),
        ],

        // Filled path under the line
        FlintElement(
          'polygon',
          props: {'points': fillPoints.join(' '), 'fill': fillColor},
        ),

        // Smooth polyline path
        FlintElement(
          'polyline',
          props: {
            'points': points.join(' '),
            'fill': 'none',
            'stroke': strokeColor,
            'stroke-width': strokeWidth.toString(),
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
          },
        ),

        // Interactive/Highlighted data point circles
        for (int i = 0; i < data.length; i++) ...[
          FlintElement(
            'circle',
            props: {
              'cx':
                  (padLeft +
                          (data.length > 1
                              ? (i / (data.length - 1)) * graphWidth
                              : 0.0))
                      .toString(),
              'cy':
                  (padTop +
                          (1.0 - (data[i] - yMin) / (yMax - yMin)) *
                              graphHeight)
                      .toString(),
              'r': '4',
              'fill': strokeColor,
              'stroke': '#1e1b4b',
              'stroke-width': '2',
              'style': {'transition': 'all 0.15s ease', 'cursor': 'pointer'},
            },
          ),
        ],

        // X labels
        for (int i = 0; i < labels.length; i++) ...[
          FlintElement(
            'text',
            props: {
              'x':
                  (padLeft +
                          (labels.length > 1
                              ? (i / (labels.length - 1)) * graphWidth
                              : 0.0))
                      .toString(),
              'y': (height - 8).toString(),
              'fill': '#94a3b8',
              'font-size': '10px',
              'font-family': 'sans-serif',
              'text-anchor': 'middle',
            },
            children: [FlintText(labels[i])],
          ),
        ],
      ],
    );
  }
}

/// A customizable SVG-based Bar Chart widget for representing categories/metrics.
class BarChart extends FlintElement {
  BarChart({
    required List<double> data,
    required List<String> labels,
    double height = 200.0,
    String barColor = '#6366f1',
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: const {'width': '100%'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: [_buildSvg(data, labels, height, barColor)],
       );

  static FlintNode _buildSvg(
    List<double> data,
    List<String> labels,
    double height,
    String barColor,
  ) {
    if (data.isEmpty) {
      return FlintElement(
        'div',
        props: const {
          'style': {
            'padding': '20px',
            'text-align': 'center',
            'color': '#94a3b8',
          },
        },
        children: [FlintText('No data available')],
      );
    }

    final double width = 600.0;
    final double padLeft = 40.0;
    final double padRight = 20.0;
    final double padTop = 20.0;
    final double padBottom = 30.0;

    final double graphWidth = width - padLeft - padRight;
    final double graphHeight = height - padTop - padBottom;

    // Find min and max values to scale
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    if (maxVal <= 0) maxVal = 10.0;

    final double yMax = maxVal * 1.05;

    // Draw bars
    final double totalBars = data.length.toDouble();
    final double barGapRatio = 0.35; // gap width as fraction of bar space
    final double barSpaceWidth = graphWidth / totalBars;
    final double barWidth = barSpaceWidth * (1.0 - barGapRatio);

    return FlintElement(
      'svg',
      props: {
        'viewBox': '0 0 $width $height',
        'width': '100%',
        'height': '${height}px',
        'style': {'display': 'block', 'overflow': 'visible'},
      },
      children: [
        // Horizontal Grid Lines
        for (int i = 0; i <= 3; i++) ...[
          FlintElement(
            'line',
            props: {
              'x1': padLeft.toString(),
              'y1': (padTop + (i / 3) * graphHeight).toString(),
              'x2': (width - padRight).toString(),
              'y2': (padTop + (i / 3) * graphHeight).toString(),
              'stroke': 'rgba(255, 255, 255, 0.05)',
              'stroke-width': '1',
            },
          ),
        ],

        // Bars
        for (int i = 0; i < data.length; i++) ...[
          FlintElement(
            'rect',
            props: {
              'x':
                  (padLeft +
                          (i * barSpaceWidth) +
                          (barSpaceWidth * barGapRatio / 2))
                      .toString(),
              'y': (padTop + (1.0 - (data[i] / yMax)) * graphHeight).toString(),
              'width': barWidth.toString(),
              'height': ((data[i] / yMax) * graphHeight).toString(),
              'rx': '4',
              'fill': barColor,
              'style': {'transition': 'all 0.2s ease', 'cursor': 'pointer'},
            },
          ),
          // Bar value labels on top of bars
          FlintElement(
            'text',
            props: {
              'x': (padLeft + (i * barSpaceWidth) + (barSpaceWidth / 2))
                  .toString(),
              'y': (padTop + (1.0 - (data[i] / yMax)) * graphHeight - 6)
                  .toString(),
              'fill': '#e2e8f0',
              'font-size': '9px',
              'font-family': 'sans-serif',
              'font-weight': 'bold',
              'text-anchor': 'middle',
            },
            children: [FlintText(data[i].toStringAsFixed(0))],
          ),
        ],

        // X labels
        for (int i = 0; i < labels.length; i++) ...[
          FlintElement(
            'text',
            props: {
              'x': (padLeft + (i * barSpaceWidth) + (barSpaceWidth / 2))
                  .toString(),
              'y': (height - 8).toString(),
              'fill': '#94a3b8',
              'font-size': '10px',
              'font-family': 'sans-serif',
              'text-anchor': 'middle',
            },
            children: [FlintText(labels[i])],
          ),
        ],
      ],
    );
  }
}
