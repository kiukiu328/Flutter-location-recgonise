import 'package:flutter/material.dart';
import 'package:dart_openai/openai.dart';

class HelperChatPage extends StatefulWidget {
  const HelperChatPage({super.key});

  @override
  _HelperChatPageState createState() => _HelperChatPageState();
}

class _HelperChatPageState extends State<HelperChatPage> {
  final _controller = TextEditingController();
  final List<ChatBox> _chatBoxes = [];
  final List<OpenAIChatCompletionChoiceMessageModel> conversation = [];
  OpenAIChatCompletionModel? chatCompletion;

  @override
  void initState() {
    super.initState();
    ChatBox.conversation = conversation;
  }

  void _getChatResponse(String text) async {
    if (text == "") return;
    setState(() {
      _chatBoxes.add(UserChatBox(text: text));
    });
    conversation.add(OpenAIChatCompletionChoiceMessageModel(
        content: text, role: OpenAIChatMessageRole.user));
    setState(() {
      _chatBoxes.add(AIChatBox(text: text));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
              text: "Helper",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '\nGTCO Chatbot',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
        ),
        leading: Image.asset('assets/images/Helper.png'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding:const EdgeInsets.all(16),
              itemCount: _chatBoxes.length,
              itemBuilder: (BuildContext context, int index) {
                return _chatBoxes[index];
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Type here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  _getChatResponse(_controller.text);
                  _controller.clear();
                },
                child: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class ChatBox extends StatefulWidget {
  final String text;
  static List<OpenAIChatCompletionChoiceMessageModel> conversation = [];
  late Alignment alignment;
  late BoxDecoration decoration;
  late TextStyle style;

  ChatBox({super.key, required this.text});

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    if (widget is AIChatBox) {
      return FutureBuilder<OpenAIChatCompletionModel>(
        future: OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo",
          messages: ChatBox.conversation,
        ),
        builder: (BuildContext context,
            AsyncSnapshot<OpenAIChatCompletionModel> snapshot) {
          Widget child;
          String text = "";
          if (snapshot.hasData) {
            text = snapshot.data!.choices.last.message.content;
            child = Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                text,
                style: widget.style,
              ),
            );
          } else if (snapshot.hasError) {
            text = "There was an error";
            child = Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                text,
                style: widget.style,
              ),
            );
          } else {
            child = Container(
                margin: EdgeInsets.all(20), child: CircularProgressIndicator());
          }
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            alignment: widget.alignment,
            child: Container(
                width: MediaQuery.of(context).size.width / 1.8,
                decoration: widget.decoration,
                alignment: widget.alignment,
                child: child),
          );
        },
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      alignment: widget.alignment,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.8,
        decoration: widget.decoration,
        alignment: widget.alignment,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            widget.text,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}

class UserChatBox extends ChatBox {
  UserChatBox({super.key, required super.text}) {
    alignment = Alignment.centerRight;
    decoration = BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.circular(10),
    );
    style = const TextStyle(color: Colors.white);
  }
}

class AIChatBox extends ChatBox {
  AIChatBox({super.key, required super.text}) {
    alignment = Alignment.centerLeft;
    decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange));
    style = const TextStyle(color: Colors.grey);
  }
}
