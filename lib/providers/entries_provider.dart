import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/api_service.dart';

class EntriesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Entry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<Entry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Загрузить все записи
  Future<void> fetchEntries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = await _apiService.getEntries();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _entries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Добавить новую запись
  Future<bool> addEntry(Entry entry) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newEntry = await _apiService.createEntry(entry);
      _entries.insert(0, newEntry);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Получить запись по ID
  Entry? getEntryById(String id) {
    try {
      return _entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  // Удалить запись
  Future<bool> deleteEntry(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteEntry(id);
      _entries.removeWhere((entry) => entry.id == id);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Обновить запись
  Future<bool> updateEntry(Entry updatedEntry) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _apiService.updateEntry(updatedEntry.id, updatedEntry);
      final index = _entries.indexWhere((entry) => entry.id == updated.id);
      if (index != -1) {
        _entries[index] = updated;
      }
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
