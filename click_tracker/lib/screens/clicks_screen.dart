import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import '../database/database_helper.dart';
import '../models/usage_data.dart';

class ClicksScreen extends StatefulWidget {
  const ClicksScreen({super.key});

  @override
  State<ClicksScreen> createState() => _ClicksScreenState();
}

class _ClicksScreenState extends State<ClicksScreen> {
  List<Application> _apps = [];
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadApps();
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
    final usageData = await _databaseHelper.getOne(app.packageName);
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
      await _databaseHelper.insert(newUsageData);
    } else {
      usageData.clickCount++;
      usageData.clickTimestamps.add(nowIso);
      await _databaseHelper.update(usageData);
    }
    setState(() {});
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
            future: _databaseHelper.getOne(app.packageName),
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
