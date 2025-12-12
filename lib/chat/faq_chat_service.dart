import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';

/// Simple wrapper that feeds the FAQ document to a Gemini model.
class FaqChatService {
  FaqChatService({
    required String apiKey,
    this.model = 'gemini-2.5-flash',
  }) : _model = GenerativeModel(
          model: model,
          apiKey: apiKey,
        );

  final String model;
  final GenerativeModel _model;
  String? _cachedFaq;

  Future<void> _ensureFaqLoaded() async {
    _cachedFaq ??= await rootBundle.loadString('assets/faq.md');
  }

  Future<String> ask(String question) async {
    if (question.trim().isEmpty) {
      return 'Ask a question about the cashier app.';
    }

    await _ensureFaqLoaded();

    final response = await _model.generateContent(
      [
        Content.text(
          '''
You are the cashier app FAQ assistant. Answer strictly based on the FAQ below.
If the answer is not in the FAQ, say you are unsure.

FAQ:
$_cachedFaq

Question: $question
''',
        ),
      ],
    );

    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      return 'Sorry, I could not find an answer in the FAQ.';
    }
    return text;
  }
}
