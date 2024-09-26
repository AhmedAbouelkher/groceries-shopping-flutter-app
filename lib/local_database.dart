import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static PreferenceUtils? _instance;
  static late SharedPreferences _preferences;

  static PreferenceUtils getInstance() {
    _instance ??= PreferenceUtils();
    return _instance!;
  }

  static Future<void> init() async {}

  /// T is the  `runTimeType` data which you are trying to save (bool - String - double)
  Future<bool> saveValueWithKey<T>(String key, T value) async {
    debugPrint("SharedPreferences: [Saving data] -> key: $key, value: $value");
    if (value is String) {
      return await _preferences.setString(key, value);
    } else if (value is bool) {
      return await _preferences.setBool(key, value);
    } else if (value is double) {
      return await _preferences.setDouble(key, value);
    } else if (value is int) {
      return await _preferences.setInt(key, value);
    } else if (value is List<String>) {
      debugPrint(
          "WARNING: You are trying to save a [value] of type [List<String>]");
      await _preferences.setStringList(key, value);
    } else {
      throw "not a supported type";
    }
    return false;
  }

  // Future<bool> saveBool(String key, bool value) {
  //   debugPrint("SharedPreferences: [Save data] -> key: $key, value: $value");
  //   return _preferences.setBool(key, value);
  // }

  ///not a Future method
  getValueWithKey(String key,
      {bool bypassValueChecking = true, bool hideDebugPrint = false}) {
    var value = _preferences.get(key);
    if (value == null && !bypassValueChecking) {
      throw PlatformException(
          code: "SHARED_PREFERENCES_VALUE_CAN'T_BE_NULL",
          message:
              "you have ordered a value which doesn't exist in Shared Preferences",
          details:
              "make sure you have saved the value in advance in order to get it back");
    }
    if (!hideDebugPrint) {
      debugPrint(
          "SharedPreferences: [Reading data] -> key: $key, value: $value");
    }
    return value;
  }

  Future<bool> removeValueWithKey(String key) async {
    var value = _preferences.get(key);
    if (value == null) return true;
    debugPrint(
        "SharedPreferences: [Removing data] -> key: $key, value: $value");
    return await _preferences.remove(key);
  }

  removeMultipleValuesWithKeys(List<String> keys) async {
    Object? value;
    for (String key in keys) {
      value = _preferences.get(key);
      if (value == null) {
        debugPrint(
          "SharedPreferences: [Removing data] -> key: $key, value: {ERROR 'null' value}",
        );
        debugPrint("Skipping...");
      } else {
        await _preferences.remove(key);
        debugPrint(
          "SharedPreferences: [Removing data] -> key: $key, value: $value",
        );
      }
    }
    return;
  }

  Future<bool> clearAll() async {
    return await _preferences.clear();
  }
}
