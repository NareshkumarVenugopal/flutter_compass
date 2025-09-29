import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _getDirectionLabel(int degree){
    if (degree >= 350 || degree <= 10) return "N";
    if (degree > 10 && degree <= 80) return "NE";
    if (degree > 80 && degree <= 100) return "E";
    if (degree > 100 && degree <= 170) return "SE";
    if (degree > 170 && degree <= 190) return "S";
    if (degree > 190 && degree <= 260) return "SW";
    if (degree > 260 && degree <= 280) return "W";
    if (degree > 280 && degree < 350) return "NW";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: HSLColor.fromAHSL(1, 0, 0, 0.05).toColor(),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return Column(
            children: <Widget>[
              Expanded(child: _buildCompass()),
            ],
          );
        }),
      ),
    );
  }
  Widget _buildCompass() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // might need to account for padding on iphones
    //var padding = MediaQuery.of(context).padding;
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final direction = snapshot.data?.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );

        int ang = (direction.round());
        String dirLabel = _getDirectionLabel(ang);
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber
                ),
                child: Transform.rotate(
                  angle: ((direction ?? 0) * (math.pi / 180) * -1),
                  child: Image.asset('assets/compass.png'),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$ang°",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dirLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                // center of the screen - half the width of the rectangle
                left: (width / 2) - ((width / 80) / 2),
                // height - width is the non compass vertical space, half of that
                top: (height - width) / 2,
                child: SizedBox(
                  width: width / 80,
                  height: width / 10,
                  child: Container(
                    //color: HSLColor.fromAHSL(0.85, 0, 0, 0.05).toColor(),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
