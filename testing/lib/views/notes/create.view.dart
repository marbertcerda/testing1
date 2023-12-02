import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class CreateNoteView extends ConsumerStatefulWidget {
  const CreateNoteView({
    super.key,
    this.note,
    required this.mode,
  });

  final Note? note;
  final NoteMode mode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends ConsumerState<CreateNoteView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  NoteColor radioValue = NoteColor.none;
  NoteMode mode = NoteMode.create;

  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    mode = widget.mode;
    _titleController.addListener(_checkEmpty);
    _contentController.addListener(_checkEmpty);

    if (widget.mode != NoteMode.create) {
      final note = widget.note!;
      _titleController.text = note.title;
      _contentController.text = note.content;
      radioValue = note.color;
      _isEmpty = widget.mode == NoteMode.edit ? false : true;
    }
  }

  bool _checkEmpty() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      if (mode != NoteMode.view) {
        setState(() {
          _isEmpty = false;
        });
      }
    }
    return _isEmpty;
  }

  Color? _getColor(int alpha) {
    return radioValue == NoteColor.none
        ? null
        : radioValue.color.withAlpha(alpha);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    final colors = NoteColor.values.toList();
    colors.sort((a, b) => a.index.compareTo(b.index));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          mode == NoteMode.create
              ? 'Create Note'
              : mode == NoteMode.edit
                  ? 'Edit Note'
                  : 'View Note',
        ),
        backgroundColor: _getColor(200),
        actions: [
          Visibility(
            child: Visibility(
              visible: mode == NoteMode.edit,
              child: TextButton.icon(
                style: Theme.of(context).textButtonTheme.style!.copyWith(
                      foregroundColor: MaterialStatePropertyAll(
                        isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                onPressed: () {
                  setState(() {
                    mode = NoteMode.view;
                    radioValue = widget.note!.color;
                    _titleController.text = widget.note!.title;
                    _contentController.text = widget.note!.content;
                    _isEmpty = true;
                  });
                },
                icon: const Icon(Icons.close_rounded),
                label: const Text('Cancel'),
              ),
            ),
          ),
          SaveNoteButton(
            onPressed: _saveNote,
            editMode: mode == NoteMode.edit,
            isEmpty: _isEmpty,
          ),
          Visibility(
            visible: mode == NoteMode.view,
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Note'),
                        content: const Text(
                          'Are you sure you want to delete this note?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await NotesDatabase.instance.deleteNote(
                                note: widget.note!,
                              );
                              Navigator.of(navigatorKey.currentContext!).pop();
                              Navigator.of(navigatorKey.currentContext!).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.delete_rounded,
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                NoteFormField(
                  readOnly: mode == NoteMode.view,
                  hintText: 'Title',
                  titleController: _titleController,
                  expands: false,
                  keyboardType: TextInputType.text,
                  fillColor: _getColor(35),
                ),
                Expanded(
                  child: NoteFormField(
                    readOnly: mode == NoteMode.view,
                    hintText: 'Write your note here...',
                    titleController: _contentController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    fillColor: _getColor(25),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: mode == NoteMode.view,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              mode = NoteMode.edit;
            });
          },
          child: const Icon(Icons.edit_rounded),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: mode != NoteMode.view,
        maintainSize: false,
        child: BottomAppBar(
          surfaceTintColor: _getColor(50),
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: colors.map((color) {
                if (color == NoteColor.none) {
                  return Radio(
                    fillColor: MaterialStateProperty.all(Colors.grey),
                    value: color,
                    groupValue: radioValue,
                    onChanged: (value) {
                      setState(() {
                        radioValue = value as NoteColor;
                      });
                    },
                  );
                }

                return Radio(
                  fillColor: MaterialStateProperty.all(color.color),
                  activeColor: color.color,
                  value: color,
                  groupValue: radioValue,
                  onChanged: (value) {
                    setState(() {
                      radioValue = value as NoteColor;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    final currentUser = AuthService.instance.currentUser;
    Note note = Note(
      title: _titleController.text,
      content: _contentController.text,
      color: radioValue,
      userId: currentUser!.uid,
    );

    if (widget.note != null && mode == NoteMode.edit) {
      note = widget.note!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        color: radioValue,
        updatedAt: Timestamp.now(),
      );

      await NotesDatabase.instance.updateNote(
        note: note,
      );
    } else {
      await NotesDatabase.instance.createNote(
        note: note,
      );
    }

    Navigator.of(navigatorKey.currentContext!).pop();
  }
}
