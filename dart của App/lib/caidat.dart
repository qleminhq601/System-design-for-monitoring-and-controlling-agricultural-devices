import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: camel_case_types
class caidat extends StatefulWidget {
  const caidat({super.key});

  @override
  State<caidat> createState() => _MainUIState();
}

class _MainUIState extends State<caidat> {
  bool _isDeviceOn = false;
  bool _isLightOn = false;
  bool _buttonOn = false;
  bool _switchEnabled = true;
  String _nhietdo = "";
  String _doamkk = "";
  String _doamdat = "";
  String _anhsang = "";
  String _mucnuoc = "";
  String _dongdien = "";
  int _humidityThresholdOn = 50;
  int _humidityThresholdOff = 80;
  // ignore: unused_field
  final Color _backgroundColor = const Color.fromARGB(255, 250, 250, 250);
  // ignore: unused_field
  final Color _appBarColor = const Color(0xFF4CAF50);
  final Color _textColor = const Color.fromARGB(255, 0, 0, 0);

  final ref = FirebaseDatabase.instance.ref();

  void _updateHumidityThresholdOn(double value) {
    setState(() {
      _humidityThresholdOn = value.round();
      ref.child('z_Doam_bat_bom').set(_humidityThresholdOn);
    });
  }

  void _updateHumidityThresholdOff(double value) {
    setState(() {
      _humidityThresholdOff = value.round();
      ref.child('z_Doam_tat_bom').set(_humidityThresholdOff);
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference nhietDo =
        FirebaseDatabase.instance.ref().child('Nhiet do');
    nhietDo.onValue.listen((event) {
      setState(() {
        _nhietdo = event.snapshot.value.toString();
      });
    });
    DatabaseReference doamKK = FirebaseDatabase.instance.ref().child('Do am');
    doamKK.onValue.listen((event) {
      setState(() {
        _doamkk = event.snapshot.value.toString();
      });
    });
    DatabaseReference doamDat =
        FirebaseDatabase.instance.ref().child('Do am dat');
    doamDat.onValue.listen((event) {
      setState(() {
        _doamdat = event.snapshot.value.toString();
      });
    });
    DatabaseReference anhSang =
        FirebaseDatabase.instance.ref().child('Anhsang');
    anhSang.onValue.listen((event) {
      setState(() {
        _anhsang = event.snapshot.value.toString();
      });
    });
    DatabaseReference mucNuoc =
        FirebaseDatabase.instance.ref().child('Muc nuoc');
    mucNuoc.onValue.listen((event) {
      setState(() {
        _mucnuoc = event.snapshot.value.toString();
      });
    });
    DatabaseReference dongDien =
        FirebaseDatabase.instance.ref().child('Dong dien');
    dongDien.onValue.listen((event) {
      setState(() {
        _dongdien = event.snapshot.value.toString();
      });
    });
    DatabaseReference doambatbom =
        FirebaseDatabase.instance.ref().child('z_Doam_bat_bom');
    doambatbom.onValue.listen((event) {
      setState(() {
        _humidityThresholdOn = int.parse(event.snapshot.value.toString());
      });
    });
    DatabaseReference doamtatbom =
        FirebaseDatabase.instance.ref().child('z_Doam_tat_bom');
    doamtatbom.onValue.listen((event) {
      setState(() {
        _humidityThresholdOff = int.parse(event.snapshot.value.toString());
      });
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 15, // Khoảng cách giữa các `SizedBox`
                  runSpacing: 16, // Khoảng cách giữa các hàng
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // Độ rộng của mỗi `SizedBox`
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/hot.png',
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Nhiệt độ: $_nhietdo °C',
                            style: TextStyle(fontSize: 12, color: _textColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // Độ rộng của mỗi `SizedBox`
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/humidity.png',
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Độ ẩm MT: $_doamkk %',
                            style: TextStyle(fontSize: 12, color: _textColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // Độ rộng của mỗi `SizedBox`
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/plant.png',
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Độ ẩm đất: $_doamdat %',
                            style: TextStyle(fontSize: 12, color: _textColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // Độ rộng của mỗi `SizedBox`
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/anhsang.png',
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Ánh sáng: $_anhsang CD',
                            style: TextStyle(fontSize: 12, color: _textColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // Độ rộng của mỗi `SizedBox`
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/mucnuoc.png',
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Muc nuoc: $_mucnuoc cm',
                            style: TextStyle(fontSize: 12, color: _textColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // Độ rộng của mỗi `SizedBox`
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/dongdien.png',
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Dòng máy bơm: $_dongdien A',
                            style: TextStyle(fontSize: 12, color: _textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                _isLightOn ? 'assets/den1.png' : 'assets/den.png',
                width: 91,
                height: 91,
              ),
              const SizedBox(width: 16),
              Text(_isLightOn ? 'Bật đèn' : 'Tắt đèn',
                  style: TextStyle(fontSize: 18, color: _textColor)),
              const Spacer(),
              Switch(
                value: _isLightOn,
                onChanged: (bool value) {
                  setState(() {
                    _isLightOn = !_isLightOn;
                    ref.child('den').set(_isLightOn ? 1 : 0);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                _isDeviceOn ? 'assets/bom.png' : 'assets/bom1.png',
                width: 71,
                height: 71,
              ),
              const SizedBox(width: 16),
              Text(
                _isDeviceOn ? 'Bật máy bơm' : 'Tắt máy bơm',
                style: TextStyle(fontSize: 18, color: _textColor),
              ),
              const Spacer(),
              Switch(
                value: _isDeviceOn,
                onChanged: _switchEnabled
                    ? (bool value) {
                        setState(() {
                          _isDeviceOn = value;
                          ref.child('bom').set(_isDeviceOn ? 1 : 0);

                          // Khi switch này được bật, tắt switch còn lại
                          if (_isDeviceOn) {
                            _buttonOn = false;
                            ref.child('chedo').set(0);
                          }
                        });
                      }
                    : null, // Nếu switch bị vô hiệu hóa, onChanged sẽ là null
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                _buttonOn ? 'assets/button1.png' : 'assets/button.png',
                width: 71,
                height: 71,
              ),
              const SizedBox(width: 16),
              Text(
                _buttonOn ? 'Tự động: bật' : 'Tự động: tắt',
                style: TextStyle(fontSize: 18, color: _textColor),
              ),
              const Spacer(),
              Switch(
                value: _buttonOn,
                onChanged: _switchEnabled
                    ? (bool value) {
                        setState(() {
                          _buttonOn = value;
                          ref.child('chedo').set(_buttonOn ? 1 : 0);

                          // Khi switch này được bật, tắt switch còn lại
                          if (_buttonOn) {
                            _isDeviceOn = false;
                            ref.child('bom').set(0);
                          }
                        });
                      }
                    : null, // Nếu switch bị vô hiệu hóa, onChanged sẽ là null
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Text(
                'Độ ẩm bật bơm: ${_buttonOn ? _humidityThresholdOn : 0}',
                style: TextStyle(fontSize: 18, color: _textColor),
              ),
              Slider(
                value: _buttonOn ? _humidityThresholdOn.toDouble() : 0,
                min: 0,
                max: 100,
                onChanged: _buttonOn ? _updateHumidityThresholdOn : null,
                activeColor: const Color(0xFF4CAF50),
              ),
              const SizedBox(height: 16),
              Text(
                'Độ ẩm tắt bơm: ${_buttonOn ? _humidityThresholdOff : 0}',
                style: TextStyle(fontSize: 18, color: _textColor),
              ),
              Slider(
                value: _buttonOn ? _humidityThresholdOff.toDouble() : 0,
                min: 0,
                max: 100,
                onChanged: _buttonOn ? _updateHumidityThresholdOff : null,
                activeColor: const Color(0xFF4CAF50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
