import 'package:flutter/material.dart';

import 'log_db_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    LogDatabaseModel dog = LogDatabaseModel(
      id: 1,
      moduleName: "moduleName",
      type: "type",
      message: "message",
      time: "time",
    );
    LogDatabaseModel dog2 = LogDatabaseModel(
      id: 2,
      moduleName: "moduleName2",
      type: "type2",
      message: "message2",
      time: "time2",
    );

    LogDatabase logDatabase = LogDatabase();
    await logDatabase.initDatabase();
    await logDatabase.insertLog(dog);
    await logDatabase.insertLog(dog2);
    List<LogDatabaseModel> dogList = await logDatabase.selectAll();
    for (int i = 0; i < dogList.length; i++) {
      print("id = ${dogList[i].id}, type = ${dogList[i].type}, message = ${dogList[i].message}, moduleName = ${dogList[i].moduleName}, time = ${dogList[i].time}");
    }

    print ("count = ${await logDatabase.getCount()}");

    logDatabase.deleteAll();
    print ("count = ${await logDatabase.getCount()}");


    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
