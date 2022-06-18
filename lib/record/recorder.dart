import 'dart:async';

import 'package:my_xylophone_app/record/note.dart';
import 'package:my_xylophone_app/record/notes.dart';
import 'package:my_xylophone_app/record/recorder_delegate.dart';
import 'package:my_xylophone_app/record/recorder_state.dart';
import 'package:my_xylophone_app/scale.dart';

class Recorder {
  Recorder({
    required this.delegate,
  });

  final RecorderDelegate delegate;

  RecorderState _state = RecorderState.recordStop;
  RecorderState get state => _state;

  bool get isRecording => _state.isRecording;
  bool get isPlaying => _state.isPlaying;

  bool get isPlayable => _notes != null && _state.isStopped;
  bool get isNotPlayable => !isPlayable;

  Timer? _timer;
  Notes? _notes;

  void recordStart() {
    if (_state.isStarted) {
      return;
    }

    _timerStart();

    _notes = Notes(startAt: DateTime.now());

    _notifyTick(0);
    _notifyRecorderState(RecorderState.recordStart);
  }

  void recordStop() {
    _timerStop();

    _notes?.recordStop();

    _notifyRecorderState(RecorderState.recordStop);
  }

  void tryRecord(Scale scale) {
    if (!_state.isRecording) {
      return;
    }

    _notes?.addNote(Note(
      scale: scale,
      recordAt: DateTime.now(),
    ));
  }

  void playStart() {
    if (isNotPlayable) {
      return;
    }

    _timerStart();

    _notes?.reset();
    while (_notes!.hasNext) {
      final note = _notes!.next;
      if (note == null) {
        break;
      }

      _playSchedule(
        playAt: _notes!.calculatePlayAt(note),
        scale: note.scale,
      );
    }

    _notifyTick(0);
    _notifyRecorderState(RecorderState.playStart);
  }

  void playStop() {
    _timerStop();
    _playSchedulesStop();

    _notifyRecorderState(RecorderState.playStop);
  }

  void _playSchedule({
    required Duration playAt,
    required Scale scale,
  }) {
    _playSchedules.add(Timer(playAt, () {
      delegate.play(scale);
    }));
  }

  void _playSchedulesStop() {
    for (var timer in _playSchedules) {
      timer.cancel();
    }
    _playSchedules.clear();
  }

  final List<Timer> _playSchedules = [];

  void _timerStart() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _notifyTick(timer.tick);

      if (_state.isRecording) {
        return;
      }

      if (_notes == null) {
        return;
      }

      if (timer.tick >= _notes!.playTime) {
        playStop();
      }
    });
  }

  void _timerStop() {
    _timer?.cancel();
    _timer = null;
  }

  void _notifyRecorderState(RecorderState state) {
    _state = state;
    delegate.recorderStateDidChange(_state);
  }

  void _notifyTick(int seconds) {
    delegate.tick(seconds);
  }

  void dispose() {
    _timerStop();
    _playSchedulesStop();
  }
}
