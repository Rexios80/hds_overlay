import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

import '../store.dart';

Component svgIcon(String name) {
  final data = switch (name) {
    'menu' => 'M4 7h16M4 12h16M4 17h16',
    'upload' => 'M12 16V5M8 9l4-4 4 4M5 19h14',
    'download' => 'M12 5v11M8 12l4 4 4-4M5 19h14',
    'save' => 'M6 4h10l4 4v12H6zM8 4v5h7M8 20v-5h8v5',
    'add' => 'M12 5v14M5 12h14',
    'chart' => 'M4 19V5M4 19h16M8 16l3.2-4.2L14 14l4.5-6',
    'close' => 'M7 7l10 10M17 7L7 17',
    _ => 'M12 12h.01',
  };
  return svg(
    [
      path(
        [],
        d: data,
        fill: const Color('none'),
        stroke: const Color('currentColor'),
        strokeWidth: '2',
        attributes: {'stroke-linecap': 'round', 'stroke-linejoin': 'round'},
      ),
    ],
    classes: 'icon',
    viewBox: '0 0 24 24',
    width: 22.px,
    height: 22.px,
  );
}

Component iconButton(String name, String label, void Function() onClick) {
  return button(
    [svgIcon(name)],
    classes: 'icon-button',
    type: ButtonType.button,
    attributes: {'title': label, 'aria-label': label},
    onClick: onClick,
  );
}

Component textButton(
  String label,
  void Function() onClick, {
  bool danger = false,
}) {
  return button(
    [.text(label)],
    classes: danger ? 'text-button danger' : 'text-button',
    type: ButtonType.button,
    onClick: onClick,
  );
}

Component hdsBar(
  AppStore store, {
  required List<Component> title,
  List<Component> actions = const [],
  bool hidden = false,
}) {
  return header(classes: hidden ? 'appbar hidden' : 'appbar', [
    iconButton('menu', 'Menu', store.openNav),
    div(classes: 'title', title),
    div(classes: 'actions', actions),
  ]);
}

Component switchRow(
  String label,
  bool value,
  void Function(bool value) onChanged,
) {
  return div(classes: 'switch-row', [
    span([.text(label)]),
    button(
      [span([], classes: 'knob')],
      classes: value ? 'switch on' : 'switch',
      type: ButtonType.button,
      attributes: {'aria-pressed': '$value', 'aria-label': label},
      onClick: () => onChanged(!value),
    ),
  ]);
}

Component fieldRow(String label, Component field) {
  return div(classes: 'field-row', [
    span([.text(label)]),
    field,
  ]);
}

class BoundField extends StatefulComponent {
  const BoundField({
    required this.value,
    required this.onChanged,
    this.multiline = false,
    this.placeholder,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool multiline;
  final String? placeholder;

  @override
  State<BoundField> createState() => _BoundFieldState();
}

class _BoundFieldState extends State<BoundField> {
  final _inputKey = GlobalNodeKey<web.HTMLInputElement>();
  final _areaKey = GlobalNodeKey<web.HTMLTextAreaElement>();

  @override
  void initState() {
    super.initState();
    _sync(force: true);
  }

  @override
  void didUpdateComponent(BoundField oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.value != component.value) _sync(force: false);
  }

  void _sync({required bool force}) {
    Future<void>.microtask(() {
      if (!mounted) return;
      if (component.multiline) {
        final node = _areaKey.currentNode;
        if (node == null) return;
        if ((force || web.document.activeElement != node) &&
            node.value != component.value) {
          node.value = component.value;
        }
      } else {
        final node = _inputKey.currentNode;
        if (node == null) return;
        if ((force || web.document.activeElement != node) &&
            node.value != component.value) {
          node.value = component.value;
        }
      }
    });
  }

  @override
  Component build(BuildContext context) {
    if (component.multiline) {
      return textarea(
        [],
        key: _areaKey,
        classes: 'text-input',
        rows: 10,
        onInput: component.onChanged,
      );
    }
    return input(
      key: _inputKey,
      classes: 'text-input',
      attributes: {
        if (component.placeholder != null)
          'placeholder': component.placeholder!,
      },
      onInput: component.onChanged,
    );
  }
}
