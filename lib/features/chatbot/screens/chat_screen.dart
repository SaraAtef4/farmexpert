import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/chat_api.dart';
import 'chat_splash_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: "Welcome to FarmXpert Bot! How can I assist you with your farm today?",
      isUser: false,
      timestamp: DateTime.now(),
      reactions: [],
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
        reactions: [],
      ));
      _isTyping = true;
    });

    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    String botResponse = await ChatApi.sendMessage(text);

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: botResponse,
        isUser: false,
        timestamp: DateTime.now(),
        reactions: [],
      ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _addReaction(int index, String emoji) {
    setState(() {
      _messages[index].reactions.add(emoji);
    });
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatBotSplashScreen()),
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/images/splash_cow.png"),
            ),
            SizedBox(width: 20),
            Text(
              'FarmXpert Bot',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.green.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return TypingIndicator();
                  }
                  final message = _messages[index];
                  return ChatBubble(
                    message: message,
                    index: index,
                    onReaction: (emoji) => _addReaction(index, emoji),
                    onCopy: () => _copyMessage(message.text),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.green.shade700,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.green.shade700,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.green.shade900,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () => _sendMessage(_controller.text),
                    backgroundColor: Colors.green.shade700,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> reactions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.reactions,
  });
}

class ChatBubble extends StatefulWidget {
  final ChatMessage message;
  final int index;
  final Function(String) onReaction;
  final VoidCallback onCopy;

  const ChatBubble({super.key,
    required this.message,
    required this.index,
    required this.onReaction,
    required this.onCopy,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.message.isUser ? Offset(1, 0) : Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showReactionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Text('👍', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  widget.onReaction('👍');
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Text('❤', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  widget.onReaction('❤');
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Text('🐄', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  widget.onReaction('🐄');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.copy),
                      title: Text('Copy'),
                      onTap: () {
                        widget.onCopy();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add_reaction),
                      title: Text('Add Reaction'),
                      onTap: () {
                        Navigator.pop(context);
                        _showReactionMenu(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: widget.message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.message.isUser) ...[
                // Bot avatar
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green.shade700,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/bot_avatar.png"),
                    ),
                  ),
                ),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: widget.message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.message.isUser ? Colors.green.shade200 : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: widget.message.isUser
                            ? null
                            : Border.all(
                          color: Colors.green.shade700,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: widget.message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.message.text,
                            style: TextStyle(
                              color: widget.message.isUser ? Colors.green.shade900 : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${widget.message.timestamp.hour}:${widget.message.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.message.reactions.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: widget.message.reactions
                            .map((reaction) => Text(
                          reaction,
                          style: TextStyle(fontSize: 16),
                        ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.message.isUser) ...[
                // User avatar
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green.shade700,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/user_avatar.png"),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Bot avatar
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.shade700,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/bot_avatar.png"),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.shade700,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DotAnimation(),
          ),
        ],
      ),
    );
  }
}

class DotAnimation extends StatefulWidget {
  const DotAnimation({super.key});

  @override
  _DotAnimationState createState() => _DotAnimationState();
}

class _DotAnimationState extends State<DotAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dot(opacity: (_controller.value * 3).clamp(0, 1)),
        SizedBox(width: 4),
        Dot(opacity: ((_controller.value * 3) - 1).clamp(0, 1)),
        SizedBox(width: 4),
        Dot(opacity: ((_controller.value * 3) - 2).clamp(0, 1)),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  final double opacity;

  const Dot({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.3, 1.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
