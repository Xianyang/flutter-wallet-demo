import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Test adding pass'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 100),
                child: IconButton(
                  icon: Image.asset('assets/add_to_apple_wallet.png'),
                  iconSize: 200,
                  onPressed: () {
                    _addPass();
                  },
                ))
          ],
        ),
      ),
    );
  }

  _addPass() {
    _calliOSToAddPass();
  }

  static const platform = const MethodChannel('com.jumpstart.hkard/pass');

  Future<void> _calliOSToAddPass() async {
    try {
      final int result = await platform.invokeMethod('createPassWithURL', {
        'passURL':
            'https://pass-demo-bucket.s3.us-east-2.amazonaws.com/Generic.pkpass'
      });
      print('Result: $result');
    } on PlatformException catch (e) {
      print("Failed: '${e.message}'.");
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  // }
}

// class HttpClient {}
