import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para codificar y decodificar JSON

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Métodos para Hábitos
  static Future<void> saveHabits(List<Map<String, dynamic>> habits) async {
    final String encodedList = json.encode(habits);
    await _prefs.setString('habits', encodedList);
  }

  static List<Map<String, dynamic>> getHabits() {
    final String? encodedList = _prefs.getString('habits');
    if (encodedList == null) return [];
    final List decodedList = json.decode(encodedList) as List;
    return decodedList.cast<Map<String, dynamic>>().toList();
  }

  // Métodos para Registros de Glucosa
  static Future<void> saveGlucosaRecords(List<Map<String, dynamic>> records) async {
    final String encodedList = json.encode(records);
    await _prefs.setString('glucosa_records', encodedList);
  }

  static List<Map<String, dynamic>> getGlucosaRecords() {
    final String? encodedList = _prefs.getString('glucosa_records');
    if (encodedList == null) return [];
    final List decodedList = json.decode(encodedList) as List;
    return decodedList.cast<Map<String, dynamic>>().toList();
  }

  // Métodos para Configuración
  static Future<void> saveLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  static String? getLanguage() {
    return _prefs.getString('language');
  }

  static Future<void> saveCountry(String country) async {
    await _prefs.setString('country', country);
  }

  static String? getCountry() {
    return _prefs.getString('country');
  }

  static Future<void> saveDiabetesType(String type) async {
    await _prefs.setString('diabetes_type', type);
  }

  static String? getDiabetesType() {
    return _prefs.getString('diabetes_type');
  }

  static Future<void> saveGlucosaReminderTime(String time) async {
    await _prefs.setString('glucosa_reminder_time', time);
  }

  static String? getGlucosaReminderTime() {
    return _prefs.getString('glucosa_reminder_time');
  }
}
