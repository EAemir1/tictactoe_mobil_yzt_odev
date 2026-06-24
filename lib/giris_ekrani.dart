import 'package:flutter/material.dart';
import 'gecmis_oyun.dart';
import 'oyun_ekrani.dart';
import 'zorluk.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  GirisEkraniAdimi _aktifAdim = GirisEkraniAdimi.anaMenu;
  final TextEditingController _p1Controller = TextEditingController(text: 'Oyuncu 1');
  final TextEditingController _p2Controller = TextEditingController(text: 'Oyuncu 2');

  @override
  void dispose() {
    _p1Controller.dispose();
    _p2Controller.dispose();
    super.dispose();
  }

  void _oyunuBaslat(Zorluk? zorluk, String p1Name, String p2Name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OyunEkrani(
          zorluk: zorluk,
          oyuncu1Adi: p1Name,
          oyuncu2Adi: p2Name,
        ),
      ),
    ).then((_) {
      // Oyun ekranından geri dönüldüğünde geçmiş listesini güncellemek için setState tetikle
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AyarlarVerisi.darkMode
              ? const LinearGradient(
                  colors: [Color(0xFF080808), Color(0xFF121212), Color(0xFF181818)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32.0, // accounting for vertical padding
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: AyarlarVerisi.darkMode
                                ? [Colors.white, Colors.grey.shade400]
                                : [Colors.cyanAccent, Colors.purpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Text(
                            'TIC-TAC-TOE',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axisAlignment: 0.0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: _buildAktifAdim(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAktifAdim() {
    switch (_aktifAdim) {
      case GirisEkraniAdimi.anaMenu:
        return _buildAnaMenu();
      case GirisEkraniAdimi.modSecimi:
        return _buildModSecimi();
      case GirisEkraniAdimi.zorlukSecimi:
        return _buildZorlukSecimi();
      case GirisEkraniAdimi.isimGirisi:
        return _buildIsimGirisi();
      case GirisEkraniAdimi.oyunGecmisi:
        return _buildOyunGecmisi();
      case GirisEkraniAdimi.ayarlar:
        return _buildAyarlar();
    }
  }

  Widget _buildAnaMenu() {
    final isDark = AyarlarVerisi.darkMode;
    return Column(
      key: const ValueKey('anaMenu'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.modSecimi;
            });
          },
          style: ElevatedButton.styleFrom(
            elevation: 17,
            shadowColor: isDark ? Colors.black54 : Colors.lime.shade700,
            backgroundColor: isDark ? const Color(0xFF222222) : Colors.yellowAccent.shade400,
            minimumSize: const Size(220, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: isDark ? const BorderSide(color: Colors.white24, width: 1.5) : BorderSide.none,
            ),
          ),
          child: Text(
            'OYNA',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.oyunGecmisi;
            });
          },
          style: ElevatedButton.styleFrom(
            elevation: 17,
            shadowColor: isDark ? Colors.black54 : Colors.purple.shade700,
            backgroundColor: isDark ? const Color(0xFF2E2E2E) : const Color.fromARGB(255, 116, 92, 249),
            minimumSize: const Size(220, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: isDark ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
            ),
          ),
          child: const Text(
            'OYUN GEÇMİŞİ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.ayarlar;
            });
          },
          style: ElevatedButton.styleFrom(
            elevation: 17,
            shadowColor: isDark ? Colors.black54 : Colors.teal.shade700,
            backgroundColor: isDark ? const Color(0xFF1C1C1C) : const Color.fromARGB(255, 80, 168, 179),
            minimumSize: const Size(220, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: isDark ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
            ),
          ),
          child: const Text(
            'AYARLAR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModSecimi() {
    final isDark = AyarlarVerisi.darkMode;
    return Column(
      key: const ValueKey('modSecimi'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark ? [Colors.white, Colors.grey] : [Colors.yellowAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'MOD SEÇ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.zorlukSecimi;
            });
          },
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shadowColor: isDark ? Colors.black54 : Colors.cyan.shade900,
            backgroundColor: isDark ? const Color(0xFF222222) : Colors.cyanAccent.shade400,
            minimumSize: const Size(220, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isDark ? const BorderSide(color: Colors.white24, width: 1.5) : BorderSide.none,
            ),
          ),
          child: Text(
            'YAPAY ZEKAYA KARŞI',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.isimGirisi;
            });
          },
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shadowColor: isDark ? Colors.black54 : Colors.purple.shade900,
            backgroundColor: isDark ? const Color(0xFF2E2E2E) : Colors.purpleAccent.shade400,
            minimumSize: const Size(220, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isDark ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
            ),
          ),
          child: const Text(
            'İKİ KİŞİLİK (PVP)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.anaMenu;
            });
          },
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          label: const Text(
            'Geri Dön',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZorlukSecimi() {
    final isDark = AyarlarVerisi.darkMode;
    return Column(
      key: const ValueKey('zorlukSecimi'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark ? [Colors.white, Colors.grey] : [Colors.yellowAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'ZORLUK SEÇ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _oyunuBaslat(Zorluk.kolay, 'Oyuncu 1', 'Yapay Zeka'),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shadowColor: isDark ? Colors.black54 : Colors.green.shade800,
            backgroundColor: isDark ? const Color(0xFF222222) : Colors.greenAccent.shade400,
            minimumSize: const Size(220, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isDark ? const BorderSide(color: Colors.white24, width: 1.5) : BorderSide.none,
            ),
          ),
          child: Text(
            'KOLAY',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => _oyunuBaslat(Zorluk.orta, 'Oyuncu 1', 'Yapay Zeka'),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shadowColor: isDark ? Colors.black54 : Colors.orange.shade900,
            backgroundColor: isDark ? const Color(0xFF2E2E2E) : Colors.orangeAccent.shade400,
            minimumSize: const Size(220, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isDark ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
            ),
          ),
          child: const Text(
            'ORTA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => _oyunuBaslat(Zorluk.zor, 'Oyuncu 1', 'Yapay Zeka'),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shadowColor: isDark ? Colors.black54 : Colors.red.shade900,
            backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.redAccent.shade700,
            minimumSize: const Size(220, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isDark ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
            ),
          ),
          child: const Text(
            'ZOR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.modSecimi;
            });
          },
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          label: const Text(
            'Geri Dön',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIsimGirisi() {
    final isDark = AyarlarVerisi.darkMode;
    return Column(
      key: const ValueKey('isimGirisi'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark ? [Colors.white, Colors.grey] : [Colors.yellowAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'OYUNCU İSİMLERİ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 25),
        // Oyuncu 1 (X)
        Container(
          width: 260,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: TextField(
            controller: _p1Controller,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Oyuncu 1 (X)',
              labelStyle: TextStyle(color: isDark ? Colors.grey : Colors.cyanAccent),
              prefixIcon: Icon(Icons.person, color: isDark ? Colors.grey : Colors.cyanAccent),
              filled: true,
              fillColor: isDark ? const Color(0xFF121212) : const Color(0xFF1A3038),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.cyan, width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: isDark ? Colors.white : Colors.purpleAccent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        // Oyuncu 2 (O)
        Container(
          width: 260,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: TextField(
            controller: _p2Controller,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Oyuncu 2 (O)',
              labelStyle: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.purpleAccent),
              prefixIcon: Icon(Icons.person_outline, color: isDark ? Colors.grey.shade600 : Colors.purpleAccent),
              filled: true,
              fillColor: isDark ? const Color(0xFF121212) : const Color(0xFF1A3038),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.purple, width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: isDark ? Colors.white : Colors.cyanAccent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () {
            String name1 = _p1Controller.text.trim();
            String name2 = _p2Controller.text.trim();
            if (name1.isEmpty) name1 = 'Oyuncu 1';
            if (name2.isEmpty) name2 = 'Oyuncu 2';
            _oyunuBaslat(null, name1, name2);
          },
          style: ElevatedButton.styleFrom(
            elevation: 17,
            shadowColor: isDark ? Colors.black54 : Colors.lime.shade700,
            backgroundColor: isDark ? const Color(0xFF222222) : Colors.yellowAccent.shade400,
            minimumSize: const Size(220, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: isDark ? const BorderSide(color: Colors.white24, width: 1.5) : BorderSide.none,
            ),
          ),
          child: Text(
            'OYUNU BAŞLAT',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.modSecimi;
            });
          },
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          label: const Text(
            'Geri Dön',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOyunGecmisi() {
    final isDark = AyarlarVerisi.darkMode;
    return Column(
      key: const ValueKey('oyunGecmisi'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark ? [Colors.white, Colors.grey] : [Colors.yellowAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'OYUN GEÇMİŞİ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        OyunVerisi.gecmis.isEmpty
            ? const SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    'Henüz kayıtlı oyun yok.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            : Container(
                constraints: const BoxConstraints(maxHeight: 300),
                width: 280,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: OyunVerisi.gecmis.length,
                  itemBuilder: (context, index) {
                    final oyun = OyunVerisi.gecmis[OyunVerisi.gecmis.length - 1 - index];
                    final tarihFormat = '${oyun.tarih.day.toString().padLeft(2, '0')}.'
                        '${oyun.tarih.month.toString().padLeft(2, '0')}.'
                        '${oyun.tarih.year} '
                        '${oyun.tarih.hour.toString().padLeft(2, '0')}:'
                        '${oyun.tarih.minute.toString().padLeft(2, '0')}';
                    return Card(
                      color: isDark ? const Color(0xFF121212) : const Color(0xFF1A3038),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.cyan, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tarihFormat,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.yellowAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  oyun.oyuncu1,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  '${oyun.oyuncu1Skor}',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.cyanAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  oyun.oyuncu2,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  '${oyun.oyuncu2Skor}',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade400 : Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            if (oyun.beraberlik > 0) ...[
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Beraberlik',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    '${oyun.beraberlik}',
                                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.anaMenu;
            });
          },
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          label: const Text(
            'Geri Dön',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAyarlar() {
    final isDark = AyarlarVerisi.darkMode;
    return Column(
      key: const ValueKey('ayarlar'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark ? [Colors.white, Colors.grey] : [Colors.yellowAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'AYARLAR',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Karanlık Mod Switch
        Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : const Color(0xFF1A3038),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.cyan.shade600,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Karanlık Mod',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    AyarlarVerisi.darkMode ? 'Açık' : 'Kapalı',
                    style: TextStyle(
                      color: AyarlarVerisi.darkMode ? Colors.greenAccent.shade400 : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: AyarlarVerisi.darkMode,
                    activeTrackColor: const Color(0x6669F0AE),
                    activeThumbColor: Colors.greenAccent.shade400,
                    onChanged: (value) {
                      setState(() {
                        AyarlarVerisi.darkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Titreşim Switch
        Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : const Color(0xFF1A3038),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.cyan.shade600,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Titreşim',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    AyarlarVerisi.titresim ? 'Açık' : 'Kapalı',
                    style: TextStyle(
                      color: AyarlarVerisi.titresim ? Colors.greenAccent.shade400 : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: AyarlarVerisi.titresim,
                    activeTrackColor: const Color(0x6669F0AE),
                    activeThumbColor: Colors.greenAccent.shade400,
                    onChanged: (value) {
                      setState(() {
                        AyarlarVerisi.titresim = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Ses Switch
        Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : const Color(0xFF1A3038),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.cyan.shade600,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ses',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    AyarlarVerisi.ses ? 'Açık' : 'Kapalı',
                    style: TextStyle(
                      color: AyarlarVerisi.ses ? Colors.greenAccent.shade400 : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: AyarlarVerisi.ses,
                    activeTrackColor: const Color(0x6669F0AE),
                    activeThumbColor: Colors.greenAccent.shade400,
                    onChanged: (value) {
                      setState(() {
                        AyarlarVerisi.ses = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _aktifAdim = GirisEkraniAdimi.anaMenu;
            });
          },
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          label: const Text(
            'Geri Dön',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
