import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActivityModel {
  final String activity, startTime, endTime, duration;
  final double longitude, latitude;
  final int id;

  const ActivityModel(
      { required this.id,
        required this.activity,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.latitude,
      required this.longitude});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
        id: json['id'],
        activity: json['activity'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        duration: json['duration'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }
}

class ActivityProvider extends ChangeNotifier {
  // final String token;
  List<ActivityModel> _activities = [];

  // ActivityProvider({required this.token});

  List<ActivityModel> get activities => _activities;

  Future<List<ActivityModel>> fetchActivities(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/activities'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("hai" + response.statusCode.toString());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['activities'];
        _activities = data.map((json) => ActivityModel.fromJson(json)).toList();
        return _activities;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<ActivityModel>> searchActivity(String token, String keyword) async {
    try {
      final response = await http.post(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/search-activity'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'keyword': keyword},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['activities'];
        _activities = data.map((json) => ActivityModel.fromJson(json)).toList();
        // notifyListeners();
        print('ini search');
        print(_activities);
        return _activities;
      } else {
        throw Exception('Failed to search activities: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<ActivityModel>> searchLatestActivity(String token, String keyword) async {
    try {
      final response = await http.post(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/search-activity-latest'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'keyword': keyword},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['activities'];
        print(data);
        _activities = data.map((json) => ActivityModel.fromJson(json)).toList();
        // notifyListeners();
        print('ini latest search');
        // print(_activities);
        return _activities;
      } else {
        throw Exception('Failed to search activities: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<ActivityModel>> searchNearbyActivity(String token, double latitude, double longitude, String keyword) async {
    try {
      final response = await http.post(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/search-activity-distance'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
            'keyword': keyword,
            'latitude': latitude.toString(),
            'longitude': longitude.toString()
          }
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Data sorted successfully');
        print('$latitude $longitude');
        final List<dynamic> data = jsonDecode(response.body)['activities'];
        _activities = data.map((json) => ActivityModel.fromJson(json)).toList();
        print(data);
        // notifyListeners();
        print('ini nearby search');
        // print(_activities);
        return _activities;
      } else {
        throw Exception('Failed to sort data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> deleteActivity(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/activity/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _activities.removeWhere((activity) => activity.id == id);
        notifyListeners();
        fetchActivities(token);
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<ActivityModel>> sortDataByLatest(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/sort-by-latest'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Data sorted successfully');
        final List<dynamic> data = jsonDecode(response.body)['activities'];
        print(data);
        _activities = data.map((json) => ActivityModel.fromJson(json)).toList();
        // notifyListeners();
        print('ini latest');
        // print(_activities);
        return _activities;
      } else {
        throw Exception('Failed to sort data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<ActivityModel>> sortDataByNearby(String token, double latitude, double longitude) async {
    try {
      final response = await http.post(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/sort-by-distance'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
            'latitude': latitude.toString(),
            'longitude': longitude.toString()
          }
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Data sorted successfully');
        print('$latitude $longitude');
        final List<dynamic> data = jsonDecode(response.body)['activities'];
        _activities = data.map((json) => ActivityModel.fromJson(json)).toList();
        print(data);
        // notifyListeners();
        print('ini nearby');
        // print(_activities);
        return _activities;
      } else {
        throw Exception('Failed to sort data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<ActivityModel>> loadData(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://15d6-103-19-109-40.ngrok-free.app/activity/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['activity'];
        notifyListeners();
        return data.map((json) => ActivityModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> updateActivity(String activity, String start, String end,
      String duration, double latitude, double longitude, String token, int id) async {
    try {
      final response = await http.put(
          Uri.parse(
              'https://15d6-103-19-109-40.ngrok-free.app/activity/$id'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            'activity_name': activity,
            'start_time': start,
            'end_time': end,
            'duration': duration,
            'latitude': latitude.toString(),
            'longitude': longitude.toString()
          });
      // print(widget.id);
      // print('ini token ' + widget.token);c

      if (response.statusCode == 200) {
        print('Activity Updated');
        //show pop up abis itu baru keluar
        // await widget.activityProvider.fetchActivities(widget.token);
        notifyListeners();
        // Navigator.pop(context, true); 

      } else {
        print('Gagal memperbarui data aktivitas: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

}
