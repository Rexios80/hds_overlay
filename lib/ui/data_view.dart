import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:math';
import 'dart:typed_data';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

import '../models.dart';
import '../store.dart';

Component dataCanvas(AppStore store) {
  return div(classes: 'canvas', [
    for (final properties in store.dataWidgets)
      DragItem(
        key: ValueKey(
          'data-${properties.dataType.name}-${properties.dataSource}',
        ),
        x: properties.position.item1,
        y: properties.position.item2,
        onDrop: (x, y) => store.saveData(
          properties,
          () => properties.position = Tuple2Double(x, y),
        ),
        onTap: () => store.editData(properties.dataType, properties.dataSource),
        child: DataWidgetView(store: store, properties: properties),
      ),
    for (final properties in store.charts)
      DragItem(
        key: ValueKey(
          'chart-${properties.dataType.name}-${properties.dataSource}',
        ),
        x: properties.position.item1,
        y: properties.position.item2,
        onDrop: (x, y) => store.saveChart(
          properties,
          () => properties.position = Tuple2Double(x, y),
        ),
        onTap: () =>
            store.editChart(properties.dataType, properties.dataSource),
        child: ChartView(store: store, properties: properties),
      ),
  ]);
}

extension type _Point(web.Event _) implements web.Event {
  external double get clientX;
  external double get clientY;
}

class DragItem extends StatefulComponent {
  const DragItem({
    required this.x,
    required this.y,
    required this.onDrop,
    required this.onTap,
    required this.child,
    super.key,
  });

  final double x;
  final double y;
  final void Function(double x, double y) onDrop;
  final void Function() onTap;
  final Component child;

  @override
  State<DragItem> createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  Timer? _hold;
  var _dragging = false;
  double _startX = 0;
  double _startY = 0;
  double _grabX = 0;
  double _grabY = 0;
  double? _x;
  double? _y;

  @override
  void dispose() {
    _hold?.cancel();
    super.dispose();
  }

  web.DOMRect? get _rect {
    final node = web.document.querySelector('.canvas');
    return node is web.Element ? node.getBoundingClientRect() : null;
  }

  void _down(web.Event event) {
    final pointer = event as web.PointerEvent;
    final point = _Point(event);
    if (pointer.button != 0) return;
    (pointer.currentTarget as web.Element).setPointerCapture(pointer.pointerId);
    _startX = point.clientX;
    _startY = point.clientY;
    final rect = _rect;
    _grabX = rect == null ? 0.0 : point.clientX - rect.left - component.x;
    _grabY = rect == null ? 0.0 : point.clientY - rect.top - component.y;
    _hold?.cancel();
    _hold = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _dragging = true);
    });
  }

  void _move(web.Event event) {
    final point = _Point(event);
    if (_hold != null && !_dragging) {
      final dx = point.clientX - _startX;
      final dy = point.clientY - _startY;
      if (dx * dx + dy * dy > 36) {
        _hold?.cancel();
        _hold = null;
      }
      return;
    }
    if (!_dragging) return;
    final rect = _rect;
    if (rect == null) return;
    setState(() {
      _x = point.clientX - rect.left - _grabX;
      _y = point.clientY - rect.top - _grabY;
    });
  }

  void _up(web.Event event) {
    final point = _Point(event);
    final wasDragging = _dragging;
    final dx = point.clientX - _startX;
    final dy = point.clientY - _startY;
    _hold?.cancel();
    _hold = null;
    _dragging = false;
    final x = _x;
    final y = _y;
    _x = null;
    _y = null;
    if (wasDragging && x != null && y != null) {
      final rect = _rect;
      final maxX = max(0, (rect?.width ?? 0) - 50).toDouble();
      final maxY = max(0, (rect?.height ?? 0) - 50).toDouble();
      if (x < 0 || y < 0 || x > maxX || y > maxY) {
        if (mounted) setState(() {});
      } else {
        component.onDrop(x, y);
      }
    } else if (dx * dx + dy * dy <= 144) {
      component.onTap();
    } else if (mounted) {
      setState(() {});
    }
  }

  @override
  Component build(BuildContext context) {
    final x = _x ?? component.x;
    final y = _y ?? component.y;
    return div(
      classes: _dragging ? 'placed dragging' : 'placed',
      styles: Styles(
        position: Position.absolute(left: x.px, top: y.px),
      ),
      events: {
        'pointerdown': _down,
        'pointermove': _move,
        'pointerup': _up,
        'pointercancel': _up,
      },
      [component.child],
    );
  }
}

class DataWidgetView extends StatelessComponent {
  const DataWidgetView({
    required this.store,
    required this.properties,
    this.preview = false,
    super.key,
  });

  final AppStore store;
  final DataWidgetProperties properties;
  final bool preview;

  @override
  Component build(BuildContext context) {
    final reading = properties.dataType == DataType.text
        ? properties.text
        : _format(
            properties,
            preview ? null : store.messages[properties.slot]?.value,
          );
    final showUnit =
        reading != '-' &&
        properties.unit.isNotEmpty &&
        properties.dataType != DataType.text;
    final color = properties.dataType == DataType.heartRate
        ? rangeColor(
            properties,
            preview ? 0 : store.heartRateFor(properties.dataSource),
            fallback: properties.textColor,
          )
        : properties.textColor;
    final text = _reading(properties, reading, showUnit, color);
    final image = properties.showImage && properties.dataType != DataType.text
        ? _image(store, properties, preview: preview)
        : null;
    if (image == null) return text;
    if (properties.textInsideImage) {
      return div(classes: 'stack', [
        image,
        div(classes: 'overlay-text', [text]),
      ]);
    }
    if (properties.vertical) return div(classes: 'v-widget', [image, text]);
    return div(classes: 'h-widget', [image, text]);
  }
}

Component _image(
  AppStore store,
  DataWidgetProperties properties, {
  required bool preview,
}) {
  final heartRate = properties.dataType == DataType.heartRate;
  final bpm = preview ? 0 : store.heartRateFor(properties.dataSource);
  final tint = properties.colorImage
      ? (heartRate
            ? rangeColor(properties, bpm, fallback: properties.imageColor)
            : properties.imageColor)
      : null;
  final image = _picture(properties, tint: tint, size: properties.imageSize);
  if (!heartRate) return image;
  return HeartBeat(
    bpm: bpm,
    animate: !preview && properties.animated,
    sound: !preview ? properties.heartBeatSound : null,
    threshold: properties.heartBeatSoundThreshold,
    image: div(
      styles: Styles(
        width: properties.imageSize.px,
        height: properties.imageSize.px,
        raw: {
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
        },
      ),
      [image],
    ),
  );
}

Component _picture(
  DataWidgetProperties properties, {
  required int? tint,
  required double size,
}) {
  final source = imageSource(properties);
  if (tint == null) {
    return img(
      src: source,
      alt: '',
      styles: Styles(
        height: size.px,
        raw: {'width': 'auto', 'display': 'block'},
      ),
    );
  }
  return div(
    classes: 'tint',
    styles: Styles(
      width: size.px,
      height: size.px,
      raw: {
        'background-color': cssArgb(tint),
        'mask-image': 'url("$source")',
        '-webkit-mask-image': 'url("$source")',
      },
    ),
    [],
  );
}

Component _reading(
  DataWidgetProperties properties,
  String reading,
  bool showUnit,
  int color,
) {
  ensureGoogleFont(properties.font);
  return div(classes: 'reading', [
    span(styles: _textStyle(properties, color, properties.fontSize), [
      .text(reading),
    ]),
    if (showUnit)
      span(
        classes: 'unit',
        styles: _textStyle(properties, color, properties.unitFontSize),
        [.text(properties.unit)],
      ),
  ]);
}

Styles _textStyle(DataWidgetProperties properties, int color, double size) {
  final padding = properties.dataType.usesPadding
      ? '${properties.textPaddingTop}px ${properties.textPaddingLeft}px 0'
      : '0';
  return Styles(
    color: Color(cssArgb(color)),
    fontSize: size.px,
    raw: {
      'font-family': '"${properties.font}", Monaco, sans-serif',
      'font-weight': '${cssFontWeight(properties.fontWeight)}',
      'padding': padding,
      'line-height': '1',
      'white-space': 'pre',
      if (properties.textShadow)
        'text-shadow': '0 0 ${properties.textShadowRadius}px #000',
      if (properties.textStroke) 'paint-order': 'stroke fill',
      if (properties.textStroke)
        '-webkit-text-stroke': '${properties.textStrokeWidth}px #000',
    },
  );
}

String _format(DataWidgetProperties properties, String? raw) {
  if (raw == null) return '-';
  final parsed = double.tryParse(raw);
  if (parsed == null) return raw;
  final scaled = parsed * properties.scaleFactor;
  if (properties.dataType.isRounded)
    return scaled.toStringAsFixed(properties.decimals.clamp(0, 8));
  return scaled.toStringAsFixed(0);
}

class HeartBeat extends StatefulComponent {
  const HeartBeat({
    required this.bpm,
    required this.animate,
    required this.sound,
    required this.threshold,
    required this.image,
    super.key,
  });

  final int bpm;
  final bool animate;
  final Uint8List? sound;
  final int threshold;
  final Component image;

  @override
  State<HeartBeat> createState() => _HeartBeatState();
}

class _HeartBeatState extends State<HeartBeat> {
  var _scale = 1.0;
  var _alive = true;
  Uint8List? _soundBytes;
  String? _url;
  web.HTMLAudioElement? _audio;

  @override
  void initState() {
    super.initState();
    unawaited(_pulse());
    unawaited(_beat());
  }

  @override
  void dispose() {
    _alive = false;
    _audio?.pause();
    if (_url != null) web.URL.revokeObjectURL(_url!);
    super.dispose();
  }

  Future<void> _pulse() async {
    while (_alive && mounted) {
      final bpm = component.bpm;
      if (!component.animate || bpm <= 0) {
        if (_scale != 1) setState(() => _scale = 1);
        await Future<void>.delayed(const Duration(milliseconds: 200));
        continue;
      }
      final beat = (60000 / bpm).round();
      final shrink = max(1, (beat * 0.75).round());
      setState(() => _scale = 0.85);
      await Future<void>.delayed(Duration(milliseconds: shrink));
      if (!_alive || !mounted) return;
      setState(() => _scale = 1);
      await Future<void>.delayed(Duration(milliseconds: max(1, beat - shrink)));
    }
  }

  Future<void> _beat() async {
    while (_alive && mounted) {
      final bytes = component.sound;
      final bpm = component.bpm;
      if (bytes == null || bpm <= 0 || bpm < component.threshold) {
        _audio?.pause();
        await Future<void>.delayed(const Duration(milliseconds: 100));
        continue;
      }
      _ensureAudio(bytes);
      final started = DateTime.now().millisecondsSinceEpoch;
      _audio!.currentTime = 0;
      unawaited(_audio!.play().toDart.catchError((_) => null));
      final beat = (60000 / bpm).round();
      final spent = DateTime.now().millisecondsSinceEpoch - started;
      await Future<void>.delayed(Duration(milliseconds: max(0, beat - spent)));
    }
  }

  void _ensureAudio(Uint8List bytes) {
    if (identical(bytes, _soundBytes) && _audio != null) return;
    _soundBytes = bytes;
    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'audio/mpeg'),
    );
    final url = web.URL.createObjectURL(blob);
    _audio?.pause();
    if (_url != null) web.URL.revokeObjectURL(_url!);
    _url = url;
    _audio = web.HTMLAudioElement()..src = url;
  }

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        raw: {
          'transform': 'scale($_scale)',
          'transform-origin': 'center center',
        },
      ),
      [component.image],
    );
  }
}

class ChartView extends StatelessComponent {
  const ChartView({required this.store, required this.properties, super.key});

  final AppStore store;
  final ChartWidgetProperties properties;

  @override
  Component build(BuildContext context) {
    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    final start = now - properties.rangeSeconds * 1000;
    final points = [
      for (final message
          in store.history[properties.slot] ?? const <DataMessage>[])
        if (message.timestamp.millisecondsSinceEpoch >= start)
          (
            x: message.timestamp.millisecondsSinceEpoch.toDouble(),
            y: double.tryParse(message.value) ?? 0,
          ),
    ];
    final width = max(properties.width, 1).toDouble();
    final height = max(properties.height, 1).toDouble();
    final maxY = points.isEmpty
        ? 0.0
        : points.map((point) => point.y).reduce(max);
    final id =
        'grad${properties.dataType.index}x${properties.dataSource.hashCode.abs()}';
    final pixels = [
      for (final point in points)
        (x: _sx(point.x, width, start, now), y: _sy(point.y, height, maxY)),
    ];
    final curve = _smooth(pixels);
    return svg(
      [
        Component.element(
          tag: 'defs',
          children: [
            Component.element(
              tag: 'linearGradient',
              id: id,
              attributes: {'x1': '0', 'y1': '1', 'x2': '0', 'y2': '0'},
              children: [
                Component.element(
                  tag: 'stop',
                  attributes: {
                    'offset': '0%',
                    'stop-color': cssArgb(properties.lowColor),
                    'stop-opacity': '0.3',
                  },
                ),
                Component.element(
                  tag: 'stop',
                  attributes: {
                    'offset': '100%',
                    'stop-color': cssArgb(properties.highColor),
                    'stop-opacity': '0.3',
                  },
                ),
              ],
            ),
          ],
        ),
        line(
          [],
          x1: '0',
          y1: '0',
          x2: '0',
          y2: '$height',
          stroke: const Color('#37434d'),
          strokeWidth: '1',
        ),
        line(
          [],
          x1: '0',
          y1: '$height',
          x2: '$width',
          y2: '$height',
          stroke: const Color('#37434d'),
          strokeWidth: '1',
        ),
        if (points.length > 1)
          path(
            [],
            attributes: {
              'd':
                  '$curve L ${pixels.last.x} $height L ${pixels.first.x} $height Z',
              'fill': 'url(#$id)',
              'stroke': 'none',
            },
          ),
        if (points.length > 1)
          path(
            [],
            d: curve,
            fill: const Color('none'),
            stroke: Color(cssArgb(properties.highColor)),
            strokeWidth: '5',
            attributes: {'stroke-linecap': 'round', 'stroke-linejoin': 'round'},
          ),
        if (points.length == 1)
          circle(
            [],
            cx: '${_sx(points.first.x, width, start, now)}',
            cy: '${_sy(points.first.y, height, maxY)}',
            r: '4',
            fill: Color(cssArgb(properties.highColor)),
          ),
      ],
      classes: 'chart',
      viewBox: '0 0 $width $height',
      width: width.px,
      height: height.px,
    );
  }
}

double _sx(double x, double width, double start, double now) {
  if (now <= start) return 0;
  return ((x - start) / (now - start)) * width;
}

double _sy(double y, double height, double maxY) {
  if (maxY <= 0) return height;
  return height - (y / maxY) * height;
}

String _smooth(List<({double x, double y})> points) {
  if (points.isEmpty) return '';
  final buffer = StringBuffer('M ${points.first.x} ${points.first.y}');
  if (points.length == 1) return buffer.toString();
  for (var i = 0; i < points.length - 1; i++) {
    final p0 = points[i == 0 ? 0 : i - 1];
    final p1 = points[i];
    final p2 = points[i + 1];
    final p3 = points[i + 2 < points.length ? i + 2 : i + 1];
    final c1x = p1.x + (p2.x - p0.x) / 6;
    final c1y = p1.y + (p2.y - p0.y) / 6;
    final c2x = p2.x - (p3.x - p1.x) / 6;
    final c2y = p2.y - (p3.y - p1.y) / 6;
    buffer.write(' C $c1x $c1y $c2x $c2y ${p2.x} ${p2.y}');
  }
  return buffer.toString();
}

String imageSource(DataWidgetProperties properties) {
  final bytes = properties.image;
  if (bytes == null) return properties.dataType.defaultImage;
  return 'data:${_mime(bytes)};base64,${base64Encode(bytes)}';
}

String _mime(Uint8List bytes) {
  if (bytes.length >= 4 && bytes[0] == 0x89 && bytes[1] == 0x50)
    return 'image/png';
  if (bytes.length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8)
    return 'image/jpeg';
  if (bytes.length >= 6 &&
      bytes[0] == 0x47 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46)
    return 'image/gif';
  return 'image/png';
}

final _loadedFonts = <String>{};

void ensureGoogleFont(String family) {
  if (family.isEmpty || family == 'Monaco' || !_loadedFonts.add(family)) return;
  final link = web.document.createElement('link') as web.HTMLLinkElement;
  link.rel = 'stylesheet';
  final familyName = family.trim().replaceAll(' ', '+');
  link.href =
      'https://fonts.googleapis.com/css2?family=$familyName:wght@100;200;300;400;500;600;700;800;900&display=swap';
  web.document.head?.append(link);
}
