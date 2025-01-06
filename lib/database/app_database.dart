import 'package:floor/floor.dart';

import '../models/usage_data.dart';
import 'usage_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [UsageData])
abstract class AppDatabase extends FloorDatabase {
  UsageDao get usageDao;
}
