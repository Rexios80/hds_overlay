import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

import '../models.dart';
import '../store.dart';
import 'common.dart';
import 'data_view.dart';
import 'files.dart';

class EndPanelView extends StatelessComponent {
  const EndPanelView({required this.store, super.key});

  final AppStore store;

  @override
  Component build(BuildContext context) {
    final editing = store.editing;
    return switch (store.endPanel) {
      EndPanel.pickData => WidgetPicker(store: store),
      EndPanel.pickChart => ChartPicker(store: store),
      EndPanel.editData
          when editing != null && store.dataByKey(editing) != null =>
        WidgetEditor(store: store, properties: store.dataByKey(editing)!),
      EndPanel.editChart
          when editing != null && store.chartByKey(editing) != null =>
        ChartEditor(store: store, properties: store.chartByKey(editing)!),
      _ => div(classes: 'picker center', [
        img(src: 'images/icon.png', alt: ''),
      ]),
    };
  }
}

class WidgetPicker extends StatelessComponent {
  const WidgetPicker({required this.store, super.key});

  final AppStore store;

  @override
  Component build(BuildContext context) {
    final source = store.selectorSource;
    final used = {for (final widget in store.dataWidgets) widget.slot};
    final types = source.trim().isEmpty
        ? <DataType>[]
        : [
            for (final type in DataType.values)
              if (type != DataType.unknown && !used.contains((type, source)))
                type,
          ];
    return div(classes: 'picker', [
      div(classes: 'editor-row', [
        span([.text('Data source')]),
        BoundField(value: source, onChanged: store.setSelectorSource),
      ]),
      div(styles: Styles(height: 20.px), []),
      for (final type in types)
        div(classes: 'choice', [
          h3([.text(type.label)]),
          button(
            classes: 'preview',
            type: ButtonType.button,
            onClick: () =>
                store.addWidget(type, type == DataType.text ? newId() : source),
            [
              DataWidgetView(
                store: store,
                preview: true,
                properties: DataWidgetProperties()
                  ..dataType = type
                  ..dataSource = source,
              ),
            ],
          ),
        ]),
    ]);
  }
}

class ChartPicker extends StatelessComponent {
  const ChartPicker({required this.store, super.key});

  final AppStore store;

  @override
  Component build(BuildContext context) {
    final source = store.selectorSource;
    final used = {for (final chart in store.charts) chart.slot};
    final types = source.trim().isEmpty
        ? <DataType>[]
        : [
            for (final type in DataType.values)
              if (type != DataType.unknown &&
                  type != DataType.text &&
                  type != DataType.bodyMass &&
                  type != DataType.bmi &&
                  !used.contains((type, source)))
                type,
          ];
    return div(classes: 'picker', [
      div(classes: 'editor-row', [
        span([.text('Data source')]),
        BoundField(value: source, onChanged: store.setSelectorSource),
      ]),
      div(styles: Styles(height: 20.px), []),
      for (final type in types)
        div(classes: 'choice', [
          h3([.text(titleCase(type.name))]),
          button(
            classes: 'preview',
            type: ButtonType.button,
            onClick: () => store.addChart(type, source),
            [
              ChartView(
                store: store,
                properties: ChartWidgetProperties()
                  ..dataType = type
                  ..dataSource = source,
              ),
            ],
          ),
        ]),
    ]);
  }
}

class WidgetEditor extends StatelessComponent {
  const WidgetEditor({
    required this.store,
    required this.properties,
    super.key,
  });

  final AppStore store;
  final DataWidgetProperties properties;

  @override
  Component build(BuildContext context) {
    final type = properties.dataType;
    return div(classes: 'editor', [
      h3([.text(titleCase(type.name))]),
      if (type != DataType.text)
        p(classes: 'caption center', [
          .text('Data source: ${properties.dataSource}'),
        ]),
      h2([.text('Position')]),
      div(classes: 'pair', [
        _number('X', properties.position.item1, (value) {
          properties.position = Tuple2Double(value, properties.position.item2);
        }),
        _number('Y', properties.position.item2, (value) {
          properties.position = Tuple2Double(properties.position.item1, value);
        }),
      ]),
      p(classes: 'caption center', [.text('Drag and drop also works')]),
      div(classes: 'divider', []),
      if (type != DataType.text) ...[
        h2([.text('Image')]),
        _imageRow(),
        if (properties.showImage) ...[
          _number(
            'Image size',
            properties.imageSize,
            (value) => properties.imageSize = value,
          ),
          if (type.isAnimated)
            switchRow(
              'Animate',
              properties.animated,
              (value) => _save(() => properties.animated = value),
            ),
          switchRow(
            'Vertical',
            properties.vertical,
            (value) => _save(() => properties.vertical = value),
          ),
          switchRow(
            'Color',
            properties.colorImage,
            (value) => _save(() => properties.colorImage = value),
          ),
          if (properties.colorImage)
            ColorField(
              label: 'Image color',
              color: properties.imageColor,
              onChanged: (color) => _save(() => properties.imageColor = color),
            ),
        ],
        div(classes: 'divider', []),
      ],
      h2([.text('Text')]),
      if (type == DataType.text)
        _text(
          'Text',
          properties.text,
          (value) => properties.text = value.isEmpty ? 'Text' : value,
        ),
      ColorField(
        label: 'Text color',
        color: properties.textColor,
        onChanged: (color) => _save(() => properties.textColor = color),
      ),
      if (type.isRounded)
        _number(
          'Decimals',
          properties.decimals.toDouble(),
          (value) => properties.decimals = value.round(),
          digits: 0,
        ),
      _text('Font', properties.font, (value) => properties.font = value),
      p(classes: 'caption center', [
        .text('Paste a font name from fonts.google.com'),
      ]),
      div(classes: 'editor-row', [
        span([.text('Font weight')]),
        select(
          [
            for (final weight in fontWeights)
              option(value: weight, selected: weight == properties.fontWeight, [
                .text(weight.substring(12)),
              ]),
          ],
          classes: 'text-input',
          onChange: (values) {
            if (values.isEmpty) return;
            _save(() => properties.fontWeight = values.first);
          },
        ),
      ]),
      _number(
        'Font size',
        properties.fontSize,
        (value) => properties.fontSize = value,
      ),
      if (type != DataType.text) ...[
        _number(
          'Scale factor',
          properties.scaleFactor,
          (value) => properties.scaleFactor = value,
          digits: 3,
        ),
        _text('Unit', properties.unit, (value) => properties.unit = value),
        if (properties.unit.isNotEmpty)
          _number(
            'Unit text size',
            properties.unitFontSize,
            (value) => properties.unitFontSize = value,
          ),
        switchRow(
          'Text inside image',
          properties.textInsideImage,
          (value) => _save(() => properties.textInsideImage = value),
        ),
        _number(
          'Left padding',
          properties.textPaddingLeft,
          (value) => properties.textPaddingLeft = value,
        ),
        _number(
          'Top padding',
          properties.textPaddingTop,
          (value) => properties.textPaddingTop = value,
        ),
      ],
      switchRow(
        'Shadow',
        properties.textShadow,
        (value) => _save(() => properties.textShadow = value),
      ),
      if (properties.textShadow)
        _number(
          'Shadow radius',
          properties.textShadowRadius,
          (value) => properties.textShadowRadius = value,
        ),
      switchRow(
        'Outline',
        properties.textStroke,
        (value) => _save(() => properties.textStroke = value),
      ),
      if (properties.textStroke)
        _number(
          'Stroke width',
          properties.textStrokeWidth,
          (value) => properties.textStrokeWidth = value,
        ),
      if (type == DataType.heartRate) ...[
        div(classes: 'divider', []),
        switchRow(
          'Gradient',
          properties.useGradient,
          (value) => _save(() => properties.useGradient = value),
        ),
        if (properties.useGradient)
          _gradient()
        else
          HeartRateRanges(store: store, properties: properties),
        p(classes: 'caption center', [
          .text('These options override text and image colors'),
        ]),
        div(classes: 'divider', []),
        h2([.text('Heart beat sound')]),
        _soundButton(),
        _number(
          'BPM Threshold',
          properties.heartBeatSoundThreshold.toDouble(),
          (value) => properties.heartBeatSoundThreshold = value.round(),
          digits: 0,
        ),
        div(classes: 'divider', []),
      ],
      _confirm(
        'delete-data-${type.name}-${properties.dataSource}',
        'DELETE WIDGET',
        () => store.deleteData(properties),
      ),
    ]);
  }

  Component _imageRow() {
    final key = 'image-${properties.dataType.name}-${properties.dataSource}';
    return div(classes: 'editor-row', [
      span([.text('Show image')]),
      switchRow(
        '',
        properties.showImage,
        (value) => _save(() => properties.showImage = value),
      ),
      if (properties.showImage && properties.image != null)
        textButton(store.armed(key) ? 'Really?' : 'Remove', () {
          if (store.confirm(key)) _save(() => properties.image = null);
        }, danger: true),
      if (properties.showImage)
        label(classes: 'image-button', [
          input<List<web.File>>(
            classes: 'file-input',
            type: InputType.file,
            attributes: {
              'accept': 'image/png,image/jpeg,image/gif,.png,.jpg,.jpeg,.gif',
            },
            onChange: (files) => unawaited(_loadImage(files)),
          ),
          img(src: imageSource(properties), alt: 'Widget image'),
        ]),
    ]);
  }

  Future<void> _loadImage(List<web.File> files) async {
    if (files.isEmpty) return;
    final bytes = await readFile(files.first);
    await _save(() => properties.image = bytes);
  }

  Component _soundButton() {
    final key = 'sound-${properties.dataSource}';
    final hasSound = properties.heartBeatSound != null;
    if (!hasSound) {
      return label([
        input<List<web.File>>(
          classes: 'file-input',
          type: InputType.file,
          attributes: {'accept': 'audio/mpeg,.mp3'},
          onChange: (files) => unawaited(_loadSound(files)),
        ),
        span(classes: 'text-button', [.text('Select audio file')]),
      ]);
    }
    return textButton(store.armed(key) ? 'Really?' : 'Remove audio file', () {
      if (store.confirm(key)) _save(() => properties.heartBeatSound = null);
    });
  }

  Future<void> _loadSound(List<web.File> files) async {
    if (files.isEmpty) return;
    final bytes = await readFile(files.first);
    await _save(() => properties.heartBeatSound = bytes);
  }

  Component _gradient() {
    return div([
      _number('Low value', properties.gradientLowValue.toDouble(), (value) {
        final next = value.round();
        if (next == properties.gradientHighValue) return;
        properties.gradientLowValue = next;
      }, digits: 0),
      ColorField(
        label: 'Low color',
        color: properties.gradientLowColor,
        onChanged: (color) => _save(() => properties.gradientLowColor = color),
      ),
      _number('High value', properties.gradientHighValue.toDouble(), (value) {
        final next = value.round();
        if (next == properties.gradientLowValue) return;
        properties.gradientHighValue = next;
      }, digits: 0),
      ColorField(
        label: 'High color',
        color: properties.gradientHighColor,
        onChanged: (color) => _save(() => properties.gradientHighColor = color),
      ),
    ]);
  }

  Component _number(
    String label,
    double value,
    void Function(double value) apply, {
    int digits = 0,
  }) {
    final text = digits == 0 ? value.toStringAsFixed(0) : value.toString();
    return div(classes: 'editor-row', [
      span([.text(label)]),
      BoundField(
        value: text,
        onChanged: (raw) => _save(() => apply(double.tryParse(raw) ?? 0)),
      ),
    ]);
  }

  Component _text(
    String label,
    String value,
    void Function(String value) apply,
  ) {
    return div(classes: 'editor-row', [
      span([.text(label)]),
      BoundField(value: value, onChanged: (raw) => _save(() => apply(raw))),
    ]);
  }

  Component _confirm(String key, String label, void Function() onConfirm) {
    return textButton(store.armed(key) ? 'ARE YOU SURE?' : label, () {
      if (store.confirm(key)) onConfirm();
    }, danger: true);
  }

  Future<void> _save(void Function() change) =>
      store.saveData(properties, change);
}

class ChartEditor extends StatelessComponent {
  const ChartEditor({required this.store, required this.properties, super.key});

  final AppStore store;
  final ChartWidgetProperties properties;

  @override
  Component build(BuildContext context) {
    final key =
        'delete-chart-${properties.dataType.name}-${properties.dataSource}';
    return div(classes: 'editor', [
      h3([.text(titleCase(properties.dataType.name))]),
      p(classes: 'caption center', [
        .text('Data source: ${properties.dataSource}'),
      ]),
      h2([.text('Position')]),
      div(classes: 'pair', [
        _number('X', properties.position.item1, (value) {
          properties.position = Tuple2Double(value, properties.position.item2);
        }),
        _number('Y', properties.position.item2, (value) {
          properties.position = Tuple2Double(properties.position.item1, value);
        }),
      ]),
      p(classes: 'caption center', [.text('Drag and drop also works')]),
      div(classes: 'divider', []),
      h2([.text('Size')]),
      _number('Width', properties.width, (value) => properties.width = value),
      _number(
        'Height',
        properties.height,
        (value) => properties.height = value,
      ),
      div(classes: 'divider', []),
      _number('Time range (seconds)', properties.rangeSeconds.toDouble(), (
        value,
      ) {
        final next = value.round();
        properties.rangeSeconds = next == 0 ? 300 : next;
      }, digits: 0),
      ColorField(
        label: 'Low color',
        color: properties.lowColor,
        onChanged: (color) => _save(() => properties.lowColor = color),
      ),
      ColorField(
        label: 'High color',
        color: properties.highColor,
        onChanged: (color) => _save(() => properties.highColor = color),
      ),
      div(classes: 'divider', []),
      textButton(store.armed(key) ? 'ARE YOU SURE?' : 'DELETE WIDGET', () {
        if (store.confirm(key)) store.deleteChart(properties);
      }, danger: true),
    ]);
  }

  Component _number(
    String label,
    double value,
    void Function(double value) apply, {
    int digits = 0,
  }) {
    final text = digits == 0 ? value.toStringAsFixed(0) : value.toString();
    return div(classes: 'editor-row', [
      span([.text(label)]),
      BoundField(
        value: text,
        onChanged: (raw) => _save(() => apply(double.tryParse(raw) ?? 0)),
      ),
    ]);
  }

  Future<void> _save(void Function() change) =>
      store.saveChart(properties, change);
}

class HeartRateRanges extends StatefulComponent {
  const HeartRateRanges({
    required this.store,
    required this.properties,
    super.key,
  });

  final AppStore store;
  final DataWidgetProperties properties;

  @override
  State<HeartRateRanges> createState() => _HeartRateRangesState();
}

class _HeartRateRangesState extends State<HeartRateRanges> {
  final _open = <int>{};
  var _draftKey = -1;
  var _draft = '';

  @override
  Component build(BuildContext context) {
    final ranges = component.properties.heartRateRanges.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key));
    return div([
      div(classes: 'editor-row', [
        span([.text('Heart rate ranges')]),
        iconButton('add', 'Add range', () {
          component.properties.heartRateRanges[0] = colorRed;
          unawaited(component.store.saveData(component.properties, () {}));
        }),
      ]),
      for (final range in ranges)
        div([
          if (_open.contains(range.key))
            div(classes: 'editor-row', [
              BoundField(
                value: _draftKey == range.key ? _draft : '${range.key}',
                onChanged: (value) => setState(() {
                  _draftKey = range.key;
                  _draft = value;
                }),
              ),
              textButton(
                _canSave(range.key) ? 'Save' : 'Delete',
                () => _commit(range),
              ),
            ])
          else
            button(
              classes: 'expand',
              type: ButtonType.button,
              onClick: () => setState(() => _open.add(range.key)),
              [
                span([.text('${range.key}')]),
                span(styles: Styles(raw: {'flex': '1'}), []),
                span(
                  classes: 'color-dot',
                  styles: Styles(backgroundColor: Color(cssArgb(range.value))),
                  [],
                ),
              ],
            ),
          if (_open.contains(range.key))
            ColorField(
              label: 'Color shade',
              color: range.value,
              expanded: true,
              onChanged: (color) {
                component.properties.heartRateRanges[range.key] = color;
                unawaited(
                  component.store.saveData(component.properties, () {}),
                );
              },
            ),
        ]),
    ]);
  }

  bool _canSave(int key) {
    final text = _draftKey == key ? _draft : '$key';
    final next = int.tryParse(text);
    if (next == null) return false;
    return !component.properties.heartRateRanges.containsKey(next);
  }

  void _commit(MapEntry<int, int> range) {
    final draft = _draftKey == range.key ? _draft : '${range.key}';
    final next = int.tryParse(draft);
    final canSave =
        next != null && !component.properties.heartRateRanges.containsKey(next);
    component.properties.heartRateRanges.remove(range.key);
    if (canSave) {
      component.properties.heartRateRanges[next] = range.value;
    } else {
      _open.remove(range.key);
    }
    _draftKey = -1;
    _draft = '';
    unawaited(component.store.saveData(component.properties, () {}));
  }
}

class ColorField extends StatefulComponent {
  const ColorField({
    required this.label,
    required this.color,
    required this.onChanged,
    this.expanded = false,
    super.key,
  });

  final String label;
  final int color;
  final ValueChanged<int> onChanged;
  final bool expanded;

  @override
  State<ColorField> createState() => _ColorFieldState();
}

class _ColorFieldState extends State<ColorField> {
  var _open = false;

  static const _swatches = [
    colorWhite,
    colorBlack,
    colorTransparent,
    colorRed,
    colorAccent,
    colorGreen,
    0xFF2196F3,
    0xFFFFEB3B,
    0xFFFF9800,
    0xFF9C27B0,
    0xFF00B140,
    0xFF0047BB,
    0xFFFF00FF,
  ];

  @override
  void initState() {
    super.initState();
    _open = component.expanded;
  }

  @override
  Component build(BuildContext context) {
    final hex =
        '#${(component.color & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    return div([
      if (!component.expanded)
        button(
          classes: 'expand',
          type: ButtonType.button,
          onClick: () => setState(() => _open = !_open),
          [
            span([.text(component.label)]),
            span(styles: Styles(raw: {'flex': '1'}), []),
            span(
              classes: 'color-dot',
              styles: Styles(backgroundColor: Color(cssArgb(component.color))),
              [],
            ),
          ],
        ),
      if (_open || component.expanded)
        div(classes: 'color-panel', [
          if (component.expanded) span([.text(component.label)]),
          div(classes: 'swatches', [
            for (final swatch in _swatches)
              button(
                classes: 'swatch',
                type: ButtonType.button,
                attributes: {'aria-label': cssArgb(swatch)},
                styles: Styles(backgroundColor: Color(cssArgb(swatch))),
                onClick: () => component.onChanged(swatch),
                [],
              ),
          ]),
          div(classes: 'color-row', [
            input<Color>(
              type: InputType.color,
              value: hex,
              onInput: (color) =>
                  component.onChanged(_withRgb(component.color, color.value)),
            ),
            BoundField(
              value: hex,
              onChanged: (value) =>
                  component.onChanged(_withRgb(component.color, value)),
            ),
          ]),
          div(classes: 'editor-row', [
            span([.text('Opacity')]),
            input<num>(
              type: InputType.range,
              value: '${(component.color >> 24) & 0xFF}',
              attributes: {'min': '0', 'max': '255'},
              onInput: (value) {
                final alpha = value.round().clamp(0, 255);
                component.onChanged(
                  (alpha << 24) | (component.color & 0xFFFFFF),
                );
              },
            ),
          ]),
        ]),
    ]);
  }
}

int _withRgb(int original, String hex) {
  final rgb = argbFromCssHex(hex) & 0xFFFFFF;
  return ((original >> 24) & 0xFF) << 24 | rgb;
}
