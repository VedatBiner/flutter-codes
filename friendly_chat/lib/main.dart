import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(
    MaterialApp(
      // cihaza göre tema seçimi
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      title: "FriendlyChat",
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
    ),
  );
}

// IOS ve Android için temalar
final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
);

final ThemeData kDefaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
    secondary: Colors.orangeAccent[400],
  ),
);

// text girip, enter basılınca siliyor.
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  // Chat listesi
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  // boş mesaj kontrolü
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
      _isComposing = false;
    });
    _focusNode.requestFocus();
    // animasyon hareketi
    message.animationController.forward();
  }

  // send message
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                onChanged: (String text) {
                  setState(() {
                    // boşluk kontrolü burada yapılıyor
                    _isComposing = text.isNotEmpty;
                  });
                },
                controller: _textController,
                onSubmitted: _isComposing ? _handleSubmitted : null,
                focusNode: _focusNode,
                decoration: const InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            // cihaza göre buton görünümü de değişsin
            Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoButton(
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,
                    child: const Text("Send"),
                  )
                : IconButton(
                    // boşluk kontrolü burada da yapılıyor
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,
                    icon: const Icon(Icons.send),
                  ),
          ],
        ),
      ),
    );
  }

  // animasyonu bellekten atıyoruz
  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FriendlyChat"),
        // appbar gölgelendirmek için
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 8.0,
      ),
      body: Container(
        decoration: Theme.of(context).platform == TargetPlatform.iOS
        ? BoxDecoration(
          border: Border(
            top: BorderSide(color: (Colors.grey[200])!,),
          )
        )
        : null,
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            const Divider(
              height: 1,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}

String _name = "Your Name";

class ChatMessage extends StatelessWidget {
  ChatMessage({
    super.key,
    required this.text,
    required this.animationController,
  });
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(text),
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
