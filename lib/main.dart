import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hds_overlay/interface/data_view.dart';
import 'package:hds_overlay/interface/navigation_drawer.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hds_overlay/utils/null_safety.dart';

import 'blocs/hive/hive_bloc.dart';
import 'blocs/socket_server/socket_server_bloc.dart';
import 'hive/hive_utils.dart';
import 'interface/log_view.dart';
import 'interface/routes.dart';
import 'interface/settings_view.dart';

void main() async {
  final hive = HiveUtils();
  await hive.init();
  runApp(MyApp(hive));
}

class MyApp extends StatelessWidget {
  late final HiveBloc hiveBloc;
  late final SocketServerBloc socketServerBloc;

  MyApp(HiveUtils hive) {
    hiveBloc = HiveBloc(hive);
    socketServerBloc = SocketServerBloc(hive, SocketServerRepo());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DesktopWindow.setWindowSize(Size(1000, 500));
    DesktopWindow.setMaxWindowSize(Size(1000, 500));
    DesktopWindow.setMinWindowSize(Size(1000, 500));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(AppColors.accent),
      ),
      initialRoute: '/overlay',
      routes: {
        Routes.overlay: (context) => BlocProvider.value(
              value: hiveBloc,
              child: BlocProvider.value(
                value: socketServerBloc,
                child: MyHomePage(),
              ),
            ),
        Routes.settings: (context) => BlocProvider.value(
              value: hiveBloc,
              child: SettingsView(),
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SocketServerBloc socketServerBloc =
        BlocProvider.of<SocketServerBloc>(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StreamBuilder<SocketServerState>(
      stream: socketServerBloc.stream,
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
                            ?.messages)),
                LogView(cast<SocketServerStateRunning>(state)?.log ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
