import 'package:injectable/injectable.dart' as i;
import 'package:shared_preferences/shared_preferences.dart';

abstract class SaveMethod {
  Future<bool> saveCount(String key, int value);

  int? getCount(String key);
}

@i.lazySingleton
@i.injectable
class SharedPrefService implements SaveMethod {
  SharedPrefService({required this.pref});

  final SharedPreferences pref;

  @override
  int? getCount(String key) {
    return pref.getInt(key);
  }

  @override
  Future<bool> saveCount(String key, int value) {
    return pref.setInt(key, value);
  }
}

