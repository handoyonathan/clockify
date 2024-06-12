import 'dart:convert';

import 'package:clocklify/home.dart';
import 'package:clocklify/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Password extends StatefulWidget {
  final String email;
  const Password({super.key, required this.email});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController _controller = TextEditingController();
  bool _obscureText = true;
  bool _isPasswordHidden = true;
  String? _errorText;

  void passwordVisible() {
    setState(() {
      _obscureText = !_obscureText;
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  Future<void> _verifyCredentials(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/authentication'),
        body: {
          'email': email,
          'password': password,
        },
      );

      print(response.statusCode);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);

        print(user.email);
        print(user.id);
        print(user.password);
        print(user.token);
        print(email);
        print(password);

        if (user.email == email && user.password == password) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomePage(token: user.token);
          }));
        } else {
          setState(() {
            _errorText = 'Email or password is incorrect';
          });
        }
      } else {
        setState(() {
          _errorText = 'Failed to log in';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorText = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(35, 57, 113, 1),
        ),
        leadingWidth: 40,
      ),
      body: SafeArea(
          child: Container(
        // color: Colors.amber,
        alignment: Alignment.topLeft,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(15),
              child: Text(
                'Password',
                style: TextStyle(
                    color: Color.fromRGBO(35, 57, 113, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 40),
              child: TextField(
                controller: _controller,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  errorText: _errorText,
                  hintText: 'Input Your Password',
                  hintStyle: TextStyle(fontSize: 14),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      passwordVisible();
                    },
                    child: SizedBox(
                      height: 12,
                      width: 12,
                      child: Image.asset(
                        _isPasswordHidden
                            ? 'assets/Eye-Off-4.png'
                            : 'assets/Eye-On-4.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(69, 205, 220, 1),
                  minimumSize: Size(370, 48),

                  // shape: ContinuousRectangleBorder(),
                  elevation: 3,
                ),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      _errorText = null;
                    });
                    print(_controller.text);
                    _verifyCredentials(widget.email, _controller.text);
                  } else {
                    setState(() {
                      _errorText = 'Password must be filled';
                    });
                  }
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?',
                      style: TextStyle(
                        color: Color.fromRGBO(166, 167, 197, 1),
                        // decoration: TextDecoration.underline
                      )),
                ))
          ],
        ),
      )),
    );
  }
}
