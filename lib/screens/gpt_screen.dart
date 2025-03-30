import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/ai_service.dart';
import '../widgets/chat_bubble.dart';

class ChatGPTScreen extends StatefulWidget {
  @override
  _ChatGPTScreenState createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  void _askCareerGPT() async {
    final input = _controller.text;
    if (input.isEmpty) return;
    setState(() {
      _messages.add({"text": input, "isUser": true});
      _controller.clear();
    });
    final result = await CohereService().getCareerAdvice(input);
    setState(() => _messages.add({"text": result, "isUser": false}));
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      final file = result.files.first;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File Selected: ${file.name}')),
      );

      // If you want to upload to Firebase, add logic here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File selection canceled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CareerGPT Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                return ChatBubble(message: msg['text'], isUser: msg['isUser']);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.upload_file),
              label: Text("Upload File"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Ask a question..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _askCareerGPT,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
