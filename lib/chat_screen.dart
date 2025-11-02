import 'package:flutter/material.dart';
import 'main_scaffold.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isMe, required this.timestamp});
}

class ChatScreen extends StatefulWidget {
  final String sellerName;
  final String itemName;
  final String itemImage;

  const ChatScreen({
    Key? key,
    required this.sellerName,
    required this.itemName,
    required this.itemImage,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final Color darkGreen = const Color(0xFF0F6B32);
  final Color lightGreen = const Color(0xFF68B092);

  @override
  void initState() {
    super.initState();
    // Add initial greeting message from seller
    _messages.add(
      ChatMessage(
        text: "Hi there! I'm interested in selling my ${widget.itemName}. Let me know if you have any questions!",
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    // Simulate a response after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      // Simple auto-response logic
      String response = "";
      String lowerCaseMessage = _messageController.text.toLowerCase();
      
      if (lowerCaseMessage.contains("price") || lowerCaseMessage.contains("how much")) {
        response = "I'm asking \$120 for this ${widget.itemName}, but I'm open to reasonable offers.";
      } else if (lowerCaseMessage.contains("condition") || lowerCaseMessage.contains("working")) {
        response = "The ${widget.itemName} is in good working condition. It has some minor scratches but functions perfectly.";
      } else if (lowerCaseMessage.contains("meet") || lowerCaseMessage.contains("pickup")) {
        response = "I'm available to meet at a public place downtown or at the local mall. When works for you?";
      } else if (lowerCaseMessage.contains("negotiate") || lowerCaseMessage.contains("lower") || lowerCaseMessage.contains("discount")) {
        response = "I could go down to \$100 if you can pick it up this week.";
      } else {
        response = "Thanks for your message! Do you have any other questions about the ${widget.itemName}?";
      }
      
      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2, // Marketplace index
      title: widget.sellerName,
      body: Column(
        children: [
          // Item info card
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.itemImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Negotiating with ${widget.sellerName}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              reverse: true, // Start from bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: darkGreen),
                  onPressed: () {
                    // Attachment functionality
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: darkGreen),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) 
            CircleAvatar(
              backgroundColor: lightGreen,
              child: Text(
                widget.sellerName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? darkGreen : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: message.isMe ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (message.isMe)
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                "ME",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}