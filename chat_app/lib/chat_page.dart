import 'dart:convert';
import 'package:chat_app/models/image_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/chat_message_entity.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessageEntity> _messages = [];

  _loadInitialMessages() async {
    final response = await rootBundle.loadString("data/mock_messages.json");
    final List<dynamic> decodedList = jsonDecode(response) as List;
    final List<ChatMessageEntity> _chatMessages = decodedList.map((listItem) {
      return ChatMessageEntity.fromJson(listItem);
    }).toList();

    print(_chatMessages.length);
    setState(() {
      _messages = _chatMessages;
    });
  }

  onMessageSent(ChatMessageEntity entity) {
    _messages.add(entity);
    setState(() {});
  }

  Future<List<PixelfordImage>> _getNetworkImages() async {
    var endPointUrl = Uri.parse("https://pixelford.com/api2/images");

    /// Bu API sayfası artık yok.
    final response = await http.get(endPointUrl);
    if (response.statusCode == 200) {
      final List<dynamic> decodedList = jsonDecode(response.body) as List;
      final List<PixelfordImage> _imageList = decodedList.map((listItem) {
        return PixelfordImage.fromJson(listItem);
      }).toList();
      print(_imageList[0].urlFullsize);
      return _imageList;
    } else {
      throw Exception("API not successful");
    }
  }

  @override
  void initState() {
    _loadInitialMessages();
    _getNetworkImages();
    super.initState();
  }

  Widget build(BuildContext context) {
    _getNetworkImages();
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
          FutureBuilder<List<PixelfordImage>>(
              future: _getNetworkImages(),
              builder: (BuildContext context, AsyncSnapshot<List<PixelfordImage>> snapshot) {
                if (snapshot.hasData) return Image.network(snapshot.data![0].urlSmallSize);
                return const CircularProgressIndicator();
              }),
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
          ChatInput(onSubmit: onMessageSent),
        ],
      ),
    );
  }
}
