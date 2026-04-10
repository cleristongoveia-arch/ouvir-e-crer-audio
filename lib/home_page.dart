import 'package:flutter/material.dart';
import 'stopwatch_widget.dart';
import 'task_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ouvir & Crer Áudio")),
      body: Column(
        children: [
          StopwatchWidget(),
          Expanded(
            child: Column(
              children: [
                Expanded(child: TaskList(type: 'text')),
                Divider(),
                Expanded(child: TaskList(type: 'voice')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
