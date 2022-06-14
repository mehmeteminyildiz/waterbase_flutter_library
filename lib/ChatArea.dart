import 'dart:convert';
import "package:http/http.dart" as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_deneme_4/ChatListesi.dart';
import 'package:http_deneme_4/PersonalChat.dart';
import 'package:http_deneme_4/Waterbase.dart';

class ChatArea extends StatefulWidget {
  const ChatArea({Key? key}) : super(key: key);

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  List<ChatListesi> kullaniciListesi = [];

  List<ChatListesi> parseChatListesi(String responseBody) {
    var jsonVeri = json.decode(responseBody);
    //print("jsonVeri: $jsonVeri");
    var jsonArray = jsonVeri["users"] as List;
    //print("jsonArray: $jsonArray");
    List<ChatListesi> chatListesi = jsonArray
        .map((jsonArrayNesnesi) => ChatListesi.fromJson(jsonArrayNesnesi))
        .toList();

    print(chatListesi[0].id);
    setState(() {});

    return chatListesi;
  }

  postData() async {
    var response = await http.post(
      Uri.parse("http://176.43.32.147/wb-http/mehmetdeneme"),
      body: {
        "id": 1.toString(),
        "username": "mhmtyldz",
      },
    );
    print(response.body);
    setState(() {});
    return parseChatListesi(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Area"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              kullaniciListesi = postData();
            },
            child: Text("Click"),
          ),
          Text(kullaniciListesi.length <= 0
              ? "No data"
              : kullaniciListesi[0].username),
        ],
      ),
    );
  }
}
