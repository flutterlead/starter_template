import 'package:injectable/injectable.dart' as i;
import 'package:shared_preferences/shared_preferences.dart';

abstract class SaveMethod {
  Future<bool> saveLocale(String key, String value);

  String? getLocale(String key);
}

@i.lazySingleton
@i.injectable
class SharedPrefService implements SaveMethod {
  SharedPrefService({required this.pref});

  final SharedPreferences pref;

  @override
  String? getLocale(String key) {
    return pref.getString(key);
  }

  @override
  Future<bool> saveLocale(String key, String value) {
    return pref.setString(key, value);
  }
}
