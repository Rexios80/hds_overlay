import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:web/web.dart' as web;

import 'models.dart';
import 'store.dart';
import 'ui/common.dart';
import 'ui/pages.dart';

class App extends StatefulComponent {
  const App({required this.store, super.key});

  final AppStore store;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    component.store.addListener(_changed);
    _applyTheme();
  }

  @override
  void dispose() {
    component.store.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    _applyTheme();
    if (mounted) setState(() {});
  }

  void _applyTheme() {
    web.document.documentElement?.classList.toggle(
      'dark',
      component.store.settings.darkMode,
    );
  }

  @override
  Component build(BuildContext context) {
    final store = component.store;
    return div(classes: 'app', [
      Router(
        routes: [
          Route(path: '/', redirect: (_, _) => '/overlay'),
          Route(
            path: '/overlay',
            title: 'Health Data Server',
            builder: (_, _) => OverlayPage(store: store),
          ),
          Route(
            path: '/settings',
            title: 'Settings',
            builder: (_, _) => SettingsPage(store: store),
          ),
          Route(
            path: '/privacy_policy',
            title: 'Privacy Policy',
            builder: (_, _) => TextPage(
              store: store,
              title: 'Privacy Policy',
              url: 'strings/privacy_policy',
            ),
          ),
          Route(
            path: '/terms',
            title: 'Terms of Use',
            builder: (_, _) => TextPage(
              store: store,
              title: 'Terms of Use',
              url: 'strings/terms',
            ),
          ),
          Route(
            path: '/credits',
            title: 'Credits',
            builder: (_, _) => CreditsPage(store: store),
          ),
          Route(
            path: '/licenses',
            title: 'Licenses',
            builder: (_, _) => LicensesPage(store: store),
          ),
        ],
      ),
      if (store.dialog != AppDialog.none) _Dialog(store: store),
    ]);
  }
}

class _Dialog extends StatefulComponent {
  const _Dialog({required this.store});

  final AppStore store;

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  final _exportKey = GlobalNodeKey<web.HTMLTextAreaElement>();

  @override
  void initState() {
    super.initState();
    if (component.store.dialog == AppDialog.export) {
      Future<void>.microtask(() => _exportKey.currentNode?.select());
    }
  }

  @override
  Component build(BuildContext context) {
    final store = component.store;
    final exporting = store.dialog == AppDialog.export;
    return div(classes: 'dialog-scrim', [
      div(classes: 'dialog', [
        h2([
          .text(
            exporting
                ? 'Copy the below config and put it somewhere safe'
                : 'Paste an overlay configuration below',
          ),
        ]),
        if (exporting)
          textarea(
            [.text(store.exportText)],
            key: _exportKey,
            classes: 'text-input',
            rows: 10,
            readonly: true,
            autofocus: true,
          )
        else
          BoundField(
            value: store.importDraft,
            placeholder: 'Paste it here',
            multiline: true,
            onChanged: store.setImportDraft,
          ),
        div(classes: 'dialog-actions', [
          if (!exporting)
            textButton('Import', () {
              try {
                store.importConfig(store.importDraft);
              } catch (_) {
                store.addLog(LogLevel.error, 'Failed to import config');
              }
            }),
          textButton('Close', store.closeDialog),
        ]),
        if (!exporting)
          p(classes: 'caption', [
            .text('This will overwrite the current overlay configuration'),
          ]),
      ]),
    ]);
  }
}
