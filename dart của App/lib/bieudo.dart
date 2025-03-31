import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biểu đồ dữ liệu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BieuDo(),
    );
  }
}

class BieuDo extends StatefulWidget {
  const BieuDo({Key? key}) : super(key: key);

  @override
  _BieuDoState createState() => _BieuDoState();
}

class _BieuDoState extends State<BieuDo> {
  String _nhietdo = "";
  String _doamkk = "";
  String _doamdat = "";
  String _mucnuoc = "";

  List<DataPoint> _nhietdoData = [];
  List<DataPoint> _doamkkData = [];
  List<DataPoint> _doamdatData = [];
  List<DataPoint> _mucnuocData = [];

  final ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    DatabaseReference nhietDo = ref.child('Nhiet do');
    nhietDo.onValue.listen((event) {
      setState(() {
        _nhietdo = event.snapshot.value.toString();
        _nhietdoData
            .add(DataPoint(_nhietdoData.length, double.parse(_nhietdo)));
      });
    });

    DatabaseReference doamKK = ref.child('Do am');
    doamKK.onValue.listen((event) {
      setState(() {
        _doamkk = event.snapshot.value.toString();
        _doamkkData.add(DataPoint(_doamkkData.length, double.parse(_doamkk)));
      });
    });

    DatabaseReference doamDat = ref.child('Do am dat');
    doamDat.onValue.listen((event) {
      setState(() {
        _doamdat = event.snapshot.value.toString();
        _doamdatData
            .add(DataPoint(_doamdatData.length, double.parse(_doamdat)));
      });
    });

    DatabaseReference mucnuocData = ref.child('Muc nuoc');
    mucnuocData.onValue.listen((event) {
      setState(() {
        _mucnuoc = event.snapshot.value.toString();
        _mucnuocData
            .add(DataPoint(_mucnuocData.length, double.parse(_mucnuoc)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Biểu đồ nhiệt độ môi trường',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    LineSeries<DataPoint, int>(
                      dataSource: _nhietdoData,
                      xValueMapper: (DataPoint data, _) => data.index,
                      yValueMapper: (DataPoint data, _) => data.value,
                    ),
                  ],
                ),
              ),
              Text(
                'Biểu đồ độ ẩm môi trường',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    LineSeries<DataPoint, int>(
                      dataSource: _doamkkData,
                      xValueMapper: (DataPoint data, _) => data.index,
                      yValueMapper: (DataPoint data, _) => data.value,
                    ),
                  ],
                ),
              ),
              Text(
                'Biểu đồ độ ẩm đất',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    LineSeries<DataPoint, int>(
                      dataSource: _doamdatData,
                      xValueMapper: (DataPoint data, _) => data.index,
                      yValueMapper: (DataPoint data, _) => data.value,
                    ),
                  ],
                ),
              ),
              Text(
                'Biểu đồ V nước',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    LineSeries<DataPoint, int>(
                      dataSource: _mucnuocData,
                      xValueMapper: (DataPoint data, _) => data.index,
                      yValueMapper: (DataPoint data, _) => data.value,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataPoint {
  final int index;
  final double value;

  DataPoint(this.index, this.value);
}
