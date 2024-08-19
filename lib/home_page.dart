import 'package:flutter/material.dart';
import 'second_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = "Welcome!"});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _start() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SecPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/Earth.png',
                fit: BoxFit.fitWidth, width: 300),
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'Here can recognize landmark pictures',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 156, 63, 228),
                    Color.fromARGB(255, 198, 86, 71)
                  ]),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                margin: const EdgeInsets.only(top: 25),
                child: ElevatedButton(
                  onPressed: () {
                    _start();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
