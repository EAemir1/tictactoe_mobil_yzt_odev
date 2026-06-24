import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'gecmis_oyun.dart';
import 'zorluk.dart';

class OyunEkrani extends StatefulWidget {
  final Zorluk? zorluk;
  final String oyuncu1Adi;
  final String oyuncu2Adi;

  const OyunEkrani({
    super.key,
    this.zorluk,
    required this.oyuncu1Adi,
    required this.oyuncu2Adi,
  });

  @override
  State<OyunEkrani> createState() => _OyunEkraniState();
}

class _OyunEkraniState extends State<OyunEkrani> {
  List<String> tahta = List.filled(9, '');
  final List<AudioPlayer> _players = List.generate(4, (_) => AudioPlayer());
  int _currentPlayerIndex = 0;
  List<int>? kazananKombinasyon;

  String get _zorlukMetni {
    if (widget.zorluk == null) {
      return 'İKİ KİŞİLİK';
    }
    switch (widget.zorluk!) {
      case Zorluk.kolay:
        return 'KOLAY';
      case Zorluk.orta:
        return 'ORTA';
      case Zorluk.zor:
        return 'ZOR';
    }
  }

  // Sıradaki oyuncu (X: İnsan, O: Yapay Zeka veya 2. Oyuncu)
  String mevcutOyuncu = 'X';

  bool oyunBitti = false;
  late String skorMesaji;

  // Oturum bazlı skor takibi
  int oyuncu1Skor = 0;
  int oyuncu2Skor = 0;
  int beraberlik = 0;
  String? sonKazanan;
  bool _gecmisKaydedildi = false;

  void _kaydetGecmis() {
    if (widget.zorluk == null && !_gecmisKaydedildi) {
      if (oyuncu1Skor > 0 || oyuncu2Skor > 0 || beraberlik > 0) {
        OyunVerisi.gecmis.add(
          GecmisOyun(
            tarih: DateTime.now(),
            oyuncu1: widget.oyuncu1Adi,
            oyuncu2: widget.oyuncu2Adi,
            oyuncu1Skor: oyuncu1Skor,
            oyuncu2Skor: oyuncu2Skor,
            beraberlik: beraberlik,
          ),
        );
        _gecmisKaydedildi = true;
      }
    }
  }

  void _aktifSkorlariGoster() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A3038),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        title: const Center(
          child: Text(
            'AKTİF SKORLAR',
            style: TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.oyuncu1Adi,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$oyuncu1Skor',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.oyuncu2Adi,
                  style: const TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$oyuncu2Skor',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Beraberlik',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  '$beraberlik',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Kapat',
              style: TextStyle(color: Colors.cyanAccent, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    skorMesaji = '${widget.oyuncu1Adi} Sırası...🫵 (X)';

    // Mobil cihazlarda sesin sessiz/titreşim modunda dahi hoparlörden çalmasını sağlar
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: const {},
      ),
      android: const AudioContextAndroid(
        isSpeakerphoneOn: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);
  }

  @override
  void dispose() {
    for (var player in _players) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _kaydetGecmis();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          //Yazıya gradient ekleyerek daha güzel bir renk kullanabilmek için title yi shaderMask icine almak gerekiyormus onu yaptim
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: AyarlarVerisi.darkMode
                  ? [Colors.white, Colors.grey.shade400]
                  : [Colors.cyanAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            //text ve ozelliklerini yazdım burasıda shadermaskın içinde oluyor
            child: MarqueeText(
              child: Text(
                'TIC-TAC-TOE - $_zorlukMetni',
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          //burayı app barın en sağına icon eklemek için yazdım
          //icon icin assets klasorunde icons klasoru actım
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
              ), // Sağ kenardan boşluk
              child: Image.asset(
                'assets/icons/three-in-a-row.png',
                width: 49.0,
                height: 49.0,
              ),
            ),
          ],

          //app barın arkaplana yine geçiş efekti gradient yapmak için burda arkaplanı transparan yapmam gerekiyormus, bide app barın altına da golge ekledim
          backgroundColor: Colors.transparent,
          elevation: 15,
          shadowColor: const Color.fromARGB(255, 116, 92, 249),

          //gradient için flexibleSpace kullandım arkaplanı tamamen kaplayan ozel bir alan gibi birseymis bunun uzerine yaptım gradienti
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AyarlarVerisi.darkMode
                  ? const LinearGradient(
                      colors: [Color(0xFF050505), Color(0xFF101010)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 71, 4, 119), // En koyu ton
                        Color.fromARGB(255, 1, 32, 47), // Geçiş tonu
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
          ),
        ),

        //yine arkaplan icin renk islemleri, bodynin arkaplanı
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AyarlarVerisi.darkMode
                ? const LinearGradient(
                    colors: [
                      Color(0xFF080808),
                      Color(0xFF121212),
                      Color(0xFF181818),
                    ],
                    begin: AlignmentGeometry.topCenter,
                    end: AlignmentGeometry.bottomRight,
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    begin: AlignmentGeometry.topCenter,
                    end: AlignmentGeometry.bottomRight,
                  ),
          ),

          //Skor mesajina atadigimiz degeri gosterecek
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                skorMesaji,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 80, 168, 179),
                ),
              ),
              if (oyunBitti && sonKazanan != null) ...[
                const SizedBox(height: 8),
                Text(
                  '$sonKazanan 1 puan kazandı!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.limeAccent,
                  ),
                ),
              ],
              const SizedBox(height: 25),

              oyunTahtasiOlustur(),

              const SizedBox(height: 30),

              // Sıfırlama ve Skorlar Butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: oyunuSifirla,
                    style: ElevatedButton.styleFrom(
                      elevation: 17,
                      shadowColor: AyarlarVerisi.darkMode
                          ? Colors.black54
                          : Colors.lime.shade700,
                      backgroundColor: AyarlarVerisi.darkMode
                          ? const Color(0xFF222222)
                          : Colors.yellowAccent.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: AyarlarVerisi.darkMode
                            ? const BorderSide(
                                color: Colors.white24,
                                width: 1.5,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Text(
                      'Yeniden Başlat',
                      style: TextStyle(
                        color: AyarlarVerisi.darkMode
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _aktifSkorlariGoster,
                    style: ElevatedButton.styleFrom(
                      elevation: 17,
                      shadowColor: AyarlarVerisi.darkMode
                          ? Colors.black54
                          : Colors.cyan.shade700,
                      backgroundColor: AyarlarVerisi.darkMode
                          ? const Color(0xFF2E2E2E)
                          : Colors.cyanAccent.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: AyarlarVerisi.darkMode
                            ? const BorderSide(color: Colors.white10, width: 1)
                            : BorderSide.none,
                      ),
                    ),
                    child: Text(
                      'Skorlar',
                      style: TextStyle(
                        color: AyarlarVerisi.darkMode
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //tahta değişkenindeki yani list deki elemanları sifirlayan fonksiyon
  //yeniden baslat butonuna tıylayınca bu caliscak yani onpressed: oyunuSifirla, bunu yukarda elevatedbutonun icinde yazdım
  void oyunuSifirla() {
    setState(() {
      tahta = List.filled(9, '');
      mevcutOyuncu = 'X';
      oyunBitti = false;
      skorMesaji = '${widget.oyuncu1Adi} Sırası...🫵 (X)';
      sonKazanan = null;
      kazananKombinasyon = null;
    });
  }

  //yatay dikey ve capraz da bulan kazanır
  String? kazananiKontrolEt(List<String> tahtaDurumu) {
    var kazanmaDurumlari = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Satırlar
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Sütunlar
      [0, 4, 8], [2, 4, 6], // Çaprazlar
    ];

    for (var durum in kazanmaDurumlari) {
      if (tahtaDurumu[durum[0]] !=
              '' && //kontrol edilen ilk kare bos olmamalı dedik cunku hepsi bos olursa yan yana 3 tane aynısı var kazandi der diye, illa biri dolu olcak ynai
          tahtaDurumu[durum[0]] ==
              tahtaDurumu[durum[1]] && //ilk kare yani sifirinci indis ile birinci aynı mi kontrol et
          tahtaDurumu[durum[1]] ==
              tahtaDurumu[durum[2]] //1.indisle 2.indis kontrol et
              ) {
        //yani bu if in içinde yapılan 1.karedekiyle 2.karedeki aynı mı ve 2.karedekiyle 3. karede ki aynı mı kontrol et yani ya xxx yada ooo, aynıysa kazandırn.

        return tahtaDurumu[durum[0]]; //kzzanani döndür ('X' veya 'O')
      }
    }

    //tahtada boş yer kalmadıysa ve kazanan yoksa beraberliktir
    if (!tahtaDurumu.contains('')) {
      return 'Berabere';
    }

    //oyun hala devam ediyorsa
    return null;
  }

  Widget oyunTahtasiOlustur() {
    return Container(
      //her yerden 20 birim boslıuk birak
      padding: const EdgeInsets.all(20.0),
      //ekran genişliğine göre tahtanın kare kalması
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GridView.builder(
            //toplam 9 kare olacak
            itemCount: 9,
            //kaydırma özelliğini kapatıyoruz, sabit durmalı
            //kutularin kenarlarından kaydırırsak golge efekti gibi birsey geliyor o gelmemesi icin
            physics: const NeverScrollableScrollPhysics(),
            // 3 sütunlu bir ızgara yapısı kuruyoruz
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  3, //3 tane yan yana koy sonrakini asagiya koy demek
              crossAxisSpacing: 8.0, //Kareler arası yatay boşluk
              mainAxisSpacing: 8.0, //kareler arası dikey boşluk
            ),
            itemBuilder: (context, index) {
              //dokununca algılasın
              return GestureDetector(
                onTap: () => hamleYap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: AyarlarVerisi.darkMode
                        ? const Color(0xFF121212)
                        : const Color.fromARGB(255, 24, 49, 65),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AyarlarVerisi.darkMode
                          ? Colors.grey.shade800
                          : const Color.fromARGB(255, 22, 19, 227),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tahta[index], // 'X', 'O' veya ''
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        //X e yani oynayan kişiye mavi yapay zekaya yani O ya kırmızı rengi verdim
                        color: tahta[index] == 'X' ? Colors.blue : Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (oyunBitti && kazananKombinasyon != null)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: KazanmaCizgisiPainter(
                    kombinasyon: kazananKombinasyon!,
                    sembol: tahta[kazananKombinasyon!.first],
                    isDarkMode: AyarlarVerisi.darkMode,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _uzunTitret() async {
    for (int i = 0; i < 4; i++) {
      HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  void hamleYap(int index) {
    //zaten dolu olan bir kareye yada oyun bitince herhangi bir kareye dokunmak isterse hiçbisey yapma degistirme
    if (tahta[index] == '' && !oyunBitti) {
      if (AyarlarVerisi.ses) {
        final player = _players[_currentPlayerIndex];
        player.stop();
        player.play(AssetSource('sounds/tap.mp3'));
        _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
      }

      setState(() {
        tahta[index] = mevcutOyuncu;

        String? kazanan = kazananiKontrolEt(tahta); //oyun bitti mi kontrol et

        //kazanan değeri boş değilse oyunBitti yi true yap
        if (kazanan != null) {
          oyunBitti = true;
          if (AyarlarVerisi.titresim) {
            _uzunTitret();
          }
          if (kazanan == 'Berabere') {
            skorMesaji = 'Oyun Berabere Bitti!';
            beraberlik++;
            sonKazanan = null;
          } else {
            // Neon şerit için kazanan kombinasyonu bul
            var kazanmaDurumlari = [
              [0, 1, 2], [3, 4, 5], [6, 7, 8], // Satırlar
              [0, 3, 6], [1, 4, 7], [2, 5, 8], // Sütunlar
              [0, 4, 8], [2, 4, 6], // Çaprazlar
            ];
            for (var durum in kazanmaDurumlari) {
              if (tahta[durum[0]] == kazanan &&
                  tahta[durum[1]] == kazanan &&
                  tahta[durum[2]] == kazanan) {
                kazananKombinasyon = durum;
                break;
              }
            }

            if (kazanan == 'X') {
              skorMesaji = '${widget.oyuncu1Adi} Kazandı! 🎉';
              oyuncu1Skor++;
              sonKazanan = widget.oyuncu1Adi;
            } else {
              skorMesaji = '${widget.oyuncu2Adi} Kazandı! 🎉';
              oyuncu2Skor++;
              sonKazanan = widget.oyuncu2Adi;
            }
          }
        } else {
          //oyun bitmediyse sırayı diğer oyuncuya geçirmek için, yani mevcut oyuncu x ise o yap değilse x
          mevcutOyuncu = mevcutOyuncu == 'X' ? 'O' : 'X';

          //sıra O oyuncusundaysa:
          if (mevcutOyuncu == 'O') {
            if (widget.zorluk != null) {
              // Yapay zeka modu
              skorMesaji = '${widget.oyuncu2Adi} Düşünüyor...⌛ (O)';
              Future.delayed(const Duration(milliseconds: 250), () {
                if (mounted) {
                  yapayZekaHamlesi();
                }
              });
            } else {
              // İki kişilik mod (diğer insan oyuncunun sırası)
              skorMesaji = '${widget.oyuncu2Adi} Sırası...🫵 (O)';
            }
            //sıra X oyuncusundaysa:
          } else {
            skorMesaji = '${widget.oyuncu1Adi} Sırası...🫵 (X)';
          }
        }
      });
    }
  }

  //yapay zeka kısmı: tahtadaki bos karelere göre her birini x ve o koyarak oyunun sonuna gider, her bitişte puan verrir ve her zaman en iyi hamleyi yapar
  int minimax(
    List<String> tahtaKopyasi, //tahtanın o anki durumu
    int
    derinlik, //algoriymanın o ana kadar kac hamle ilerisini hesapladıgını tutar
    bool
    isMaximizing, //siranin kimde oldugudur, true ise yapayzeka(paunı maximize etmeye calısır), false ise kullanıcı(minimize etmeye calısır).
    int alpha,
    int beta,
  ) {
    String? sonuc = kazananiKontrolEt(tahtaKopyasi);

    //algoritmanın değerlendirme (heuristic) kısmı
    if (sonuc == 'O') {
      return 10 - derinlik; //yapay zeka kazanıyorsa yüksek puan
    }
    if (sonuc == 'X') {
      return -10 + derinlik; //insan kazanıyorsa düşük (eksi) puan
    }
    if (sonuc == 'Berabere') {
      return 0; //Beraberlik nötr durum
    }

    // Orta zorluk için arama derinliği sınırı (2 adım sonrasına kadar bakar)
    if (widget.zorluk == Zorluk.orta && derinlik >= 2) {
      return 0;
    }

    if (isMaximizing) {
      // Yapay Zekanın (O) sırası: (Maksimize etmeye çalışır)
      int maxDeger = -9999; //baslangıcda en kotu sokru baz alır
      for (int i = 0; i < 9; i++) {
        if (tahtaKopyasi[i] == '') {
          tahtaKopyasi[i] = 'O'; //hamleyi dene
          int deger = minimax(tahtaKopyasi, derinlik + 1, false, alpha, beta);
          tahtaKopyasi[i] = ''; //Hamleyi geri al (backtrack)

          if (deger > maxDeger) maxDeger = deger;
          if (maxDeger > alpha) alpha = maxDeger;
          if (beta <= alpha) break; //   Beta budaması
        }
      }
      return maxDeger;
    } else {
      // İnsanın (X) sırası:(Minimize etmeye çalışır)
      int minDeger =
          9999; //yapay zeka her zaman rakibin mukemmel oynayacagını varsayar
      for (int i = 0; i < 9; i++) {
        if (tahtaKopyasi[i] == '') {
          tahtaKopyasi[i] = 'X'; // Hamleyi dene
          int deger = minimax(tahtaKopyasi, derinlik + 1, true, alpha, beta);
          tahtaKopyasi[i] = ''; //Hamleyi geri al

          if (deger < minDeger) minDeger = deger;
          if (minDeger < beta) beta = minDeger;
          if (beta <= alpha) break; // Alpha budaması
        }
      }
      return minDeger;
    }
  }

  //en iyi hamleyi bulma....................................
  void yapayZekaHamlesi() {
    // Kolay zorluk: Tamamen rastgele bir boş kare seçer
    if (widget.zorluk == Zorluk.kolay) {
      List<int> bosKareler = [];
      for (int i = 0; i < 9; i++) {
        if (tahta[i] == '') {
          bosKareler.add(i);
        }
      }
      if (bosKareler.isNotEmpty) {
        final rastgeleIndex = Random().nextInt(bosKareler.length);
        hamleYap(bosKareler[rastgeleIndex]);
      }
      return;
    }

    // Orta ve Zor zorluk: Minimax kullanır (Orta seviyede derinlik 2 ile sınırlıdır)
    int enIyiSkor = -9999;
    List<int> enIyiHamleler = [];

    //tüm boş kareleri tek tek dene ve minimax ile puanını hesapla
    for (int i = 0; i < 9; i++) {
      //sadece içi bos olanlar
      if (tahta[i] == '') {
        //hayali olarak oraya O yu koyar ve buraya koyarsam ne olur diye dusunur
        tahta[i] = 'O';

        //skoru minimax a gonderir
        // 0 derinlik, false de sıra kullanıcı da demek ve -9999 ve 9999 başlangıç alpha/beta değerleridir
        int skor = minimax(tahta, 0, false, -9999, 9999);

        //skor ogrenildikten sonra hayali olarak konulan O degerini sil
        tahta[i] = '';

        // en iyi hamleyi hafızda tutmak için
        if (skor > enIyiSkor) {
          enIyiSkor = skor;
          enIyiHamleler = [i];
        } else if (skor == enIyiSkor) {
          enIyiHamleler.add(i);
        }
      }
    }

    // Bulunan en iyi hamlelerden rastgele birini yap (daha doğal oynaması için)
    if (enIyiHamleler.isNotEmpty) {
      int secilenHamle = enIyiHamleler[Random().nextInt(enIyiHamleler.length)];
      hamleYap(secilenHamle); //eniyihamleyi hamleYap a gonderir
    }
  }
}

class KazanmaCizgisiPainter extends CustomPainter {
  final List<int> kombinasyon;
  final String sembol;
  final bool isDarkMode;

  KazanmaCizgisiPainter({
    required this.kombinasyon,
    required this.sembol,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (kombinasyon.length < 3) return;

    final double cellW = size.width / 3;
    final double cellH = size.height / 3;

    // Başlangıç ve bitiş karelerinin koordinatları
    final int startIdx = kombinasyon.first;
    final int endIdx = kombinasyon.last;

    final double startX = (startIdx % 3) * cellW + (cellW / 2);
    final double startY = (startIdx ~/ 3) * cellH + (cellH / 2);

    final double endX = (endIdx % 3) * cellW + (cellW / 2);
    final double endY = (endIdx ~/ 3) * cellH + (cellH / 2);

    final Offset start = Offset(startX, startY);
    final Offset end = Offset(endX, endY);

    // Renkleri belirle
    Color glowColor;
    Color coreColor;

    if (sembol == 'X') {
      glowColor = isDarkMode
          ? const Color(0xFF00E5FF)
          : const Color(0xFF2979FF); // Turkuaz/Mavi neon
      coreColor = Colors.white;
    } else {
      glowColor = isDarkMode
          ? const Color(0xFFFF1744)
          : const Color(0xFFD500F9); // Kırmızı/Pembe neon
      coreColor = Colors.white;
    }

    // 1. Dış Glow (Geniş Bulanık Çizgi)
    final Paint glowPaint = Paint()
      ..color = glowColor.withAlpha((0.7 * 255).round())
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    // 2. Orta Glow (Daha Dar Bulanık Çizgi)
    final Paint midGlowPaint = Paint()
      ..color = glowColor
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    // 3. İç Çekirdek (Parlak Beyaz/Açık Çizgi)
    final Paint corePaint = Paint()
      ..color = coreColor
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, glowPaint);
    canvas.drawLine(start, end, midGlowPaint);
    canvas.drawLine(start, end, corePaint);
  }

  @override
  bool shouldRepaint(covariant KazanmaCizgisiPainter oldDelegate) {
    return oldDelegate.kombinasyon != kombinasyon ||
        oldDelegate.sembol != sembol ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}

class MarqueeText extends StatefulWidget {
  final Widget child;

  const MarqueeText({
    super.key,
    required this.child,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late ScrollController _scrollController;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _running = false;
    _scrollController.dispose();
    super.dispose();
  }

  void _startAnimation() async {
    _running = true;
    while (_running) {
      // Başlangıçta 2 saniye bekle
      await Future.delayed(const Duration(seconds: 2));
      if (!_running) return;

      if (_scrollController.hasClients) {
        final double maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          // Metin sığmıyor ve kaydırılabilir, sola kaydır
          final duration = Duration(milliseconds: (maxScroll * 45).round());
          await _scrollController.animateTo(
            maxScroll,
            duration: duration,
            curve: Curves.linear,
          );
          
          // Sola ulaştıktan sonra 2 saniye bekle
          await Future.delayed(const Duration(seconds: 2));
          if (!_running) return;

          // Sağa geri kaydır
          await _scrollController.animateTo(
            0.0,
            duration: duration,
            curve: Curves.linear,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(), // Kullanıcı manuel kaydıramasın
      child: widget.child,
    );
  }
}
