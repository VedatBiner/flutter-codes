import 'package:chat_app/models/chat_message_entity.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity entity;
  final Alignment alignment;
  const ChatBubble({
    super.key,
    required this.entity,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    bool isAuthor = entity.author.userName == "Vedat";
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isAuthor ? Theme.of(context).primaryColor : Colors.black87,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entity.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            if (entity.imageUrl != null)
              Column(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(entity.imageUrl!),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
