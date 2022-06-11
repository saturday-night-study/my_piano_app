import 'package:my_xylophone_app/record/note.dart';

class Notes {
  Notes({
    required this.startAt,
  });

  final DateTime startAt;
  late final DateTime endAt;
  final List<Note> _notes = [];

  void addNote(Note note) {
    _notes.add(note);
  }

  int _index = 0;
  bool get hasNext => _notes.length > _index;
  Note? get next => hasNext ? _notes[_index++] : null;
  void reset() => _index = 0;

  Duration calculatePlayAt(Note note) => note.recordAt.difference(startAt);

  void recordStop() => endAt = DateTime.now();
  int get playTime => endAt.difference(startAt).inSeconds;
}
