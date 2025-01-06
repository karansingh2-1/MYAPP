import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import '../database/app_database.dart';
import '../models/usage_data.dart';

class ClicksScreen extends StatefulWidget {
  const ClicksScreen({super.key});

  @override
  State<ClicksScreen> createState() => _ClicksScreenState();
}

class _ClicksScreenState extends State<ClicksScreen> {
  List<Application> _apps = [];
  late AppDatabase _database;
  late UsageDao _usageDao;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadApps();
  }

  Future<void> _initDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _usageDao = _database.usageDao;
  }

  Future<void> _loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );
    setState(() {
      _apps = apps;
    });
  }

  void _incrementClickCount(Application app) async {
    final usageData = await _usageDao.findUsageDataByPackageName(app.packageName);
    final now = DateTime.now();
    final nowIso = now.toIso8601String();
    if (usageData == null) {
      final newUsageData = UsageData(
        packageName: app.packageName,
        appName: app.appName,
        clickCount: 1,
        usageTime: 0,
        clickTimestamps: [nowIso],
        usageTimestamps: [],
      );
      await _usageDao.insertUsageData(newUsageData);
    } else {
      usageData.clickCount++;
      usageData.clickTimestamps.add(nowIso);
      await _usageDao.updateUsageData(usageData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clicks'),
      ),
      body: ListView.builder(
        itemCount: _apps.length,
        itemBuilder: (context, index) {
          Application app = _apps[index];
          return FutureBuilder<UsageData?>(
            future: _usageDao.findUsageDataByPackageName(app.packageName),
            builder: (context, snapshot) {
              final clickCount = snapshot.data?.clickCount ?? 0;
              return ListTile(
                leading: app is ApplicationWithIcon
                    ? Image.memory(app.icon)
                    : const Icon(Icons.android),
                title: Text(app.appName),
                trailing: Text('$clickCount'),
                onTap: () => _incrementClickCount(app),
              );
            },
          );
        },
      ),
    );
  }
}
