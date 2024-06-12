
import 'package:clocklify/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String token;
  final ActivityProvider activityProvider;
  const DetailPage({super.key, required this.activityProvider,  required this.token, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<ActivityModel>> _activityModelFuture;
  late TextEditingController _controller;
  late String _errorText = '';
  FocusNode inputNode = FocusNode();
  String formattedStartTime = '';
  String formattedEndTime = '';

  @override
  void initState() {
    super.initState();
    _activityModelFuture = widget.activityProvider.loadData(widget.token, widget.id);
    _controller = TextEditingController();
  }



  @override
  Widget build(BuildContext context) {
    String? _errorText;
    String? newValue;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color.fromRGBO(35, 57, 113, 1),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(35, 57, 113, 1),
          title: Text(
            'Detail',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white),
          ),
          leadingWidth: 40,
        ),
        backgroundColor: Color.fromRGBO(35, 57, 113, 1),
        body: FutureBuilder<List<ActivityModel>>(
          future: _activityModelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final activityModel = snapshot.data!;
              _controller.text = activityModel[0].activity;
              formattedStartTime = DateFormat('d MMM yyyy')
                  .format(DateTime.parse(activityModel[0].startTime));
              formattedEndTime = DateFormat('d MMM yyyy')
                  .format(DateTime.parse(activityModel[0].endTime));

              return SafeArea(
                child: Column(children: [
                  Spacer(),
                  Text(
                    activityModel[0].duration,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                            Text(activityModel[0].startTime.substring(11, 19),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(formattedStartTime,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ),
                            Text(activityModel[0].endTime.substring(11, 19),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(formattedEndTime,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
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
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/Placeholder.png',
                            height: 32,
                            width: 32,
                          ),
                          Text(
                              activityModel[0].latitude.toString() +
                                  activityModel[0].longitude.toString(),
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(69, 205, 220, 1),
                            minimumSize: Size(160, 50)),
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            setState(() {
                              _errorText = null;
                              newValue = _controller.text;
                              _controller.text = newValue!;
                              print('hai di detail');
                            });
                            print('hai 2 di detail');
                            print(_controller.text);
                            print(activityModel[0].startTime);
                            print(activityModel[0].endTime);
                            print(activityModel[0].duration);
                            print(activityModel[0].latitude);
                            print(activityModel[0].longitude);

                            try {
                              await widget.activityProvider.updateActivity(
                                  _controller.text,
                                  activityModel[0].startTime,
                                  activityModel[0].endTime,
                                  activityModel[0].duration,
                                  activityModel[0].latitude,
                                  activityModel[0].longitude, widget.token, widget.id);

                                  setState(() {
                                    
                                  });
                                  // Navigator.pop(context);
                                  
                            } catch (e) {
                              print(
                                  'Something went worng when updating data: $e');
                            }
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
                            backgroundColor: Colors.white,
                            minimumSize: Size(160, 50)),
                        onPressed: () async {
                          try {
                            await widget.activityProvider.deleteActivity(widget.token, widget.id);
                            setState(() {
                              
                            });
                            // Navigator.pop(context);
                          } catch (e) {
                            print(
                                'Something went wrong when deleting data: $e');
                          }
                        },
                        child: Text('DELETE',
                            style: TextStyle(
                                color: Color.fromRGBO(167, 166, 197, 1),
                                fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  )
                ]),
              );
            }
          },
        ),
      ),
    );
  }
}
