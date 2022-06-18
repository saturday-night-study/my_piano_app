import 'package:my_xylophone_app/record/notes.dart';

class Record {
  final String title;
  final Notes notes;
  final DateTime saveAt;

  Record({
    required this.title,
    required this.notes,
    required this.saveAt,
  });
}
