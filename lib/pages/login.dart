import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _isHidden = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double loginAndRegisterHeight =
        MediaQuery.of(context).size.height - 296 > 430
            ? MediaQuery.of(context).size.height - 296
            : 430;

    return Scaffold(
        body: Container(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(13, 30, 7, 26),
                        //height: MediaQuery.of(context).size.height,
                        child: Column(children: [
                          Container(
                              height: 240,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 65,
                                    child: Container(
                                      width: 128,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage('assets/logo.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 310,
                                      height: 310,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage('assets/kz.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.fromLTRB(3, 0, 9, 0),
                              height: loginAndRegisterHeight,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("   Вход в биллинг",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 22,
                                              color: Color(0xff4A4A4A))),
                                    ),

                                    SizedBox(height: 20),

                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: emailController,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  height: 1.5,
                                                  color: Colors.black
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'Введите логин или e-mail',
                                                hintStyle: TextStyle(
                                                    color: Color(0x80979797),
                                                ),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Поле не может быть пустым';
                                                }
                                                var regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+");
                                                if (!regExp.hasMatch(emailController.text)) {
                                                  return 'Введите корректный e-mail';
                                                }
                                                return null;
                                              },
                                            ),

                                            SizedBox(height: 21),

                                            TextFormField(
                                                controller: passwordController,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    height: 1.5,
                                                    color: Colors.black,
                                                ),
                                                obscureText: _isHidden,
                                                decoration: InputDecoration(
                                                    hintText: 'Введите пароль',
                                                    hintStyle: TextStyle(
                                                      color: Color(0x80979797),
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                                    suffix: InkWell(
                                                      onTap: _togglePassword,
                                                      child: Icon(
                                                          _isHidden ? Icons.visibility : Icons.visibility_off,
                                                          color: Colors.black38
                                                      ),
                                                    )),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Поле не может быть пустым';
                                                  }
                                                  if(value.length < 6 || value.length > 30) {
                                                    return 'Пароль должен состоять из 6-30 символов';
                                                  }
                                                  return null;
                                                },
                                            ),

                                            Container(
                                              margin: new EdgeInsets.symmetric(horizontal: 20.0),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                        'Забыли пароль?',
                                                        style: TextStyle(
                                                            decoration: TextDecoration.underline,
                                                            fontSize: 12))),
                                              ),
                                            ),

                                            SizedBox(height: 30),

                                            // LOGIN BUTTON with Shadow
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  height: 59,
                                                  width: double.infinity,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color(0xffD6403E),
                                                          borderRadius: BorderRadius.all(Radius.circular(6))),
                                                ),
                                                Container(
                                                  height: 54,
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                      child: Text('Войти',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w600)
                                                      ),
                                                      onPressed: () {
                                                        if (_formKey.currentState!.validate()) {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          signIn(emailController.text, passwordController.text);
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color(
                                                                      0xffF04946)))),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(6))
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ]),
                                  Column(children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text.rich(
                                          TextSpan(
                                              text: 'Нажимая «Регистрация» вы подтверждаете согласие с условиями ',
                                              style: TextStyle(
                                                  color: Color(0xffADADAD),
                                                  fontSize: 10),
                                              children: [
                                                TextSpan(
                                                    text: 'договора-оферты',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 10,
                                                        decoration: TextDecoration.underline)
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          height: 60,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              color: Color(0xff0083C1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                        ),
                                        Container(
                                          height: 55,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              child: Text('Регистрация',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color(0xff0094DA)))),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ],
                              ))
                        ])))));
  }

  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  signIn(String email, password) async {
    Map data = {'email': email, 'password': password};

    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var url = Uri.parse('http://testapp.vipsite.kz/api/v1/login');
    var response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      if(jsonData['status'] == 200) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString('token', data.toString());
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Произошла ошибка. Пожалуйста, проверьте правильность ввода почты и пароля'), backgroundColor: Colors.red,));
      }
    }
  }
}
