import 'package:floor/floor.dart';

@entity
class UsageData {
  @primaryKey
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
}
