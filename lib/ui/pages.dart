import 'dart:async';
import 'dart:js_interop';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:web/web.dart' as web;

import '../models.dart';
import '../store.dart';
import 'common.dart';
import 'data_view.dart';
import 'editors.dart';
import 'shell.dart';

class OverlayPage extends StatefulComponent {
  const OverlayPage({required this.store, super.key});

  final AppStore store;

  @override
  State<OverlayPage> createState() => _OverlayPageState();
}

class _OverlayPageState extends State<OverlayPage> {
  @override
  void initState() {
    super.initState();
    // start() logs immediately, which notifies listeners. That has to wait
    // until this first build has finished.
    Future<void>.microtask(() {
      if (mounted) component.store.startConnection();
    });
  }

  @override
  void dispose() {
    component.store.stopConnection();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final store = component.store;
    return PageChrome(
      store: store,
      immersive: true,
      overlayColor: store.settings.overlayBackgroundColor,
      title: [
        h1([.text('Health Data Server')]),
        if (store.settings.hdsCloud)
          span(classes: 'cloud', [.text('HDS Cloud ID: ${store.overlayId}')]),
      ],
      actions: [
        if (store.saveMenu || store.loadMenu)
          button(
            classes: 'menu-scrim',
            attributes: {'aria-label': 'Close menu'},
            onClick: store.closeMenus,
            [],
          ),
        iconButton(
          'upload',
          'Export configuration',
          () => store.showDialog(AppDialog.export),
        ),
        iconButton(
          'download',
          'Import configuration',
          () => store.showDialog(AppDialog.import),
        ),
        div(classes: 'menu-anchor', [
          iconButton('save', 'Create profile', store.toggleSaveMenu),
          if (store.saveMenu)
            div(classes: 'popup wide', [
              div(classes: 'popup-row', [
                BoundField(
                  value: store.profileDraft,
                  placeholder: 'Profile name',
                  onChanged: store.setProfileDraft,
                ),
                iconButton(
                  'save',
                  'Save profile',
                  () => unawaited(store.saveProfile()),
                ),
              ]),
            ]),
        ]),
        if (store.profiles.isNotEmpty)
          div(classes: 'menu-anchor', [
            iconButton('upload-file', 'Load profile', store.toggleLoadMenu),
            if (store.loadMenu)
              div(classes: 'popup', [
                for (final profile in store.profiles)
                  div(classes: 'profile-row', [
                    button(
                      classes: 'profile-load',
                      type: ButtonType.button,
                      onClick: () => unawaited(store.loadProfile(profile)),
                      [.text(profile.name)],
                    ),
                    iconButton(
                      store.armed('profile-${profile.key}')
                          ? 'delete-forever'
                          : 'delete',
                      'Delete profile',
                      () {
                        if (store.confirm('profile-${profile.key}')) {
                          unawaited(store.deleteProfile(profile));
                        }
                      },
                      danger: true,
                    ),
                  ]),
              ]),
          ]),
        iconButton('add', 'Add widget', store.showDataPicker),
        iconButton('chart', 'Add chart', store.showChartPicker),
      ],
      body: div(classes: 'stage-wrap', [
        div(classes: 'stage', [
          dataCanvas(store),
          div(classes: 'log-slot', [
            if (store.mouseHovering)
              div(classes: 'log', [
                for (final log in store.logs.reversed)
                  p(styles: Styles(color: Color(_logColor(log.level))), [
                    .text(log.line),
                  ]),
              ]),
          ]),
        ]),
        EndDrawer(
          store: store,
          child: EndPanelView(store: store),
        ),
      ]),
    );
  }
}

String _logColor(LogLevel level) {
  return switch (level) {
    LogLevel.info => '#ffffff',
    LogLevel.good => '#4caf50',
    LogLevel.hdsCloud => '#ff9800',
    LogLevel.data => '#2196f3',
    LogLevel.warn => '#ffeb3b',
    LogLevel.error => '#f44336',
  };
}

class SettingsPage extends StatefulComponent {
  const SettingsPage({required this.store, super.key});

  final AppStore store;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _pickingColor = false;

  @override
  Component build(BuildContext context) {
    final store = component.store;
    final settings = store.settings;
    return PageChrome(
      store: store,
      title: [
        h1([.text('Settings')]),
      ],
      body: div(classes: 'settings', [
        div(classes: 'settings-card', [
          switchRow(
            'Dark mode',
            settings.darkMode,
            (value) =>
                unawaited(store.saveSettings((item) => item.darkMode = value)),
          ),
          div(classes: 'divider', []),
          switchRow('HDS Cloud', settings.hdsCloud, (value) {
            unawaited(store.saveSettings((item) => item.hdsCloud = value));
            if (value) {
              unawaited(
                store.firebase.ensureSignedIn().catchError((Object error) {
                  store.addLog(
                    LogLevel.error,
                    'Unable to sign in to HDS Cloud',
                  );
                }),
              );
            }
          }),
          if (!settings.hdsCloud) ...[
            div(classes: 'divider', []),
            fieldRow(
              'Server IP address',
              BoundField(
                value: settings.serverIp,
                onChanged: (value) => unawaited(
                  store.saveSettings((item) => item.serverIp = value),
                ),
              ),
            ),
            div(classes: 'divider', []),
            fieldRow(
              'WebSocket port',
              BoundField(
                value: '${settings.port}',
                onChanged: (value) => unawaited(
                  store.saveSettings(
                    (item) =>
                        item.port = int.tryParse(value) ?? Settings.defaultPort,
                  ),
                ),
              ),
            ),
          ],
          div(classes: 'divider', []),
          div(classes: 'switch-row', [
            span([.text('Overlay background color')]),
            button(
              classes: 'swatch lg',
              styles: Styles(
                backgroundColor: Color(
                  cssArgb(settings.overlayBackgroundColor),
                ),
                raw: {'margin-left': 'auto'},
              ),
              attributes: {'aria-label': 'Overlay background color'},
              onClick: () => setState(() => _pickingColor = true),
              [],
            ),
          ]),
          div(classes: 'divider', []),
          fieldRow(
            'Data clear interval (seconds)',
            BoundField(
              value: '${settings.dataClearInterval}',
              onChanged: (value) => unawaited(
                store.saveSettings(
                  (item) => item.dataClearInterval = int.tryParse(value) ?? 120,
                ),
              ),
            ),
          ),
        ]),
        if (_pickingColor)
          div(classes: 'dialog-scrim', [
            div(classes: 'dialog', [
              h2([.text('Pick a background color')]),
              div(classes: 'color-row', [
                button(
                  classes: 'swatch',
                  styles: Styles(
                    raw: {
                      'width': '50px',
                      'height': '50px',
                      'background': '#121212',
                    },
                  ),
                  attributes: {'aria-label': 'Dark'},
                  onClick: () => _setColor(colorDarkBackground),
                  [],
                ),
                button(
                  classes: 'swatch',
                  styles: Styles(raw: {'width': '50px', 'height': '50px'}),
                  attributes: {'aria-label': 'Transparent'},
                  onClick: () => _setColor(colorTransparent),
                  [],
                ),
              ]),
              div(classes: 'dialog-actions', [
                textButton(
                  'Close',
                  () => setState(() => _pickingColor = false),
                ),
              ]),
            ]),
          ]),
      ]),
    );
  }

  void _setColor(int color) {
    unawaited(
      component.store.saveSettings(
        (settings) => settings.overlayBackgroundColor = color,
      ),
    );
    setState(() => _pickingColor = false);
  }
}

class TextPage extends StatefulComponent {
  const TextPage({
    required this.store,
    required this.title,
    required this.url,
    super.key,
  });

  final AppStore store;
  final String title;
  final String url;

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  String _text = 'Loading...';

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final response = await web.window.fetch(component.url.toJS).toDart;
      final text = (await response.text().toDart).toDart;
      if (mounted) setState(() => _text = text);
    } catch (_) {
      if (mounted) setState(() => _text = 'Unable to load this page.');
    }
  }

  @override
  Component build(BuildContext context) {
    return PageChrome(
      store: component.store,
      title: [
        h1([.text(component.title)]),
      ],
      leading: iconButton('close', 'Back', () => Router.of(context).back()),
      body: div(classes: 'info', [
        article([.text(_text)]),
      ]),
    );
  }
}

class CreditsPage extends StatelessComponent {
  const CreditsPage({required this.store, super.key});

  final AppStore store;

  @override
  Component build(BuildContext context) {
    return PageChrome(
      store: store,
      title: [
        h1([.text('Credits')]),
      ],
      leading: iconButton('close', 'Back', () => Router.of(context).back()),
      body: div(classes: 'info', [
        article([
          p([.text('App Store® is a registered trademark of Apple Inc.')]),
          p([
            .text(
              'Google Play and the Google Play logo are trademarks of Google LLC.',
            ),
          ]),
        ]),
      ]),
    );
  }
}

class LicensesPage extends StatelessComponent {
  const LicensesPage({required this.store, super.key});

  final AppStore store;

  @override
  Component build(BuildContext context) {
    return PageChrome(
      store: store,
      title: [
        h1([.text('Licenses')]),
      ],
      leading: iconButton('close', 'Back', () => Router.of(context).back()),
      body: div(classes: 'info', [
        article(classes: 'licenses', [
          p([
            .text(
              'Health Data Server Overlay is open source. These packages help it run in the browser:',
            ),
          ]),
          p([.text('jaspr and jaspr_router — MIT License')]),
          p([.text('hive_ce — Apache License 2.0')]),
          p([.text('web — BSD 3-Clause License')]),
          p([.text('web_socket_channel — BSD 3-Clause License')]),
          p([
            .text('Package license texts are published with each package on '),
            a(href: 'https://pub.dev', target: Target.blank, [
              .text('pub.dev'),
            ]),
            .text('.'),
          ]),
        ]),
      ]),
    );
  }
}
