import 'package:flutter/material.dart';
import 'helper.dart';
import 'insert_image.dart';

class SecPage extends StatefulWidget {
  const SecPage({super.key, this.title = "Sec Page"});
  final String title;

  @override
  State<SecPage> createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const InsertImage(),
    const HelperChatPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Q&A',
          ),
        ],
      ),
    );
  }
}
