import 'package:chat_app/widgets/chat_input.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  final String username;
  const ChatPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Hi Vedat!"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: "Hello, this is vedat!",
                    alignment: index % 2 == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                  );
                }),
          ),
          ChatInput(),
        ],
      ),
    );
  }
}
