import 'package:flutter/material.dart';
import 'package:hyperlocal_shared/models/message_model.dart';
import 'package:hyperlocal_shared/ui/components/loading_indicator.dart';
import 'package:hyperlocal_shared/ui/components/error_empty_state.dart';

/// Layar chat — scaffold awal, implementasi penuh di Sprint 8.
class ChatScreen extends StatefulWidget {
  final String orderId;
  final String currentUserId;
  final String currentUserRole;

  const ChatScreen({
    super.key,
    required this.orderId,
    required this.currentUserId,
    required this.currentUserRole,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<MessageModel> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    // TODO(sprint-8): GET /api/v1/chat/{order_id}/messages
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Memuat pesan...');
    }
    if (_messages.isEmpty) {
      return const ErrorEmptyState(
        icon: Icons.chat_bubble_outline,
        message: 'Belum ada pesan. Kirim pesan pertama ke mitra kamu!',
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) => _buildBubble(_messages[index]),
          ),
        ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildBubble(MessageModel msg) {
    final isMine = msg.senderId == widget.currentUserId;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFF2E7D32) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.content ?? '',
          style: TextStyle(
              color: isMine ? Colors.white : Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // TODO(sprint-8): POST /api/v1/chat/upload
              },
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Tulis pesan...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF2E7D32)),
              onPressed: () {
                // TODO(sprint-8): WebSocket wss://.../v1/ws/chat/{order_id}
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
