import 'package:flutter/material.dart';
import '../ai/ai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  final AiService? aiService;

  const ChatScreen({super.key, this.aiService});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final AiService _aiService;
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _aiService = widget.aiService ?? AiService();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final question = _controller.text.trim();
    if (question.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: question, isUser: true));
      _isLoading = true;
      _controller.clear();
    });

    try {
      final response = await _aiService.ask(question);
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      if (!mounted) return;
      _showFallbackDialog();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showFallbackDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Layanan AI Sibuk'),
        content: const Text(
          'Coba lagi nanti atau gunakan mode catatan offline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _showApiKeyDialog() async {
    final keyController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atur API Key Gemini'),
        content: TextField(
          controller: keyController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Masukkan API Key...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _aiService.saveApiKey(keyController.text);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Notes Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.key),
            tooltip: 'Atur API Key',
            onPressed: _showApiKeyDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text('Tanyakan ringkasan atau ide catatan Anda!'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (_, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg.text),
                        ),
                      );
                    },
                  ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tulis pertanyaan (hindari data sensitif)...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}