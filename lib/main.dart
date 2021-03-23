import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Flutter Sensör Uygulaması'),
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
  double _ax, _ay, _az;
  double _uax, _uay, _uaz;
  double _gx, _gy, _gz;

  void _incrementCounter() {
    setState(() {
      _counter+=5;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _ax = event.x;
        _ay = event.y;
        _az = event.z;
      });
    }); //get the sensor data and set then to the data types

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _uax = event.x;
        _uay = event.y;
        _uaz = event.z;
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gx = event.x;
        _gy = event.y;
        _gz = event.z;
      });
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
              'Accelerometer Events listen',
              style: Theme.of(context).textTheme.headline,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  _ax.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  _ay.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  _az.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
            SizedBox(height: 50,),
            Text(
              'User Accelerometer Events listen',
              style: Theme.of(context).textTheme.headline,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  _uax.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  _uay.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  _uaz.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
            SizedBox(height: 50,),
            Text(
              'Gyroscope Events listen',
              style: Theme.of(context).textTheme.headline,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  _gx.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  _gy.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  _gz.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
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
