import 'package:cashier_app/chat/faq_chat_service.dart';
import 'package:flutter/material.dart';

const String _defaultGeminiKey = String.fromEnvironment('GEMINI_API_KEY');

class FaqChatPage extends StatefulWidget {
  const FaqChatPage({super.key, this.apiKey});

  final String? apiKey;

  @override
  State<FaqChatPage> createState() => _FaqChatPageState();
}

class _FaqChatPageState extends State<FaqChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = <_ChatMessage>[];
  bool _isSending = false;
  String? _setupError;
  FaqChatService? _service;

  @override
  void initState() {
    super.initState();
    final apiKey = (widget.apiKey ?? _defaultGeminiKey).trim();
    if (apiKey.isEmpty) {
      _setupError =
          'Missing Gemini API key. Rebuild with --dart-define=GEMINI_API_KEY=YOUR_KEY.';
    } else {
      _service = FaqChatService(apiKey: apiKey);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final question = _controller.text.trim();
    if (_service == null || question.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(text: question, fromUser: true));
      _isSending = true;
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final answer = await _service!.ask(question);
      setState(() {
        _messages.add(_ChatMessage(text: answer, fromUser: false));
      });
    } catch (error) {
      setState(() {
        _messages.add(
          _ChatMessage(
            text: 'Something went wrong: $error',
            fromUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ Chatbot'),
      ),
      body: _setupError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _setupError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final alignment = message.fromUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft;
                      final color = message.fromUser
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant;
                      final textColor = message.fromUser
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant;
                      return Align(
                        alignment: alignment,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(color: textColor, fontSize: 15),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _handleSend(),
                          decoration: const InputDecoration(
                            hintText: 'Ask about the cashier app...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: _isSending
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send),
                        onPressed: _isSending ? null : _handleSend,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({required this.text, required this.fromUser});

  final String text;
  final bool fromUser;
}
