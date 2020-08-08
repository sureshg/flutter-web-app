import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:lottie/lottie.dart';

import 'stub/ui.dart' if (dart.library.html) 'dart:ui' as ui;

final log = Logger('FlutterWebApp');

void main() {
  initLog();
  ui.platformViewRegistry.registerViewFactory(
      'youtube-flutter',
      (int viewId) => IFrameElement()
        ..width = '560'
        ..height = '315'
        ..src = 'https://www.youtube.com/embed/4AoFA19gbLo'
        ..allow =
            'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture'
        ..allowFullscreen = true
        ..style.border = 'none');

  runApp(MyApp());
}

void initLog() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) {
    print('${r.level.name}: ${r.time}: ${r.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log.info('Initializing the application');
    return MaterialApp(
      title: 'Flutter Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'App Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    log.info('Incrementing the count $_counter');
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
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 400,
                width: 400,
                child: LottieBuilder.network(
                    'https://assets2.lottiefiles.com/datafiles/U1I3rWEyksM9cCH/data.json'),
              ),
              SelectableText(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: HtmlElementView(viewType: 'youtube-flutter'),
                ),
              ),
              InkWell(
                child: Icon(Icons.content_copy),
                onTap: () async {
                  await Clipboard.setData(
                          ClipboardData(text: 'The count is $_counter'))
                      .then((_) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('The count is $_counter')));
                  });
                },
              )
            ],
          ),
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
