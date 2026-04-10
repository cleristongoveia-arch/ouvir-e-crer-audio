import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'speech_service.dart';

class TaskList extends StatelessWidget {
  final String type;
  TaskList({required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(type == 'text' ? "Digitadas" : "Voz"),

        if (type == 'text')
          TextField(
            onSubmitted: (value) => addTask(value),
          ),

        if (type == 'voice')
          ElevatedButton(
            onPressed: startListening,
            child: Text("Falar"),
          ),

        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('type', isEqualTo: type)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              var docs = snapshot.data!.docs;

              return ListView(
                children: docs.map((doc) {
                  var task = doc;

                  Color color = type == 'voice'
                      ? (task['done'] ? Colors.green : Colors.red)
                      : (task['done'] ? Colors.grey : Colors.white);

                  return ExpansionTile(
                    title: Text(task['text'], style: TextStyle(color: color)),
                    trailing: Checkbox(
                      value: task['done'],
                      onChanged: (_) {
                        FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(task.id)
                            .update({'done': !task['done']});
                      },
                    ),
                    children: buildSubtasks(task),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> buildSubtasks(task) {
    if (!task.data().containsKey('subtasks')) return [];

    List subtasks = task['subtasks'];

    return subtasks.map<Widget>((sub) {
      return ListTile(
        title: Text(sub['title']),
      );
    }).toList();
  }

  void addTask(String text) {
    final now = DateTime.now();
    final time = "${now.hour}:${now.minute}";

    FirebaseFirestore.instance.collection('tasks').add({
      'text': "$time - $text",
      'type': type,
      'done': false,
      'subtasks': [],
      'createdAt': now,
    });
  }
}
