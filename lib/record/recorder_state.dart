enum RecorderState {
  recordStart,
  recordStop,
  playStart,
  playStop;

  bool get isStarted => this == recordStart || this == playStart;
  bool get isRecording => this == RecorderState.recordStart;
  bool get isPlaying => this == RecorderState.playStart;
  bool get isRecordStop => this == RecorderState.recordStop;
  bool get isPlayStop => this == RecorderState.playStop;
  bool get isStopped => isRecordStop || isPlayStop;
}
