import 'dart:convert';
import 'package:http/http.dart' as http;

class CohereService {
  final String _apiKey = 'I80exZcS3vgHS7vjKdLJkDaZJf4iys1OsiSrxXeM'; // Replace this with your actual API key

  Future<String> getCareerAdvice(String input) async {
    final url = Uri.parse('https://api.cohere.ai/v1/chat');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "message": input,
        "model": "command-r-plus",
        "chat_history": [],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['text'] ?? 'No response from CareerGPT.';
    } else {
      return 'Error: ${response.body}';
    }
  }
}
