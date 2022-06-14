class ChatListesi {
  String id;
  String username;

  ChatListesi(this.id, this.username);

  factory ChatListesi.fromJson(Map<String, dynamic> json) {
    return ChatListesi(
      json["id"] as String,
      json["username"] as String,
    );
  }
}
