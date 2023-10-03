import 'package:chat_app/models/chat_message_entity.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_input.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final List<ChatMessageEntity> _messages = [
    ChatMessageEntity(
      author: Author(userName: "Vedat"),
      id: "1",
      text: "First text",
      createdAt: 12345678,
    ),
    ChatMessageEntity(
      author: Author(userName: "Zeynep"),
      id: "2",
      text: "Second text",
      createdAt: 12345678,
    ),
    ChatMessageEntity(
      author: Author(userName: "Nihan"),
      id: "3",
      text: "Third text",
      createdAt: 12345678,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Hi ${username ?? 'Guest'}"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/");
              print("Icon pressed ...");
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    entity: _messages[index],
                    alignment: _messages[index].author.userName == "Vedat"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                  );
                }),
          ),
          ChatInput(),
        ],
      ),
    );
  }
}
