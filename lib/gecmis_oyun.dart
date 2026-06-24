class GecmisOyun {
  final DateTime tarih;
  final String oyuncu1;
  final String oyuncu2;
  final int oyuncu1Skor;
  final int oyuncu2Skor;
  final int beraberlik;

  GecmisOyun({
    required this.tarih,
    required this.oyuncu1,
    required this.oyuncu2,
    required this.oyuncu1Skor,
    required this.oyuncu2Skor,
    required this.beraberlik,
  });
}

class OyunVerisi {
  static final List<GecmisOyun> gecmis = [];
}

class AyarlarVerisi {
  static bool darkMode = false;
  static bool titresim = true;
  static bool ses = true;
}
