import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/hive_storage_services.dart';

import 'models/ogrenci.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // bu fonksiyon hive i flutterda başlatır

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: MyHiveServices().encryptedBox, child: Icon(Icons.add)),
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('sayacınız: '),
              Text('$_counter'),
            ],
          ),
        ),
      ),
    );
  }
}
