import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAcc extends StatefulWidget {
  const CreateAcc({super.key});

  @override
  State<CreateAcc> createState() => _CreateAccState();
}

class User {
  final String message;

  User(
      {
      required this.message
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        message: json['message'],
        );
  }
}

class _CreateAccState extends State<CreateAcc> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  String? _errorText;
  String? _errorText2;
  String? _errorText3;
  bool _obscureText = true;
  bool _isPasswordHidden = true;
  bool _obscureText2 = true;
  bool _isConfirmHidden = true;

  Future<void> _storeAccount(
      String email, String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('https://15d6-103-19-109-40.ngrok-free.app/post-register'),
        body: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword
        },
      );

      print(response.statusCode);
      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        final user = User.fromJson(responseData);
        _showPopUp(context, user.message);
        // Navigator.pop(context);

        print(user.message);
        print(email);
        print(password);
        print(confirmPassword);
        
      } else {
        setState(() {
          _errorText = 'Failed to sign in or account with this email has already exist';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorText = 'An error occurred';
      });
    }
  }

  void passwordVisible() {
    setState(() {
      _obscureText = !_obscureText;
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void confirmVisible() {
    setState(() {
      _obscureText2 = !_obscureText2;
      _isConfirmHidden = !_isConfirmHidden;
    });
  }

  void _showPopUp(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/success.png',
                height: 80,
                width: 80,
              ),
              SizedBox(height: 30),
              Text(
                "Success",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(35, 57, 113, 1)),
              ),
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(167, 166, 197, 1)),
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 70, horizontal: 30),
          // contentPadding: EdgeInsets.zero
        );
      },
    );

    // Delay perpindahan halaman menggunakan Timer
    Timer(Duration(seconds: 3), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
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
        // alignment: Alignment.topLeft,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(15),
              child: Text(
                'Create New Account',
                style: TextStyle(
                    color: Color.fromRGBO(35, 57, 113, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 15),
              child: TextField(
                // obscureText: true,
                controller: _controller,
                decoration: InputDecoration(
                  errorText: _errorText,
                  hintText: 'Input Your E-mail',
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: _controller2,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  errorText: _errorText2,
                  hintText: 'Create Your Password',
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
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: _controller3,
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  errorText: _errorText3,
                  hintText: 'Confirm Your Password',
                  hintStyle: TextStyle(fontSize: 14),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      confirmVisible();
                    },
                    child: SizedBox(
                      height: 12,
                      width: 12,
                      child: Image.asset(
                        _isConfirmHidden
                            ? 'assets/Eye-Off-4.png'
                            : 'assets/Eye-On-4.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(15),
                // color: Colors.black,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(69, 205, 220, 1),
                        minimumSize: Size(370, 48),

                        // shape: ContinuousRectangleBorder(),
                        elevation: 3,
                      ),
                      onPressed: () {
                        bool flagA = false;
                        bool flagB = false;
                        bool flagC = false;
                        if (_controller.text.isNotEmpty) {
                          if (!_controller.text.contains('@gmail.com')) {
                            setState(() {
                              flagA = false;
                              _errorText = 'Email must be contain @gmail.com';
                            });
                          } else {
                            setState(() {
                              flagA = true;
                              _errorText = null;
                            });
                            print(_controller.text);
                          }
                        } else if (!_controller.text.isNotEmpty) {
                          setState(() {
                            flagA = false;
                            _errorText = 'Email must be filled';
                          });
                        } else {
                          print('error lain');
                        }

                        if (_controller2.text.isNotEmpty) {
                          setState(() {
                            flagB = true;
                            _errorText2 = null;
                          });
                          print(_controller2.text);
                        } else {
                          setState(() {
                            flagB = false;
                            _errorText2 = 'Password must be filled';
                          });
                        }

                        if (_controller3.text.isNotEmpty) {
                          if (_controller3.text != _controller2.text) {
                            setState(() {
                              flagC = false;
                              _errorText3 =
                                  'Confirm Password must be same as password';
                            });
                          } else {
                            setState(() {
                              flagC = true;
                              _errorText3 = null;
                            });
                            print(_controller3.text);
                          }
                        } else {
                          setState(() {
                            flagC = false;
                            _errorText3 = 'Confirm Password must be filled';
                          });
                        }

                        if (flagA && flagB && flagC) {
                          // connect api
                          print('c1' + _controller.text);
                          print('c2' + _controller2.text);
                          print('c3' + _controller3.text);
                          _storeAccount(_controller.text, _controller2.text,
                              _controller3.text);
                        }
                      },
                      child: Text(
                        'CREATE',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
