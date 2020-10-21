import 'package:flutter/material.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  var _key = GlobalKey();
  double width = 0;
  double height = 0;
  double left = 0;
  double top = 0;
  showOverlay(BuildContext context) async {
    var size = MediaQuery.of(context).size;
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            color: Colors.transparent,
          ),
          Positioned(
              top: top,
              left: left,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black)),
              )),
        ],
      );
    });
    OverlayEntry overlayEntry1 = OverlayEntry(builder: (context) {
      return Container(
        width: size.width,
        height: size.height,
        color: Colors.transparent,
      );
    });
    overlayState.insert(overlayEntry);
  }

  capturePositionWidget() {
    RenderBox renderPosition = _key.currentContext.findRenderObject();
    RenderBox renderSize = _key.currentContext.findRenderObject();

    var position = renderPosition.localToGlobal(Offset.zero);
    var size = renderSize.size;
    setState(() {
      width = size.width + 30;
      height = size.height + 30;
      top = position.dy;
      left = position.dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          key: _key,
          color: Colors.red,
          width: 200,
          height: 200,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await capturePositionWidget();
          showOverlay(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
