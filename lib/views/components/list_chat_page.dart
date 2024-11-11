import 'package:flutter/material.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  ListChatPageState createState() => ListChatPageState();
}

class ListChatPageState extends State<ListChatPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 175,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 560,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Chat $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
