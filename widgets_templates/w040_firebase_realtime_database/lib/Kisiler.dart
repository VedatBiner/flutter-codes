class Kisiler {
  String kisi_ad;
  int kisi_yas;

  Kisiler(this.kisi_ad, this.kisi_yas);

  //key ve value dynamic olmalıdır.
  factory Kisiler.fromJson(Map<dynamic, dynamic> json) {
    return Kisiler(json["kisi_ad"] as String,json["kisi_yas"] as int);
  }

}

