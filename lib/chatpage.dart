import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Chatapp extends StatefulWidget {
  const Chatapp({Key? key}) : super(key: key);

  @override
  State<Chatapp> createState() => _ChatappState();
}

class _ChatappState extends State<Chatapp> {
  TextEditingController input_message = TextEditingController();
  static const api = 'AIzaSyDSIKtVnL6mSoaL8KAobP0k6xpwB4x5xag';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: api);
  final List<Message> _messages = [];

  Future<void> Send_message() async {
    final message = input_message.text;
    input_message.clear();

    setState(() {
      _messages
          .add(Message(user: true, message: message, date: DateTime.now()));
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          user: false,
          message: response.text ?? "Some Error Occur Please Try Again",
          date: DateTime.now().toLocal()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Chatbot AI",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87),
      body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
            child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  // final hour = message.date.hour;
                  // final minute = message.date.minute;
                  // final String time = hour.toString() + minute.toString();
                  return Messages(
                      isuser: message.user,
                      message: message.message,
                      date: message.date.hour.toString() +
                          ":" +
                          message.date.minute.toString());
                })),
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 10, right: 0),
          child: Row(
            children: [
              Expanded(
                flex: 15,
                child: TextFormField(
                  controller: input_message,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: "Enter Your Text"),
                ),
              ),
              Spacer(),
              IconButton(
                  padding: EdgeInsets.all(15),
                  iconSize: 30,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(CircleBorder()),
                  ),
                  onPressed: () {
                    Send_message();
                  },
                  icon: Icon(Icons.send_rounded)),
            ],
          ),
        )
      ]),
    );
  }
}

class Messages extends StatelessWidget {
  final bool isuser;
  final String message;
  final String date;
  const Messages(
      {Key? key,
      required this.isuser,
      required this.message,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.0),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isuser ? 100 : 10,
        right: isuser ? 10 : 100,
      ),
      decoration: BoxDecoration(
          color: isuser ? Color.fromARGB(255, 9, 48, 79) : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: isuser ? Radius.circular(10) : Radius.zero,
            topRight: Radius.circular(10.0),
            bottomRight: isuser ? Radius.zero : Radius.circular(10.0),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isuser ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(
                fontSize: 12, color: isuser ? Colors.white : Colors.black),
          )
        ],
      ),
    );
  }
}

class Message {
  final bool user;
  final String message;
  final DateTime date;

  Message({required this.user, required this.message, required this.date});
}
