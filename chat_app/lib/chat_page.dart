import 'package:flutter/material.dart';

import '../widgets/chat_input.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Hi $username"),
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
