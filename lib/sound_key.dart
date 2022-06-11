import 'package:flutter/material.dart';
import 'package:my_xylophone_app/scale.dart';
import 'package:my_xylophone_app/scales.dart';

typedef SoundKeyPressed = Function(Scale);

class SoundKey extends StatefulWidget {
  const SoundKey({
    Key? key,
    required this.scale,
    required this.onTap,
    required this.pressed,
  }) : super(key: key);

  final Scale scale;
  final SoundKeyPressed onTap;
  final bool pressed;

  @override
  State<SoundKey> createState() => _SoundKeyState();
}

class _SoundKeyState extends State<SoundKey> {
  late bool _pressed;
  Color get _keyColor =>
      _pressed ? widget.scale.pressedColor : widget.scale.color;

  @override
  void initState() {
    super.initState();

    _pressed = widget.pressed;
  }

  @override
  void didUpdateWidget(SoundKey oldWidget) {
    super.didUpdateWidget(oldWidget);

    _pressed = widget.pressed;
  }

  void _handleTap() {
    widget.onTap(widget.scale);
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _pressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        child: Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10 + (widget.scale.index * 10)),
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: _keyColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(widget.scale.scale),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
