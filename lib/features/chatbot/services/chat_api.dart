import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApi {
  static const String baseUrl = "https://adhamadel2001-chatbot-api.hf.space/chat/";

  static Future<String> sendMessage(String question) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": question}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["response"] ?? "No response from chatbot.";
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
