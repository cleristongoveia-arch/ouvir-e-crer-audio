import 'package:speech_to_text/speech_to_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

SpeechToText speech = SpeechToText();

void startListening() async {
  bool available = await speech.initialize();
  if (available) {
    speech.listen(onResult: (result) {
      if (result.finalResult) {
        final now = DateTime.now();
        final time = "${now.hour}:${now.minute}";

        FirebaseFirestore.instance.collection('tasks').add({
          'text': "$time - ${result.recognizedWords}",
          'type': 'voice',
          'done': false,
          'createdAt': now,
        });
      }
    });
  }
}
