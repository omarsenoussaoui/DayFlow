import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/note_provider.dart';
import '../utils/constants.dart';

class NoteDetailScreen extends StatefulWidget {
  final int noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  bool _initialized = false;

  @override
  void dispose() {
    if (_initialized) {
      _titleController.dispose();
      _descController.dispose();
    }
    super.dispose();
  }

  void _save() {
    final provider = context.read<NoteProvider>();
    final note = provider.notes.where((n) => n.id == widget.noteId).firstOrNull;
    if (note == null) return;

    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) return;

    provider.updateNote(
      note.copyWith(
        title: newTitle,
        description: _descController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Consumer<NoteProvider>(
      builder: (context, provider, _) {
        final note =
            provider.notes.where((n) => n.id == widget.noteId).firstOrNull;
        if (note == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!_initialized) {
          _titleController = TextEditingController(text: note.title);
          _descController = TextEditingController(text: note.description);
          _initialized = true;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.editNote),
            actions: [
              IconButton(
                icon: const Icon(Icons.check_rounded),
                tooltip: l10n.save,
                onPressed: () {
                  _save();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.noteTitle,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  onChanged: (_) => _save(),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: _descController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.noteDescription,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    onChanged: (_) => _save(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
