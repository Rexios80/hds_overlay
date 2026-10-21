import 'dart:async';
import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

import 'connection.dart';
import 'firebase_client.dart';
import 'models.dart';

enum EndPanel { none, pickData, pickChart, editData, editChart }

enum AppDialog { none, export, import }

class AppStore extends ChangeNotifier {
  AppStore._(
    this.settings,
    this.firebaseConfig,
    this._data,
    this._charts,
    this._profiles,
    this.firebase,
  );

  final Settings settings;
  final FirebaseConfig firebaseConfig;
  final Box<DataWidgetProperties> _data;
  final Box<ChartWidgetProperties> _charts;
  final Box<OverlayProfile> _profiles;
  final FirebaseClient firebase;

  final messages = <(DataType, String), DataMessage>{};
  final history = <(DataType, String), List<DataMessage>>{};
  final logs = <LogMessage>[];
  final hrMins = <String, int>{};
  final hrMaxs = <String, int>{};
  final hrAvgs = <String, HrAverage>{};

  bool navOpen = false;
  EndPanel endPanel = EndPanel.none;
  (DataType, String)? editing;
  AppDialog dialog = AppDialog.none;
  bool saveMenu = false;
  bool loadMenu = false;
  String profileDraft = '';
  String importDraft = '';
  String exportText = '';
  String selectorSource = dataSourceWatch;
  bool mouseHovering = true;
  int clock = 0;

  final _armed = <String, Timer>{};
  Timer? _hoverTimer;
  LiveConnection? _connection;
  var _connectionGeneration = 0;
  var _sawUrlConfig = false;

  List<DataWidgetProperties> get dataWidgets => _data.values.toList();
  List<ChartWidgetProperties> get charts => _charts.values.toList();
  List<OverlayProfile> get profiles => _profiles.values.toList();
  String get overlayId => firebaseConfig.overlayId;

  static Future<AppStore> open() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive
        ..registerAdapter(DataWidgetPropertiesAdapter())
        ..registerAdapter(SettingsAdapter())
        ..registerAdapter(DataTypeAdapter())
        ..registerAdapter(Tuple2DoubleAdapter())
        ..registerAdapter(OverlayProfileAdapter())
        ..registerAdapter(FirebaseConfigAdapter())
        ..registerAdapter(ChartWidgetPropertiesAdapter());
    }

    final settingsBox = await Hive.openBox<Settings>('settings');
    final dataBox = await Hive.openBox<DataWidgetProperties>(
      'dataWidgetProperties',
    );
    final profileBox = await Hive.openBox<OverlayProfile>('overlayProfiles');
    final firebaseBox = await Hive.openBox<FirebaseConfig>('firebaseConfig');
    final chartBox = await Hive.openBox<ChartWidgetProperties>(
      'chartProperties',
    );

    if (settingsBox.isEmpty) await settingsBox.add(Settings());
    if (firebaseBox.isEmpty) await firebaseBox.add(FirebaseConfig());
    if (dataBox.isEmpty) {
      await dataBox.add(
        DataWidgetProperties()
          ..dataType = DataType.heartRate
          ..position = const Tuple2Double(10, 10),
      );
    }

    final store = AppStore._(
      settingsBox.values.first,
      firebaseBox.values.first,
      dataBox,
      chartBox,
      profileBox,
      FirebaseClient(),
    );
    Timer.periodic(const Duration(seconds: 5), (_) => store._clearStale());
    Timer.periodic(const Duration(seconds: 1), (_) {
      if (store.charts.isEmpty) return;
      store.clock++;
      store.notifyListeners();
    });
    store._armHover();
    store._importUrlConfig();
    return store;
  }

  void _importUrlConfig() {
    final config = Uri.parse(
      web.window.location.href,
    ).queryParameters['config'];
    if (config == null || config.isEmpty || _sawUrlConfig) return;
    _sawUrlConfig = true;
    try {
      importConfig(config);
      addLog(LogLevel.info, 'Imported config from url');
    } catch (error) {
      addLog(LogLevel.error, 'Failed to import config from url');
    }
  }

  void hover() {
    final showChrome = !mouseHovering;
    mouseHovering = true;
    _armHover();
    if (showChrome) notifyListeners();
  }

  void _armHover() {
    _hoverTimer?.cancel();
    _hoverTimer = Timer(const Duration(seconds: 15), () {
      mouseHovering = false;
      notifyListeners();
    });
  }

  void openNav() {
    navOpen = !navOpen;
    if (navOpen) _closeEnd();
    notifyListeners();
  }

  void closeNav() {
    if (!navOpen) return;
    navOpen = false;
    notifyListeners();
  }

  void showDataPicker() {
    endPanel = EndPanel.pickData;
    editing = null;
    navOpen = false;
    notifyListeners();
  }

  void showChartPicker() {
    endPanel = EndPanel.pickChart;
    editing = null;
    navOpen = false;
    notifyListeners();
  }

  void editData(DataType type, String source) {
    editing = (type, source);
    endPanel = EndPanel.editData;
    navOpen = false;
    notifyListeners();
  }

  void editChart(DataType type, String source) {
    editing = (type, source);
    endPanel = EndPanel.editChart;
    navOpen = false;
    notifyListeners();
  }

  void closeEnd() {
    if (endPanel == EndPanel.none) return;
    _closeEnd();
    notifyListeners();
  }

  void _closeEnd() {
    endPanel = EndPanel.none;
    editing = null;
  }

  void showDialog(AppDialog value) {
    dialog = value;
    importDraft = '';
    saveMenu = false;
    loadMenu = false;
    if (value == AppDialog.export) exportText = exportConfig();
    notifyListeners();
  }

  void closeMenus() {
    if (!saveMenu && !loadMenu) return;
    saveMenu = false;
    loadMenu = false;
    notifyListeners();
  }

  void closeDialog() {
    if (dialog == AppDialog.none) return;
    dialog = AppDialog.none;
    notifyListeners();
  }

  void toggleSaveMenu() {
    saveMenu = !saveMenu;
    loadMenu = false;
    notifyListeners();
  }

  void toggleLoadMenu() {
    loadMenu = !loadMenu;
    saveMenu = false;
    notifyListeners();
  }

  void setProfileDraft(String value) {
    profileDraft = value;
  }

  void setImportDraft(String value) {
    importDraft = value;
  }

  void setSelectorSource(String value) {
    selectorSource = value;
    notifyListeners();
  }

  bool armed(String key) => _armed.containsKey(key);

  bool confirm(String key) {
    final existing = _armed.remove(key);
    if (existing != null) {
      existing.cancel();
      notifyListeners();
      return true;
    }
    _armed[key] = Timer(const Duration(seconds: 1), () {
      _armed.remove(key);
      notifyListeners();
    });
    notifyListeners();
    return false;
  }

  DataWidgetProperties? dataByKey((DataType, String) key) {
    for (final widget in _data.values) {
      if (widget.slot == key) return widget;
    }
    return null;
  }

  ChartWidgetProperties? chartByKey((DataType, String) key) {
    for (final chart in _charts.values) {
      if (chart.slot == key) return chart;
    }
    return null;
  }

  Future<void> saveSettings(void Function(Settings settings) change) async {
    change(settings);
    notifyListeners();
    await settings.save();
  }

  Future<void> saveData(
    DataWidgetProperties properties,
    void Function() change,
  ) async {
    change();
    notifyListeners();
    await properties.save();
  }

  Future<void> saveChart(
    ChartWidgetProperties properties,
    void Function() change,
  ) async {
    change();
    notifyListeners();
    await properties.save();
  }

  Future<void> addWidget(DataType type, String source) async {
    await _data.add(
      DataWidgetProperties()
        ..dataType = type
        ..dataSource = source,
    );
    notifyListeners();
  }

  Future<void> addChart(DataType type, String source) async {
    await _charts.add(
      ChartWidgetProperties()
        ..dataType = type
        ..dataSource = source,
    );
    notifyListeners();
  }

  Future<void> deleteData(DataWidgetProperties properties) async {
    await properties.delete();
    _closeEnd();
    notifyListeners();
  }

  Future<void> deleteChart(ChartWidgetProperties properties) async {
    await properties.delete();
    _closeEnd();
    notifyListeners();
  }

  Future<void> saveProfile() async {
    final name = profileDraft.trim();
    if (name.isEmpty) return;
    await _profiles.add(
      OverlayProfile()
        ..name = name
        ..dataWidgetProperties = [
          for (final widget in _data.values) widget.copy(),
        ]
        ..chartWidgetProperties = [
          for (final chart in _charts.values) chart.copy(),
        ],
    );
    profileDraft = '';
    saveMenu = false;
    notifyListeners();
  }

  Future<void> deleteProfile(OverlayProfile profile) async {
    await profile.delete();
    loadMenu = false;
    notifyListeners();
  }

  Future<void> loadProfile(OverlayProfile profile) async {
    await _replaceWith(
      profile.dataWidgetProperties,
      profile.chartWidgetProperties,
    );
    loadMenu = false;
    notifyListeners();
  }

  String exportConfig() {
    final profile = OverlayProfile()
      ..name = 'export'
      ..dataWidgetProperties = [
        for (final widget in _data.values) widget.copy(),
      ]
      ..chartWidgetProperties = [
        for (final chart in _charts.values) chart.copy(),
      ];
    return jsonEncode(profile.toJson());
  }

  void importConfig(String raw) {
    var text = raw.trim();
    Object? decoded;
    try {
      decoded = jsonDecode(text);
    } catch (_) {
      text = Uri.decodeComponent(text);
      decoded = jsonDecode(text);
    }
    if (decoded is! Map)
      throw const FormatException('Config must be a JSON object');
    final profile = OverlayProfile.fromJson(decoded);
    unawaited(
      _replaceWith(profile.dataWidgetProperties, profile.chartWidgetProperties),
    );
    dialog = AppDialog.none;
    notifyListeners();
  }

  Future<void> _replaceWith(
    List<DataWidgetProperties> widgets,
    List<ChartWidgetProperties> charts,
  ) async {
    await _data.clear();
    await _charts.clear();
    if (widgets.isNotEmpty)
      await _data.addAll([for (final widget in widgets) widget.copy()]);
    if (charts.isNotEmpty)
      await _charts.addAll([for (final chart in charts) chart.copy()]);
    notifyListeners();
  }

  String regenerateOverlayId() {
    firebaseConfig.generateOverlayId();
    unawaited(firebaseConfig.save());
    notifyListeners();
    return firebaseConfig.overlayId;
  }

  void startConnection() {
    final generation = ++_connectionGeneration;
    unawaited(_connection?.stop());
    final LiveConnection connection = settings.hdsCloud
        ? RtdConnection(this, firebase)
        : SocketConnection(this);
    _connection = connection;
    unawaited(
      connection.start().catchError((Object error) {
        if (generation != _connectionGeneration) return;
        addLog(LogLevel.error, 'Connection failed: $error');
      }),
    );
  }

  void stopConnection() {
    _connectionGeneration++;
    unawaited(_connection?.stop());
    _connection = null;
    hrMins.clear();
    hrMaxs.clear();
    hrAvgs.clear();
  }

  void ingest(String raw, String source, {bool local = false}) {
    final separator = raw.indexOf(':');
    if (separator <= 0 || separator == raw.length - 1) return;
    final typeName = raw.substring(0, separator);
    final value = raw.substring(separator + 1);
    final type = dataTypeFromName(typeName);
    if (type == DataType.unknown) {
      addLog(LogLevel.warn, '($source) Unknown data type $typeName: $value');
      return;
    }

    final key = (type, source);
    final current = messages[key];
    final message = DataMessage(source, type, value);
    if (current?.value == value) return;
    messages[key] = message;
    addLog(LogLevel.data, '($source) ${message.name}: $value', notify: false);

    final entries = history.putIfAbsent(key, () => []);
    entries.add(message);
    if (entries.length > ChartWidgetProperties.maxValuesToKeep) {
      entries.removeRange(
        0,
        entries.length - ChartWidgetProperties.maxValuesToKeep,
      );
    }

    if (!local && type == DataType.heartRate) {
      final heartRate = int.tryParse(value);
      if (heartRate != null) _trackHeartRate(heartRate, source);
    }
    notifyListeners();
  }

  void _trackHeartRate(int heartRate, String source) {
    if (heartRate < (hrMins[source] ?? 999)) {
      hrMins[source] = heartRate;
      ingest('${DataType.heartRateMin.name}:$heartRate', source, local: true);
    }
    if (heartRate > (hrMaxs[source] ?? 0)) {
      hrMaxs[source] = heartRate;
      ingest('${DataType.heartRateMax.name}:$heartRate', source, local: true);
    }
    final average = hrAvgs
        .update(
          source,
          (value) => value..add(heartRate),
          ifAbsent: () => HrAverage(heartRate),
        )
        .average;
    ingest(
      '${DataType.heartRateAverage.name}:${average.toStringAsFixed(3)}',
      source,
      local: true,
    );
  }

  void _clearStale() {
    final interval = settings.dataClearInterval * 1000;
    final now = DateTime.now().millisecondsSinceEpoch;
    final remove = <(DataType, String)>[];
    messages.forEach((key, message) {
      if (key.$1 == DataType.heartRateAverage ||
          key.$1 == DataType.heartRateMin ||
          key.$1 == DataType.heartRateMax) {
        return;
      }
      if (now - message.timestamp.millisecondsSinceEpoch <= interval) return;
      remove.add(key);
      if (key.$1 == DataType.heartRate) {
        remove.addAll(
          messages.keys.where(
            (other) =>
                other.$2 == key.$2 &&
                (other.$1 == DataType.heartRateAverage ||
                    other.$1 == DataType.heartRateMin ||
                    other.$1 == DataType.heartRateMax),
          ),
        );
        hrAvgs.remove(key.$2);
        hrMins.remove(key.$2);
        hrMaxs.remove(key.$2);
      }
    });
    if (remove.isEmpty) return;
    for (final key in remove) {
      messages.remove(key);
      addLog(
        LogLevel.warn,
        '(${key.$2}) ${titleCase(key.$1.name)}: Data cleared after ${settings.dataClearInterval} seconds',
        notify: false,
      );
    }
    notifyListeners();
  }

  void addLog(LogLevel level, String message, {bool notify = true}) {
    logs.add(LogMessage(level, message));
    if (logs.length > 400) logs.removeRange(0, logs.length - 400);
    if (notify) notifyListeners();
  }

  int heartRateFor(String source) =>
      int.tryParse(messages[(DataType.heartRate, source)]?.value ?? '') ?? 0;
}
