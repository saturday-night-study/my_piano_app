import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_xylophone_app/orientation_util.dart';
import 'package:my_xylophone_app/scale.dart';
import 'package:my_xylophone_app/scales.dart';
import 'package:my_xylophone_app/sound_key.dart';

class XylophonePage extends StatefulWidget {
  const XylophonePage({Key? key}) : super(key: key);

  @override
  State<XylophonePage> createState() => _XylophonePageState();
}

class _XylophonePageState extends State<XylophonePage> {
  bool _inPlaying = false;
  bool _inRecording = false;

  Timer? _timer;
  String _playTime = "00:00";

  String get _playIconName => _inPlaying ? "stop" : "play";
  String get _recordIconName => _inRecording ? "record_on" : "record_off";

  @override
  void initState() {
    super.initState();

    OrientationUtil.setLandscape();
  }

  @override
  void dispose() {
    super.dispose();

    _stopRecording();

    OrientationUtil.setPortrait();
  }

  void _handleTap(Scale scale) {
    final player = AudioCache(prefix: "assets/sounds/");
    player.play("note${scale.index + 1}.wav");
  }

  void _toggleControl() {
    setState(() {
      _inPlaying = !_inPlaying;
    });
  }

  void _toggleRecording() {
    setState(() {
      _inRecording = !_inRecording;
    });

    _inRecording ? _startRecording() : _stopRecording();
  }

  void _startRecording() {
    setState(() {
      _playTime = "00:00";
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final seconds = timer.tick;
      final m = seconds ~/ 60;
      final s = seconds % 60;

      setState(() {
        _playTime =
            "${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}";
      });
    });
  }

  void _stopRecording() {
    _timer?.cancel();
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
          (e) => SoundKey(
            scale: e,
            onTap: _handleTap,
            pressed: false,
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
