import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/entry.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'entries';

  // GET: Получить все записи
  Future<List<Entry>> getEntries() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Entry.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки записей: $e');
    }
  }

  // POST: Создать новую запись
  Future<Entry> createEntry(Entry entry) async {
    try {
      final data = entry.toJson();
      data.remove('id'); // Firestore создаст ID автоматически
      
      final docRef = await _firestore.collection(_collection).add(data);
      final doc = await docRef.get();
      
      final newData = doc.data()!;
      newData['id'] = doc.id;
      return Entry.fromJson(newData);
    } catch (e) {
      throw Exception('Ошибка создания записи: $e');
    }
  }

  // GET: Получить одну запись по ID
  Future<Entry> getEntryById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Entry.fromJson(data);
      } else {
        throw Exception('Запись не найдена');
      }
    } catch (e) {
      throw Exception('Ошибка загрузки записи: $e');
    }
  }

  // UPDATE: Обновить запись
  Future<Entry> updateEntry(String id, Entry entry) async {
    try {
      final data = entry.toJson();
      data.remove('id'); // ID не обновляем
      
      await _firestore.collection(_collection).doc(id).update(data);
      
      return getEntryById(id);
    } catch (e) {
      throw Exception('Ошибка обновления записи: $e');
    }
  }

  // DELETE: Удалить запись
  Future<void> deleteEntry(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Ошибка удаления записи: $e');
    }
  }
}