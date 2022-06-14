class Mesaj {
  String id;
  String gonderici_id;
  String alici_id;
  String mesaj;
  String tarih;

  Mesaj(this.id, this.gonderici_id, this.alici_id, this.mesaj, this.tarih);

  factory Mesaj.fromJson(Map<String, dynamic> json) {
    return Mesaj(
      json["id"],
      json["gonderici_id"],
      json["alici_id"],
      json["mesaj"],
      json["tarih"],
    );
  }
}
