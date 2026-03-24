import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/counter.dart';

class CounterProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<Counter> _counters = [];

  List<Counter> get counters => _counters;

  Future<void> loadCounters() async {
    _counters = await _db.getAllCounters();
    notifyListeners();
  }

  Future<void> addCounter(String label, int initialCount) async {
    final counter = Counter(label: label, count: initialCount);
    await _db.insertCounter(counter);
    await loadCounters();
  }

  Future<void> updateCounter(Counter counter) async {
    await _db.updateCounter(counter);
    _counters = _counters.map((c) {
      if (c.id == counter.id) return counter;
      return c;
    }).toList();
    notifyListeners();
  }

  Future<void> deleteCounter(int id) async {
    await _db.deleteCounter(id);
    await loadCounters();
  }

  Future<void> increment(int id) async {
    final counter = _counters.firstWhere((c) => c.id == id);
    final updated = counter.copyWith(count: counter.count + 1);
    await _db.updateCounter(updated);
    _counters = _counters.map((c) {
      if (c.id == id) return updated;
      return c;
    }).toList();
    notifyListeners();
  }

  Future<void> decrement(int id) async {
    final counter = _counters.firstWhere((c) => c.id == id);
    final updated = counter.copyWith(count: counter.count - 1);
    await _db.updateCounter(updated);
    _counters = _counters.map((c) {
      if (c.id == id) return updated;
      return c;
    }).toList();
    notifyListeners();
  }
}
