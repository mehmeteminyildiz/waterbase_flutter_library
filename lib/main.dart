import 'package:flutter/material.dart';
import 'package:http_deneme_4/ChatArea.dart';
import 'package:http_deneme_4/Waterbase.dart';
import 'package:http_deneme_4/WaterbaseUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waterbase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Giris(),
    );
  }
}

class Giris extends StatefulWidget {
  const Giris({Key? key}) : super(key: key);

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  var tfMesajController = TextEditingController();
  bool kontrol = false;

  void girisKontrol() async {
    var sp = await SharedPreferences.getInstance();
    bool isEntered = sp.getBool("isEntered")!;
    //print("giriş yapıldı mı: $isEntered");
    setState(() {
      kontrol = isEntered;
    });
  }

  @override
  Widget build(BuildContext context) {
    girisKontrol();
    return kontrol
        ? ChatArea()
        : Scaffold(
            appBar: AppBar(
              title: Text("Giriş"),
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: tfMesajController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            String kullaniciAdi = tfMesajController.text;
                            print(kullaniciAdi);
                            Waterbase wb =
                                new Waterbase("http://176.43.32.147");
                            wb.createUser(kullaniciAdi);
                            setState(() {
                              kontrol = true;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Kullanıcı Adı',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
