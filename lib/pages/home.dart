import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var id = 0;
  var name = '';
  var patronymic = '';
  var balance = 0;
  var contacts = '';

  static DateTime now = DateTime.now();
  static DateFormat formatter = DateFormat.yMMMMEEEEd('ru_RU');
  var formatted = formatter.format(now).replaceAll(",", "");
  late final String currentDate;

  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    checkLoginStatus();
    currentDate = formatted.substring(0, formatted.length - 3);
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences?.getString('token') == null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          //
          child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.fromLTRB(16, 55, 16, 0),
                  child: Column(
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    iconSize: 25,
                    onPressed: () {
                      sharedPreferences?.clear();
                      //sharedPreferences?.commit();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    icon: Image.asset('assets/exit.png'),
                  )),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                      text: 'Здравствуйте ',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                      children: <TextSpan>[
                        TextSpan(
                            //text: 'Михаил ',
                            text: '$name ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: Colors.red)
                        ),
                        TextSpan(
                            //text: 'Михайлович',
                            text: '$patronymic',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: Colors.red)
                        )
                      ]),
                ),
              ),
              SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                //
                //child: Text("Сегодня понедельник 1 июня 2020",
                child: Text("Сегодня $currentDate",
                    style: TextStyle(
                        fontSize: 13, color: Colors.black.withOpacity(0.5))),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Ваш ID: $id",
                    style: TextStyle(fontSize: 15, color: Color(0xff353535))),
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                          text: 'Баланс: ',
                          style: TextStyle(fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                //text: '7000',
                                text: '$balance',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            TextSpan(
                                text: ' KZT', style: TextStyle(fontSize: 15)),
                          ]),
                    ),
                  ),
                  SizedBox(width: 30),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon:
                              Icon(Icons.add_circle, color: Color(0xffBDBDBD))),
                      Text('Пополнить', style: TextStyle(fontSize: 15))
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(21),
                decoration: BoxDecoration(
                    color: Color(0xffE8EEF1),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Проверить домен',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Домены .kz за 3500 тенге в год',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          hintText: 'name.kz',
                          hintStyle: TextStyle(
                            color: Color(0x80000000),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 110, height: 50),
                            child: ElevatedButton(
                                onPressed: () {},
                                child: Text('Проверить',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffF04946)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    )))),
                          )),
                    ),
                    SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: 35,
                            height: 25,
                            child: const Center(
                              child: Text(
                                ".kz",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            decoration: const BoxDecoration(
                                color: Color(0xff0094DA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Container(
                            width: 56,
                            height: 25,
                            child: const Center(
                              child: Text(
                                ".com.kz",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            decoration: const BoxDecoration(
                                color: Color(0xff0094DA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Container(
                            width: 56,
                            height: 25,
                            child: const Center(
                              child: Text(
                                ".org.kz",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            decoration: const BoxDecoration(
                                color: Color(0xff0094DA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Container(
                            width: 35,
                            height: 25,
                            child: const Center(
                              child: Text(
                                ".қаз",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            decoration: const BoxDecoration(
                                color: Color(0xff0094DA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Container(
                            width: 35,
                            height: 25,
                            child: const Center(
                              child: Text(
                                "com",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            decoration: const BoxDecoration(
                                color: Color(0xff0094DA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Container(
                            width: 35,
                            height: 25,
                            child: const Center(
                              child: Text(
                                "ru",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            decoration: const BoxDecoration(
                                color: Color(0xff0094DA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/menu/wallet1.png'))),
                              Text('Счета', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0x80000000)))
                            ],
                          ),
                          SizedBox(height: 24),
                          Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/menu/ddos1.png'))),
                              Text('Услуги', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0x80000000)))
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/menu/shopping-bag1.png'))),
                              Text('Заказы', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0x80000000)))
                            ],
                          ),
                          SizedBox(height: 24),
                          Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/menu/chat-bubbles1.png'))),
                              Text('Тикеты', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0x80000000)))
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/menu/internet1.png'))),
                              Text('Домены', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0x80000000)))
                            ],
                          ),
                          SizedBox(height: 24),
                          Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/menu/email1.png'))),
                              Text('Почта', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0x80000000)))
                            ],
                          )
                        ],
                      )
                    ]),
              )
            ],
          )))),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                height: 24,
                width: 24,
                child: SvgPicture.asset('assets/navigationBar/ic_home.svg', color: Color(0xFF0094DA)),
              ),
              label: 'Главная'
          ),
          BottomNavigationBarItem(
            icon: Badge(
              child: Container(
                height: 23,
                width: 23,
                child: SvgPicture.asset('assets/navigationBar/ic_phone.svg', color: Color(0xFFBDBDBD)),
              ),
              //badgeContent: Text('1', style: TextStyle(color: Colors.white)),
              badgeContent: Text(contacts, style: TextStyle(color: Colors.white)),
            ),
            label: 'Контакты',
          ),
          BottomNavigationBarItem(
              icon: Container(
                height: 23,
                width: 23,
                child: SvgPicture.asset('assets/navigationBar/ic_man.svg', color: Color(0xFFBDBDBD)),
              ),
              label: 'Профайл'
          ),
          BottomNavigationBarItem(
              icon: Container(
                height: 23,
                width: 23,
                child: SvgPicture.asset('assets/navigationBar/ic_deal.svg', color: Color(0xFFBDBDBD)),
              ),
              label: 'Партнерка'),
          BottomNavigationBarItem(
              icon: Container(
                height: 23,
                width: 23,
                child: SvgPicture.asset('assets/navigationBar/ic_settings.svg', color: Color(0xFFBDBDBD)),
              ),
              label: 'Настройки')
        ],
      ),
    );
  }


  getUserInfo() async {
    var jsonData;

    var url = Uri.parse('http://testapp.vipsite.kz/api/v1/user/1');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      if(jsonData['status'] == 200) {
        setState(() {
          id = jsonData['data']['id'];
          name = jsonData['data']['name'];
          patronymic = jsonData['data']['patronymic'];
          balance = jsonData['data']['balance'];
          contacts = jsonData['data']['contacts'];
        });
      } else {
        print('status 500');
      }
    }
  }
}
