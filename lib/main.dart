import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:hds_overlay/interface/data_view.dart';
import 'package:hds_overlay/interface/navigation_drawer.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hds_overlay/utils/null_safety.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'blocs/socket_server/socket_server_bloc.dart';
import 'hive/hive_utils.dart';
import 'hive/settings.dart';
import 'interface/log_view.dart';
import 'interface/routes.dart';
import 'interface/settings_view.dart';

void main() async {
  final hive = HiveUtils();
  await hive.init();
  runApp(MyApp(hive));
}

class MyApp extends StatelessWidget {
  final HiveUtils hive;
  late final SocketServerBloc socketServerBloc;

  MyApp(this.hive) {
    socketServerBloc = SocketServerBloc(hive, SocketServerRepo());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DesktopWindow.setWindowSize(Size(1000, 500));
    DesktopWindow.setMaxWindowSize(Size(1000, 500));
    DesktopWindow.setMinWindowSize(Size(1000, 500));

    return ValueListenableBuilder(
      valueListenable: hive.settingsBox.listenable(),
      builder: (context, Box box, widget) {
        final Settings settings = box.getAt(0);

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: createMaterialColor(AppColors.accent),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: createMaterialColor(AppColors.accent),
          ),
          themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/overlay',
          routes: {
            Routes.overlay: (context) => MultiProvider(
                  providers: [
                    Provider<HiveUtils>(create: (_) => hive),
                    Provider<SocketServerBloc>(create: (_) => socketServerBloc),
                  ],
                  child: Overlay(),
                ),
            Routes.settings: (context) => Provider<HiveUtils>(
                  create: (_) => hive,
                  child: SettingsView(),
                ),
          },
        );
      },
    );
  }
}

class Overlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SocketServerBloc socketServerBloc =
        Provider.of<SocketServerBloc>(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StreamBuilder<SocketServerState>(
      stream: socketServerBloc.stream,
      initialData: socketServerBloc.state,
      builder: (context, socketServerState) {
        final state = socketServerState.data;

        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('Health Data Server'),
          ),
          drawer: NavigationDrawer(),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: DataView(
                      cast<SocketServerStateRunning>(socketServerState.data)
                          ?.messages),
                ),
                LogView(cast<SocketServerStateRunning>(state)?.log ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
