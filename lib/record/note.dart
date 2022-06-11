import 'package:my_xylophone_app/scale.dart';

class Note {
  final Scale scale;
  final DateTime recordAt;

  const Note({
    required this.scale,
    required this.recordAt,
  });
}
