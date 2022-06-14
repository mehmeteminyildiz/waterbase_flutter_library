import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import "package:http/http.dart" as http;
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Waterbase {
  String URL;

  Waterbase(this.URL);

  createUser(String kullaniciAdi) async {
    print("create user çalıştı");
    var response = await http.post(
      Uri.parse('$URL/wb-com-begin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          "username": kullaniciAdi,
        },
      ),
    );
    String id = jsonDecode(response.body)["id"];
    String public_key = jsonDecode(response.body)["pub"];
    var sp = await SharedPreferences.getInstance();
    sp.setString("pub", public_key);
    sp.setString("id", id);
    sp.setBool("isEntered", true);
    // ID ve PUBLIC_KEY al, locale kaydet
    checkShared();
  }

  void checkShared() async {
    var sp = await SharedPreferences.getInstance();
    String pub = sp.getString("pub")!;
    String id = sp.getString("id")!;
    print("kayıtlı pub::: $pub");
    print("kayıtlı id::: $id");
  }

  wbRequest(String data, String link) async {
    // 2 kullanıcı arasındaki mesajları getirir.
    // lokal'deki PUBLIC_KEY ile karşılaştırıp ona göre
    // mesaj ekranında sol ya da sağ hizalama yapalım.
    var sp = await SharedPreferences.getInstance();
    String pub = sp.getString("pub")!;
    String id = sp.getString("id")!;
    // result: şifrelenmiş data
    String? result = Cryptom(pub, id).text(data);

    var response = await http.post(
      Uri.parse('${this.URL}/$link'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{"id": id, "data": result},
      ),
    );
    //print(response.body);
    return response;
  }
}

class Cryptom {
  String pub;
  String id;

  Cryptom(this.pub, this.id);

  String encrypt(String plaintext, String publicKey) {
    var public = CryptoUtils.rsaPublicKeyFromPem(publicKey);

    /// Initalizing Cipher
    var cipher = OAEPEncoding(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(public));

    /// Converting into a [Unit8List] from List<int>
    /// Then Encoding into Base64
    Uint8List output =
        cipher.process(Uint8List.fromList(utf8.encode(plaintext)));
    var base64EncodedText = base64Encode(output);
    return base64EncodedText;
  }

  String text(String text) {
    return encrypt(text, pub);
  }
}
