import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_xylophone_app/datetime_extension.dart';
import 'package:my_xylophone_app/int_extension.dart';
import 'package:my_xylophone_app/orientation_util.dart';
import 'package:my_xylophone_app/record/notes.dart';
import 'package:my_xylophone_app/record/record.dart';
import 'package:my_xylophone_app/record/recorder.dart';
import 'package:my_xylophone_app/record/recorder_delegate.dart';
import 'package:my_xylophone_app/record/recorder_state.dart';
import 'package:my_xylophone_app/repository/record_repository.dart';
import 'package:my_xylophone_app/scale.dart';
import 'package:my_xylophone_app/xylophone_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements RecorderDelegate {
  Recorder? _recorder;
  RecorderState _state = RecorderState.playStop;
  int _playIndex = -1;
  String _playTime = 0.playTimeFormat;

  @override
  void initState() {
    super.initState();

    OrientationUtil.setPortrait();
  }

  void _goToXylophone(Notes? notes) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => XylophonePage(
                notes: notes,
              )),
    );

    setState(() {});
  }

  void _listItemDidSelect(int index) {
    final record = RecordRepository().get(index);
    if (record == null) {
      return;
    }

    _goToXylophone(record.notes);
  }

  void _togglePlay(int index) {
    if (_state.isPlaying) {
      _recorder?.playStop();
      return;
    }

    final record = RecordRepository().get(index);
    if (record == null) {
      return;
    }

    _playIndex = index;
    _recorder = Recorder(
      delegate: this,
      notes: record.notes,
    );
    _recorder?.playStart();
  }

  @override
  void play(Scale scale) {
    final player = AudioCache(prefix: "assets/sounds/");
    player.play("note${scale.index + 1}.wav");
  }

  @override
  void recorderStateDidChange(RecorderState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  void tick(int seconds) {
    setState(() {
      _playTime = seconds.playTimeFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Xylophone"),
        actions: [
          _createXylophoneButton(),
        ],
      ),
      body: ListView.separated(
          itemCount: RecordRepository().count,
          itemBuilder: (BuildContext context, int index) {
            return _createListItem(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 1,
              thickness: 1,
            );
          }),
    );
  }

  Widget _createXylophoneButton() {
    return MaterialButton(
      onPressed: () => _goToXylophone(null),
      padding: EdgeInsets.zero,
      minWidth: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Image.asset(
          "assets/images/xylophone.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _createListItem(int index) {
    final record = RecordRepository().get(index);
    if (record == null) {
      return const SizedBox.shrink();
    }

    final playTime = index == _playIndex && _state.isPlaying
        ? _playTime
        : record.notes.playTime.playTimeFormat;

    return GestureDetector(
      onTap: () => _listItemDidSelect(index),
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  record.saveAt.saveDatetimeFormat,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _createControl(index),
                const SizedBox(height: 5),
                Text(
                  playTime,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createControl(int index) {
    final iconName = index == _playIndex && _state.isPlaying ? "stop" : "play";

    return MaterialButton(
      onPressed: () => _togglePlay(index),
      padding: EdgeInsets.zero,
      minWidth: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Image.asset(
        "assets/images/$iconName.png",
        width: 30,
        height: 30,
      ),
    );
  }
}
