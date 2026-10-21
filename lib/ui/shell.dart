import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../models.dart';
import '../src/version.dart';
import '../store.dart';
import 'common.dart';

class PageChrome extends StatelessComponent {
  const PageChrome({
    required this.store,
    required this.title,
    required this.body,
    this.actions = const [],
    this.immersive = false,
    this.overlayColor,
    this.leading,
    super.key,
  });

  final AppStore store;
  final List<Component> title;
  final Component body;
  final List<Component> actions;
  final bool immersive;
  final int? overlayColor;
  final Component? leading;

  @override
  Component build(BuildContext context) {
    final hidden = immersive && !store.mouseHovering;
    final background = overlayColor == null ? null : cssArgb(overlayColor!);
    return div(
      classes: background == null ? 'page' : 'page overlay',
      styles: background == null
          ? null
          : Styles(raw: {'--overlay': background}),
      events: immersive ? {'pointermove': (_) => store.hover()} : null,
      [
        header(classes: hidden ? 'appbar hidden' : 'appbar', [
          leading ?? iconButton('menu', 'Menu', store.openNav),
          div(classes: 'title', title),
          div(classes: 'actions', actions),
        ]),
        div(classes: 'page-body', [body]),
        if (store.navOpen) ...[
          button(
            classes: 'scrim',
            attributes: {'aria-label': 'Close menu'},
            onClick: store.closeNav,
            [],
          ),
          _NavigationDrawer(store: store),
        ],
      ],
    );
  }
}

class _NavigationDrawer extends StatelessComponent {
  const _NavigationDrawer({required this.store});

  final AppStore store;

  static const _github = 'https://git.io/J3NOR';
  static const _discord = 'https://discord.gg/FayYYcm';
  static const _ios =
      'https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=hds.dev&mt=8';
  static const _android =
      'https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter';

  @override
  Component build(BuildContext context) {
    final github = store.settings.darkMode
        ? 'images/githubDark.png'
        : 'images/githubLight.png';
    return aside(classes: 'drawer start', [
      div(classes: 'drawer-header', [.text(packageVersion)]),
      nav(classes: 'drawer-scroll', [
        _route(context, 'Overlay', '/overlay'),
        _route(context, 'Settings', '/settings'),
        div(classes: 'divider', []),
        _link('Setup instructions', github, _github),
        _link('Discord server', 'images/discord.png', _discord),
        _link('Apple Watch app', 'images/appStore.png', _ios),
        _link('Android watch app', 'images/googlePlay.png', _android),
        div(classes: 'divider', []),
        _route(context, 'Privacy Policy', '/privacy_policy'),
        _route(context, 'Terms of Use', '/terms'),
        _route(context, 'Credits', '/credits'),
        _route(context, 'Licenses', '/licenses'),
      ]),
      a(
        classes: 'jaspr-badge',
        href: 'https://jaspr.site',
        target: Target.blank,
        attributes: {'rel': 'noopener noreferrer'},
        [store.settings.darkMode ? JasprBadge.dark() : JasprBadge.light()],
      ),
    ]);
  }

  Component _route(BuildContext context, String label, String route) {
    return button(
      classes: 'drawer-item',
      [.text(label)],
      onClick: () {
        final current = Router.of(context).matchList.uri.path;
        store.closeNav();
        if (current != route) Router.of(context).push(route);
      },
    );
  }

  Component _link(String label, String image, String url) {
    return a(
      classes: 'link-item',
      href: url,
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer'},
      [
        span([.text(label)]),
        img(src: image, alt: ''),
      ],
    );
  }
}

class EndDrawer extends StatelessComponent {
  const EndDrawer({required this.store, required this.child, super.key});

  final AppStore store;
  final Component child;

  @override
  Component build(BuildContext context) {
    if (store.endPanel == EndPanel.none) return const Component.empty();
    return Component.fragment([
      button(
        classes: 'scrim',
        attributes: {'aria-label': 'Close panel'},
        onClick: store.closeEnd,
        [],
      ),
      aside(classes: 'drawer end', [child]),
    ]);
  }
}
