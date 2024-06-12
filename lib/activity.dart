import 'package:clocklify/detail.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:clocklify/activity_model.dart';

const List<String> list = <String>['Latest Date', 'Nearby'];

// asdasdasdasd

class ActivityPage extends StatelessWidget {
  final String token;
  const ActivityPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, activityProvider, _) {
        return _ActivityTab(
          activityProvider: activityProvider,
          token: token,
        );
      },
    );
  }
}

class _ActivityTab extends StatefulWidget {
  final ActivityProvider activityProvider;
  final String token;
  const _ActivityTab({required this.activityProvider, required this.token});

  @override
  State<_ActivityTab> createState() => __ActivityTabState();
}

class __ActivityTabState extends State<_ActivityTab> {
  String _searchKeyword = '';
  bool isNearby = false;
  bool isLatest = false;
  double? _latitude, _longitude;
  bool? vari;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search activity',
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        try {
                          await widget.activityProvider
                              .searchActivity(widget.token, _searchKeyword);
                        } catch (error) {
                          print('Failed to search activities: $error');
                        }
                      },
                      child: SizedBox(
                        height: 10,
                        width: 10,
                        child: Image.asset('assets/Search.png'),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: DropdownMenu<String>(
                initialSelection: list.first,
                onSelected: (String? value) async {
                  if (value == 'Latest Date') {
                    setState(() {
                      isLatest = true;
                      isNearby = false;
                    });
                  }
                  if (value == 'Nearby') {
                    setState(() {
                      isNearby = true;
                      isLatest = false;
                    });
                  }
                },
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  filled: true,
                  fillColor: Color.fromRGBO(67, 75, 140, 1),
                ),
                textStyle: TextStyle(color: Colors.white),
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        FutureBuilder<List<ActivityModel>?>(
          future: _searchKeyword.isEmpty
              ? (isLatest || isNearby)
                  ? isLatest
                      ? widget.activityProvider.sortDataByLatest(widget.token)
                      : widget.activityProvider.sortDataByNearby(
                          widget.token, _latitude!, _longitude!)
                  : widget.activityProvider.fetchActivities(widget.token)
              : (isLatest || isNearby)
                  ? isLatest
                      ? widget.activityProvider
                          .searchLatestActivity(widget.token, _searchKeyword)
                      : widget.activityProvider.searchNearbyActivity(
                          widget.token, _latitude!, _longitude!, _searchKeyword)
                  : widget.activityProvider
                      .searchActivity(widget.token, _searchKeyword),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<ActivityModel> activities = snapshot.data ?? [];
              List<String> dates = activities
                  .map((activity) => activity.startTime.substring(0, 10))
                  .toSet()
                  .toList();

              return Expanded(
                child: ListView.separated(
                  itemCount: dates.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(),
                  itemBuilder: (BuildContext context, int index) {
                    String date = dates[index];
                    List<ActivityModel> activitiesForDate = activities
                        .where((activity) =>
                            activity.startTime.substring(0, 10) == date)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: Color.fromRGBO(67, 75, 140, 1),
                          child: Text(
                            date,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(248, 208, 104, 1)),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: activitiesForDate.length,
                          itemBuilder: (BuildContext context, int index) {
                            ActivityModel activity = activitiesForDate[index];
                            String startClock =
                                activity.startTime.substring(11, 19);
                            String endClock =
                                activity.endTime.substring(11, 19);


                            return Dismissible(
                              key: Key(activity.id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onDismissed: (direction) async {
                                try {
                                  await widget.activityProvider.deleteActivity(
                                      widget.token, activity.id);
                                  setState(() {
                                    activities.remove(activity);
                                  });
                                } catch (error) {
                                  print('Failed to delete activity: $error');
                                }
                              },
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return DetailPage(
                                        activityProvider:
                                            widget.activityProvider,
                                        token: widget.token,
                                        id: activity.id,
                                      );
                                    }),
                                  );
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity.duration,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/clock.png',
                                            width: 15,
                                            height: 15,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '$startClock - $endClock',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Color.fromRGBO(
                                                    167, 166, 197, 1)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        activity.activity,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/placeholder2.png',
                                            width: 15,
                                            height: 15,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '${activity.latitude}, ${activity.longitude}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Color.fromRGBO(
                                                    167, 166, 197, 1)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                                                                  ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
