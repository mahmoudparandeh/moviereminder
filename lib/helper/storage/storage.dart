import 'package:shared_preferences/shared_preferences.dart';

enum StorageType { stringType, intType, boolType, doubleType, listType }

class StorageService {
  StorageService._();

  static StorageService? _storageUtil;
  static SharedPreferences? _preferences;

  static Future<StorageService> getInstance() async {
    return _storageUtil ??= await _init();
  }

  static Future _init() async {
    var secureStorage = StorageService._();
    _preferences = await SharedPreferences.getInstance();
    return secureStorage;
  }

  static void set(key, value, type) {
    if (_preferences != null) {
      switch (type) {
        case StorageType.stringType:
          {
            _preferences!.setString(key, value);
            break;
          }
        case StorageType.intType:
          {
            _preferences!.setInt(key, value);
            break;
          }
        case StorageType.boolType:
          {
            _preferences!.setBool(key, value);
            break;
          }
        case StorageType.doubleType:
          {
            _preferences!.setDouble(key, value);
            break;
          }
        case StorageType.listType:
          {
            _preferences!.setStringList(key, value);
            break;
          }
      }
    }
  }

  static dynamic get(key , type) {
    dynamic data;
    if (_preferences != null) {
      switch (type) {
        case StorageType.stringType:
          {
            data = _preferences!.getString(key);
            break;
          }
        case StorageType.intType:
          {
            data = _preferences!.getInt(key);
            break;
          }
        case StorageType.boolType:
          {
            data = _preferences!.getBool(key);
            break;
          }
        case StorageType.doubleType:
          {
            data = _preferences!.getDouble(key);
            break;
          }
        case StorageType.listType:
          {
            data = _preferences!.getStringList(key);
            break;
          }
      }
    }
    return data;
  }


  static dynamic delete(key ) {
    if (_preferences != null && _preferences!.containsKey(key)) {
      _preferences!.remove(key);
      return true;
    }else{
      return false;
    }
  }
}