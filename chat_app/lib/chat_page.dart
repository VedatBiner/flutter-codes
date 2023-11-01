import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/chat_message_entity.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_bubble.dart';
import '../services/auth_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessageEntity> _messages = [];

  _loadInitialMessages() async {
    final response = await rootBundle.loadString("data/mock_messages.json");
    final List<dynamic> decodedList = jsonDecode(response) as List;
    final List<ChatMessageEntity> chatMessages = decodedList.map((listItem) {
      return ChatMessageEntity.fromJson(listItem);
    }).toList();

    print(chatMessages.length);
    setState(() {
      _messages = chatMessages;
    });
  }

  onMessageSent(ChatMessageEntity entity) {
    _messages.add(entity);
    setState(() {});
  }

  @override
  void initState() {
    _loadInitialMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthService>().getUserName();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Hi ${username ?? 'Guest'}"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthService>().updateUserName("newName!");
            },
            icon: const Icon(Icons.update),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthService>().logoutUser();
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
                    alignment: _messages[index].author.userName ==
                            context.read<AuthService>().getUserName()
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                  );
                }),
          ),
          ChatInput(onSubmit: onMessageSent),
        ],
      ),
    );
  }
}
