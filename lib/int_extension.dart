extension IntExtention on int {
  String get playTimeFormat {
    final m = this ~/ 60;
    final s = this % 60;

    return "${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}";
  }
}
