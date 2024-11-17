import 'package:flutter/material.dart';
import 'package:temanternak/views/pages/chat_page.dart';

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
            child: ListView.separated(
              itemCount: 15,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/images/logo.png'),
                  ),
                  title: const Text(
                    'User Name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Message',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Text('Time'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatPage(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
