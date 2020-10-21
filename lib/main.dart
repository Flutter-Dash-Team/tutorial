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
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            CustomPaint(
              size: size,
              painter: HolePainter(
                dx: left + 30,
                dy: top + 30,
                radius: width,
              ),
            ),
            Center(
              child: Text(
                "Oi eu sou a Duda cabecuda",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.ac_unit,
        ),
        actions: [CircleAvatar()],
      ),
      body: Container(
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.red,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _key,
        onPressed: () async {
          await capturePositionWidget();
          showOverlay(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  final double dx;
  final double dy;
  final double radius;
  final ShapeFocus shapeFocus;

  HolePainter({
    this.dx,
    this.dy,
    this.radius,
    this.shapeFocus = ShapeFocus.oval,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    if (shapeFocus == ShapeFocus.oval) {
      canvas.drawPath(
          Path.combine(
            PathOperation.difference,
            Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
            Path()
              ..addOval(
                  Rect.fromCircle(center: Offset(dx, dy), radius: radius - 30))
              ..close(),
          ),
          paint);
    } else {
      canvas.drawPath(
          Path.combine(
            PathOperation.difference,
            Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
            Path()
              ..addRect(
                  Rect.fromCircle(center: Offset(dx, dy), radius: radius - 30))
              ..close(),
          ),
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum ShapeFocus { oval, square }
