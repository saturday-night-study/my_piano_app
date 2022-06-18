import 'package:flutter/material.dart';

class RecordSaveDialog {
  RecordSaveDialog({
    required this.context,
    required this.onSave,
  });

  final BuildContext context;
  final Function(String) onSave;
  final _textFieldController = TextEditingController();

  Future<void> show() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 8),
          contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 4),
          titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 10),
          title: const Text(
            "연주를 저장할까요?",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: "곡명을 입력해주세요.",
              hintStyle: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          actions: _createButtons(),
        );
      },
    );
  }

  List<Widget> _createButtons() {
    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
        ),
        child: const Text(
          "취소",
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
        ),
        child: const Text(
          "저장",
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        onPressed: () {
          onSave(_textFieldController.text);
          Navigator.pop(context);
        },
      ),
    ];
  }
}
