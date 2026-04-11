import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await _db.getAllNotes();
    notifyListeners();
  }

  Future<void> addNote(String title, String description) async {
    final note = Note(title: title, description: description);
    await _db.insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _db.updateNote(note);
    _notes = _notes.map((n) {
      if (n.id == note.id) return note;
      return n;
    }).toList();
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await _db.deleteNote(id);
    await loadNotes();
  }
}
