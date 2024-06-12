import 'package:clocklify/create_acc.dart';
import 'package:clocklify/password.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(37, 54, 123, 1),
      // appBar: AppBar(title: Text('ini text'),),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 130),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Image.asset('assets/Logo-1.png'),
                height: 40,
                width: 260,
              ),
              Container(
                // alignment: Alignment.bottomCenter,
                // color: Colors.amber,
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: TextField(
                        // maxLength: 5,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          labelText: 'E-Mail',
                          errorText: _errorText,
                          errorStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                          icon: Image.asset(
                            'assets/email_signin.png',
                            height: 32,
                            width: 32,
                          ),
                        ),

                        onChanged: (value) {
                          setState(
                            () {},
                          );
                        },
                        controller: _controller,
                      ),
                    ),
                    FilledButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            setState(() {
                              _errorText = null;
                            });
                            print(_controller.text);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              print(_controller.text);
                              return Password(
                                email: _controller.text,
                              );
                            }));
                          } else {
                            setState(() {
                              _errorText = 'Email must be filled';
                            });
                          }
                          ;
                        },
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: Color.fromRGBO(69, 205, 220, 1),
                            minimumSize: Size(328, 48))),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateAcc();
                          }));
                        },
                        child: Text(
                          'Create new account?',
                          style: TextStyle(
                              // decoration: TextDecoration.underline,
                              // decorationColor: Color.fromRGBO(166, 167, 197, 1),
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ))
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
