import 'package:clocklify/activity_model.dart';
import 'package:clocklify/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatelessWidget {
  final String token;

  const TimerPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timerProvider, _) {
      return _TimerTab(
        timerModel: timerProvider,
        token: token,
      );
    });
  }
}

class _TimerTab extends StatefulWidget {
  final TimerModel timerModel;
  final String token;
  const _TimerTab({required this.timerModel, required this.token});

  @override
  State<_TimerTab> createState() => __TimerTabState();
}

class __TimerTabState extends State<_TimerTab> {
  TextEditingController _controller = TextEditingController();
  late ActivityModel activityModel;
  String? _errorText;
  String _locationMessage = '';
  double? longitude, latitude;
  FocusNode inputNode = FocusNode();
  // String _locationMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    print('token di timer: ' + widget.token);
  }

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _locationMessage = "${position.latitude}${position.longitude}";
        longitude = position.longitude;
        latitude = position.latitude;
      });
    } catch (e) {
      print(e);
      setState(() {
        _locationMessage = 'Failed to get location';
        print('Failed to get location: $e');
      });
    }
  }

  void _updateLocation() async {
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Spacer(),
      Text(
        widget.timerModel
            .timeFormat(widget.timerModel.stopwatch.elapsedMilliseconds),
        key: UniqueKey(),
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Start Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(widget.timerModel.startTime,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.timerModel.startDate,
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                // Text('$hourStamp : $minuteStamp : $secondStamp', style: TextStyle(color: Colors.white)),
                // Text('$date $month $year', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('End Time',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                Text(widget.timerModel.endTime,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.timerModel.endDate,
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          )
        ],
      ),
      Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
          decoration: BoxDecoration(
              color: Colors.white10, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/Placeholder.png',
                height: 32,
                width: 32,
              ),
              Text(_locationMessage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  )),
            ],
          )),
      Container(
        // color: Colors.amber,
        margin: EdgeInsets.all(20),
        child: TextField(
          maxLines: 3,
          controller: _controller,
          // autofocus: true,
          focusNode: inputNode,
          // keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            errorText: _errorText,
            isDense: true,
            // contentPadding: EdgeInsets.symmetric(vertical: 50),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
      if (widget.timerModel.isStopped)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(69, 205, 220, 1),
                  minimumSize: Size(160, 50)),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _errorText = null;
                    print('hai');
                  });
                  print('hai 2');
                  print(_controller.text);
                  widget.timerModel.storeActivity(
                      widget.token,
                      _controller.text,
                      widget.timerModel.formattedStartDateTime,
                      widget.timerModel.formattedEndDateTime,
                      widget.timerModel.duration,
                      latitude.toString(),
                      longitude.toString());
                } else {
                  setState(() {
                    _errorText = 'Actiivity must be filled';
                  });
                }
              },
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            // SizedBox(width: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, minimumSize: Size(160, 50)),
              onPressed: widget.timerModel.resetTimer,
              child: Text('DELETE',
                  style: TextStyle(
                      color: Color.fromRGBO(167, 166, 197, 1), fontSize: 16)),
            ),
          ],
        ),
      if (!widget.timerModel.isRunning && !widget.timerModel.isStopped)
        Container(
          // color: Colors.amber,
          // margin: EdgeInsets.all(15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(69, 205, 220, 1),
              minimumSize: Size(350, 50),
            ),
            onPressed: widget.timerModel.startTimer,
            child: Text('START',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      if (widget.timerModel.isRunning)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(69, 205, 220, 1),
                  minimumSize: Size(160, 50)),
              onPressed: widget.timerModel.stopTimer,
              child: Text('STOP',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            // SizedBox(width: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, minimumSize: Size(160, 50)),
              onPressed: widget.timerModel.resetTimer,
              child: Text('RESET',
                  style: TextStyle(
                      color: Color.fromRGBO(167, 166, 197, 1), fontSize: 16)),
            ),
          ],
        ),
      SizedBox(
        height: 30,
      )
    ]);
  }
}
