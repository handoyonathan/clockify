import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TimerModel extends ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _isRunning = false;
  bool _isStopped = false;

  // DateTime timeStamp = DateTime.now();
  String formattedStartDateTime = '';
  String formattedEndDateTime = '';
  String duration = '';

  int date = 0;
  String startDate = '-';
  String endDate = '-';
  String startTime = '-';
  String endTime = '-';

  String month = '';
  String year = '';
  String hourStamp = '';
  String minuteStamp = '';
  String secondStamp = '';

  FocusNode inputNode = FocusNode();

  bool get isRunning => _isRunning;
  bool get isStopped => _isStopped;

  get stopwatch => _stopwatch;

  void updateTimeStamp() {
      DateTime timeStamp = DateTime.now();
      date = timeStamp.day;
      month = DateFormat.MMM().format(timeStamp);
      year = DateFormat('yy').format(timeStamp);
      hourStamp = DateFormat('HH').format(timeStamp);
      minuteStamp = DateFormat('mm').format(timeStamp);
      secondStamp = DateFormat('ss').format(timeStamp);
      if (startDate == '-' && startTime == '-') {
        startDate = '$date $month $year';
        startTime = '$hourStamp:$minuteStamp:$secondStamp';
        formattedStartDateTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(timeStamp);
        return;
      }
      if (endDate == '-' && endTime == '-') {
        endDate = '$date $month $year';
        endTime = '$hourStamp:$minuteStamp:$secondStamp';
        formattedEndDateTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(timeStamp);
      }
  }

  Future<void> storeActivity(String token, String activity,String startTime,String endTime,String duration,String latitude,String longitude) async {
    print(activity);
    print(startTime);
    print(endTime);
    print(duration);
    print(latitude + longitude);
    try {
      final Uri url =
          Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/insert');
      final Map<String, dynamic> requestBody = {
        'activity_name': activity,
        'start_time': startTime,
        'end_time': endTime,
        'duration': duration,
        'latitude': latitude,
        'longitude': longitude,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('udah masuk harusnya ke postman');
        notifyListeners();
      } else {
          print('gagal menyimpan data');
      }
    } catch (e) {
      print('Error: $e');
      print('terjadi kesalahan');
    }
  }

  void startTimer() {
      _isStopped = false;
      _isRunning = true;
      _stopwatch.start();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        notifyListeners();
      });
    updateTimeStamp();
    // notifyListeners();
  }

  void stopTimer() {
      _isRunning = false;
      _stopwatch.stop();
      _isStopped = true;
      updateTimeStamp();
      notifyListeners();
  }

  void resetTimer() {
      _isRunning = false;
      _stopwatch.stop();
      _stopwatch.reset();
      startDate = '-';
      startTime = '-';
      endDate = '-';
      endTime = '-';
      _isStopped = false;
      notifyListeners();
  }

  String timeFormat(int milliseconds) {
        int seconds = (milliseconds / 1000).truncate() % 60;
    int minutes = (milliseconds / (1000 * 60)).truncate() % 60;
    int hours = (milliseconds / (1000 * 60 * 60)).truncate();


    String hoursStr = (hours % 24).toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    duration = '$hoursStr:$minutesStr:$secondsStr';

    return '$hoursStr : $minutesStr : $secondsStr';
  }
}