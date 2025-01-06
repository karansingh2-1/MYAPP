import 'package:intl/intl.dart';

class UsageData {
  final String packageName;
  final String appName;
  int clickCount;
  int usageTime;
  List<String> clickTimestamps;
  List<String> usageTimestamps;

  UsageData({
    required this.packageName,
    required this.appName,
    this.clickCount = 0,
    this.usageTime = 0,
    this.clickTimestamps = const [],
    this.usageTimestamps = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'clickCount': clickCount,
      'usageTime': usageTime,
      'clickTimestamps': clickTimestamps.join(','), // Store as comma-separated string
      'usageTimestamps': usageTimestamps.join(','), // Store as comma-separated string
    };
  }

  static UsageData fromMap(Map<String, dynamic> map) {
    return UsageData(
      packageName: map['packageName'],
      appName: map['appName'],
      clickCount: map['clickCount'],
      usageTime: map['usageTime'],
      clickTimestamps: map['clickTimestamps'].toString().split(','),
      usageTimestamps: map['usageTimestamps'].toString().split(','),
    );
  }

  String formatTimestamps(List<String> timestamps) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return timestamps.map((ts) => formatter.format(DateTime.parse(ts))).join('\n');
  }
}
