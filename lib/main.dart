import 'package:flutter/material.dart';

import 'os_activity_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<ActivityResults>? _fetchActivityFuture;

  @override
  void initState() {
    super.initState();

    _fetchActivityFuture = runExperiment();
    // ignore: avoid_print
    _fetchActivityFuture!.then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<ActivityResults>(
          future: _fetchActivityFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ID1: ${snapshot.data!.parentCreatedActivityId}"),
                  Text("ID2: ${snapshot.data!.childCreatedActivityId}"),
                  Text("Get Request 1: ${snapshot.data!.firstGetResults}"),
                  Text("Get Request 2: ${snapshot.data!.secondGetResults}"),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
