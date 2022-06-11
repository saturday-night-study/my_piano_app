import 'package:my_xylophone_app/record/recorder_state.dart';
import 'package:my_xylophone_app/scale.dart';

abstract class RecorderDelegate {
  void recorderStateDidChange(RecorderState state);

  void tick(int seconds);

  void play(Scale scale);
}
