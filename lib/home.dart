import 'dart:async';
import 'dart:convert';
import 'package:clocklify/activity.dart';
import 'package:clocklify/activity_model.dart';
import 'package:clocklify/timer.dart';
import 'package:clocklify/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const List<String> list = <String>['Latest Date', 'Nearby'];

Future<List<ActivityModel>> fetchActivity(String token) async {
  final response = await http.get(
      Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/activities'),
      headers: {'Authorization': 'Bearer $token'});

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body)['activities'];
    return data.map((json) => ActivityModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> sortDataByLatest(String token) async {
  try {
    final response = await http.post(
      Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/sort-by-latest'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Data sorted successfully');
    } else {
      print('Failed to sort data: ${response.statusCode}');
      throw Exception('Failed to sort data: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Error: $error');
  }
}


class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // double? longitude, latitude;

  TabBar myTabBar = TabBar(
    tabs: [
      Tab(
        text: "TIMER",
      ),
      Tab(text: "ACTIVITY"),
    ],
    automaticIndicatorColorAdjustment: false,
    unselectedLabelStyle: TextStyle(
        color: Color.fromRGBO(167, 166, 197, 1),
        fontWeight: FontWeight.w700,
        fontSize: 14),
    labelStyle: TextStyle(
        color: Color.fromRGBO(248, 208, 104, 1),
        fontWeight: FontWeight.w700,
        fontSize: 14),
    dividerColor: Colors.transparent,
    // indicatorWeight: 4,
    indicator: BoxDecoration(
        // color: Colors.blue,

        border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(248, 208, 104, 1), width: 2))),
  );


  @override
  void initState() {
    super.initState();
    // _updateLocation();
    print('ini token di home: ' + widget.token);
    // fetchActivity(widget.token);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Color.fromRGBO(35, 57, 113, 1),
        home: ChangeNotifierProvider<TimerModel>(
          create: (BuildContext context) { return TimerModel();},
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
                backgroundColor: Color.fromRGBO(35, 57, 113, 1),
                appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(35, 57, 113, 1),
                    title: Image.asset(
                      'assets/Logo-1.png',
                      height: 24,
                      width: 156,
                    ),
                    bottom: PreferredSize(
                      preferredSize:
                          Size.fromHeight(myTabBar.preferredSize.height),
                      child: Container(child: myTabBar),
                    )
                    // bottom: myTabBar,
                    ),
                body: SafeArea(
                  child: TabBarView(children: [
                    TimerPage(token: widget.token,),
          
                    ActivityPage(token: widget.token)
                    // Center(
                    //     child: Text('There is no activity',
                    //         style: TextStyle(color: Colors.white)))
                  ]),
                )),
          ),
        ));
  }
}

