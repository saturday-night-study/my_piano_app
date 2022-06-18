import 'package:my_xylophone_app/record/notes.dart';
import 'package:my_xylophone_app/record/record.dart';

class RecordRepository {
  static final _instance = RecordRepository._internal();

  factory RecordRepository() {
    return _instance;
  }

  RecordRepository._internal();

  final List<Record> _records = [];

  int get count => _records.length;

  void add({
    required String title,
    required Notes notes,
  }) {
    _records.add(Record(
      title: title,
      notes: notes,
      saveAt: DateTime.now(),
    ));
  }

  Record? get(int index) {
    if (index >= count) {
      return null;
    }

    return _records[index];
  }
}
