import 'package:flutter/material.dart';
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
