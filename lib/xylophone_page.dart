import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_xylophone_app/orientation_util.dart';
import 'package:my_xylophone_app/record/recorder.dart';
import 'package:my_xylophone_app/record/recorder_delegate.dart';
import 'package:my_xylophone_app/record/recorder_state.dart';
import 'package:my_xylophone_app/scale.dart';
import 'package:my_xylophone_app/scales.dart';
import 'package:my_xylophone_app/sound_key.dart';

class XylophonePage extends StatefulWidget {
  const XylophonePage({Key? key}) : super(key: key);

  @override
  State<XylophonePage> createState() => _XylophonePageState();
}

class _XylophonePageState extends State<XylophonePage>
    implements RecorderDelegate {
  String _playTime = "00:00";

  String get _playIconName => _recorder.isPlaying ? "stop" : "play";
  String get _recordIconName =>
      _recorder.isRecording ? "record_on" : "record_off";

  late final Recorder _recorder;
  Scale? _currentPlayScale;

  @override
  void initState() {
    super.initState();

    OrientationUtil.setLandscape();

    _recorder = Recorder(delegate: this);
  }

  @override
  void dispose() {
    super.dispose();

    _recorder.dispose();

    OrientationUtil.setPortrait();
  }

  void _handleTap(Scale scale) {
    _recorder.tryRecord(scale);
    _playSound(scale);
  }

  void _playSound(Scale scale) {
    final player = AudioCache(prefix: "assets/sounds/");
    player.play("note${scale.index + 1}.wav");
  }

  void _toggleControl() {
    _recorder.isPlayable ? _recorder.playStart() : _recorder.playStop();
  }

  void _toggleRecording() {
    _recorder.isRecording ? _recorder.recordStop() : _recorder.recordStart();
  }

  @override
  void recorderStateDidChange(RecorderState state) {
    if (!mounted) {
      return;
    }

    setState(() {
      if (state.isPlayStop) {
        _currentPlayScale = null;
      }
    });
  }

  @override
  void tick(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;

    setState(() {
      _playTime =
          "${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}";
    });
  }

  @override
  void play(Scale scale) {
    setState(() {
      _currentPlayScale = scale;
    });

    _playSound(scale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_playTime),
        actions: [
          _createControl(),
          _createRecord(),
        ],
      ),
      body: Container(
        color: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _createSoundKeys(),
        ),
      ),
    );
  }

  List<Widget> _createSoundKeys() {
    return scales
        .map(
          (s) => SoundKey(
            scale: s,
            onTap: _handleTap,
            pressed: s.scale == _currentPlayScale?.scale,
          ),
        )
        .toList();
  }

  Widget _createControl() {
    return MaterialButton(
      onPressed: _toggleControl,
      padding: EdgeInsets.zero,
      minWidth: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Image.asset(
        "assets/images/$_playIconName.png",
        width: 30,
        height: 30,
      ),
    );
  }

  Widget _createRecord() {
    return MaterialButton(
      onPressed: _toggleRecording,
      padding: EdgeInsets.zero,
      minWidth: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Image.asset(
          "assets/images/$_recordIconName.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
