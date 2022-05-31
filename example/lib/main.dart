import 'package:flutter/material.dart';
import 'package:flutter_fractal/flutter_fractal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Romantic Developer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Romantic Developer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FittedBox(
                    child: Text(
                      '$RainbowCircleToyLoadingIndicator',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = !isLoading;
                      });
                    },
                    child: Text(
                      isLoading ? 'Done loading' : 'Load',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            RainbowCircleToyLoadingIndicator(
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
