import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  String time = "00:00:00";

  void start() {
    stopwatch.start();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      final e = stopwatch.elapsed;
      setState(() {
        time =
            "${e.inHours.toString().padLeft(2, '0')}:"
            "${(e.inMinutes % 60).toString().padLeft(2, '0')}:"
            "${(e.inSeconds % 60).toString().padLeft(2, '0')}";
      });
    });
  }

  void pause() {
    stopwatch.stop();
    timer?.cancel();
  }

  void reset() {
    stopwatch.reset();
    setState(() => time = "00:00:00");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(time, style: TextStyle(fontSize: 30)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: Icon(Icons.play_arrow), onPressed: start),
            IconButton(icon: Icon(Icons.pause), onPressed: pause),
            IconButton(icon: Icon(Icons.refresh), onPressed: reset),
          ],
        )
      ],
    );
  }
}
