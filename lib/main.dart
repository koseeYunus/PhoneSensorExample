import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_circular_chart_two/flutter_circular_chart_two.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
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

  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(200.0, 200.0);
  double value = 0;
  Color labelColor = Colors.red[200];


  double _gx, _gy, _gz;

  int _gPoint = 0;

  String _status="Hadi başlayalım.";

  void _increment() {
    setState(() {
      value += 1;
      List<CircularStackEntry> data = _generateChartData(value);
      _chartKey.currentState.updateData(data);
    });
  }

  void _decrement() {
    setState(() {
      value -= 1;
      List<CircularStackEntry> data = _generateChartData(value);
      _chartKey.currentState.updateData(data);
    });
  }

  List<CircularStackEntry> _generateChartData(double value) {
    Color dialColor = Colors.deepOrangeAccent[200];

    labelColor = dialColor;

    List<CircularStackEntry> data = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            value,
            dialColor,
            rankKey: 'percentage',
          )
        ],
        rankKey: 'percentage',
      ),
    ];

    if (value > 100) {
      labelColor = Colors.indigoAccent;

      data.add(CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            value - 100,
            Colors.indigoAccent,
            rankKey: 'percentage',
          ),
        ],
        rankKey: 'percentage2',
      ));
    }

    if (value > 200) {
      labelColor = Colors.green[200];

      data.add(CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            value - 200,
            Colors.green[200],
            rankKey: 'percentage',
          ),
        ],
        rankKey: 'percentage3',
      ));
    }

    return data;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gx = event.x;
        _gy = event.y;
        _gz = event.z;
      });
      if (_gx > 1 || _gy > 1 || _gz > 1) {
        _gPoint += 1;
        _increment();
        Future.delayed(const Duration(seconds: 2), () => "2");
      }
    });
    debugPrint(_gPoint.toString());
    if(_gPoint>0){
      _status="Daha yeni başladık.";
    }
    else if(_gPoint>100){
      _status="Neredeyse bitirdik.";
    }
    else if(_gPoint>200){
      _status="Son aşama.";
    }
    else{
      _status="BUGUNKİ SPORUNU TAMAMLADIN TEBRİKLER.";
    }


  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context).textTheme.headline.merge(TextStyle(color: labelColor));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              child: AnimatedCircularChart(
                key: _chartKey,
                size: _chartSize,
                initialChartData: _generateChartData(value),
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                percentageValues: true,
                holeLabel: '$value%',
                labelStyle: _labelStyle,
              ),
            ),

            Text(
              _status,
              style: Theme.of(context).textTheme.subtitle,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: _decrement,
                  child: const Icon(Icons.remove),
                  shape: const CircleBorder(),
                  color: Colors.red[200],
                  textColor: Colors.white,
                ),
                RaisedButton(
                  onPressed: _increment,
                  child: const Icon(Icons.add),
                  shape: const CircleBorder(),
                  color: Colors.blue[200],
                  textColor: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 50,),

            Text(
              'Jiroskop Verileri',
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 25,),
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
            SizedBox(
              height: 100,
            ),
            Text(
              "Puan",
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _gPoint.toString(),
              style: Theme.of(context).textTheme.display1,
            ),

          ],
        ),
      ),
    );
  }
}
