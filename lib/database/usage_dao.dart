import 'package:floor/floor.dart';
import '../models/usage_data.dart';

@dao
abstract class UsageDao {
  @Query('SELECT * FROM UsageData')
  Future<List<UsageData>> findAllUsageData();

  @Query('SELECT * FROM UsageData WHERE packageName = :packageName')
  Future<UsageData?> findUsageDataByPackageName(String packageName);

  @insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUsageData(UsageData usageData);

  @update
  Future<void> updateUsageData(UsageData usageData);

  @delete
  Future<void> deleteUsageData(UsageData usageData);
}
