import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_deneme_4/Waterbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

class PersonalChat extends StatefulWidget {
  String konusulanKullaniciAdi;

  PersonalChat({required this.konusulanKullaniciAdi});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  void sendMessage(String data, String link) async {
    var sp = await SharedPreferences.getInstance();
    String pub = sp.getString("pub")!;
    String id = sp.getString("id")!;
    // result: şifrelenmiş data
    String? result = Cryptom(pub, id).text(data);

    var response = await http.post(
      Uri.parse('http://176.43.32.147/wb-com/$link'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{"id": id, "data": result},
      ),
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.konusulanKullaniciAdi),
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
