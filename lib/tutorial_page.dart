// lib/tutorial_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const kBrand = Color(0xFF2F5B89);

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final TextEditingController _search = TextEditingController();

  final List<_TutItem> _all = const [
    _TutItem(title: 'Anatomy of the skeleton', url: 'https://youtu.be/uBGl2BujkPQ?si=yBmN3XWJGCNxtqJs'),
    _TutItem(title: 'Open abdominal surgery', url: 'https://youtu.be/NHECopO6L3g?si=EoeesWm3veFC9FKr'),
    _TutItem(title: 'Surgical infections', url: 'https://youtu.be/rDGqkMHPDqE?si=E34JS4fMFZlXoCLc'),
    _TutItem(title: 'Head and neck surgery', url: 'https://youtu.be/jU9w6w8LwqM?si=lxp1S34DaW3f1XiA'),
    _TutItem(title: 'Cardiac Surgery', url: 'https://youtu.be/I7orwMgTQ5I?si=QYjf8pFXN280Y4x-'),
    _TutItem(title: 'Neurosurgery basics', url: 'https://youtu.be/yIoTRGfcMqM?si=yNXllIBLQEUnPHX1'),
    _TutItem(title: 'Pediatric Surgery', url: 'https://youtu.be/JNTOahIeCfA?si=tjq4pEM66cvZbP60'),
    _TutItem(title: 'Heart Anatomy & Physiology', url: 'https://youtu.be/Ae4MadKPJC0?si=ysjOsJqaeIY5dJWw'),
  ];

  String _q = '';
  final Set<String> _fav = {};

  @override
  Widget build(BuildContext context) {
    final items = _all.where((e) => e.title.toLowerCase().contains(_q.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            const _TopBrandBar(),
            const SizedBox(height: 6),
            const Center(
              child: Text('Tutorial', style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 10),

            // Search
            TextField(
              controller: _search,
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon: const Icon(Icons.tune_rounded, color: Colors.black54),
                filled: true,
                fillColor: const Color(0xFFF4F6F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: _b(const Color(0xFFE1E4EA)),
                enabledBorder: _b(const Color(0xFFE1E4EA)),
                focusedBorder: _b(kBrand),
              ),
            ),
            const SizedBox(height: 12),

            // List
            for (final t in items)
              _TutorialCard(
                title: t.title,
                url: t.url,
                thumbnailUrl: _youtubeThumb(t.url),
                isFav: _fav.contains(t.title),
                onFavToggle: () {
                  setState(() {
                    if (_fav.contains(t.title)) {
                      _fav.remove(t.title);
                    } else {
                      _fav.add(t.title);
                    }
                  });
                },
                onTap: () async {
                  final uri = Uri.parse(t.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: c, width: 1.2),
  );

  // ===== Helpers =====

  // يستخرج Video ID من رابط يوتيوب (قصير أو طويل) ويرجع صورة المصغّر
  static String _youtubeThumb(String url) {
    final id = _youtubeId(url);
    if (id == null) return '';
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }

  static String? _youtubeId(String url) {
    // يدعم youtu.be/XXXX و watch?v=XXXX وحتى embed/XXXX
    final regex = RegExp(r'(?:v=|\/)([0-9A-Za-z_-]{11})(?:[?&]|$)');
    final m = regex.firstMatch(url);
    if (m != null && m.groupCount >= 1) return m.group(1);
    return null;
  }
}

class _TutItem {
  final String title;
  final String url;
  const _TutItem({required this.title, required this.url});
}

class _TutorialCard extends StatelessWidget {
  final String title;
  final String url;
  final String thumbnailUrl;
  final bool isFav;
  final VoidCallback onFavToggle;
  final VoidCallback onTap;

  const _TutorialCard({
    super.key,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.isFav,
    required this.onFavToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasThumb = thumbnailUrl.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        elevation: 2.5,
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Thumbnail مع زر تشغيل فوقه
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 86,
                        height: 64,
                        color: const Color(0xFFE8F1FF),
                        child: hasThumb
                            ? Image.network(thumbnailUrl, width: 86, height: 64, fit: BoxFit.cover)
                            : const Icon(Icons.play_circle_fill, size: 40, color: kBrand),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow_rounded, color: kBrand, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onFavToggle,
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.black45),
                  tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBrandBar extends StatelessWidget {
  const _TopBrandBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(height: 70, width: double.infinity, child: CustomPaint(painter: _HeaderShapePainter())),
        Row(
          children: const [
            BackButton(color: Colors.black87),
            Spacer(),
            Text(
              "VRVITA",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: kBrand, letterSpacing: 1.2),
            ),
            Spacer(),
            Icon(Icons.headset_mic_rounded, color: Colors.black87),
            SizedBox(width: 4),
            Icon(Icons.notifications_rounded, color: Colors.black87),
          ],
        ),
      ],
    );
  }
}

class _HeaderShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()..color = Colors.black26..strokeWidth = 1.8..style = PaintingStyle.stroke;
    final p1 = Path()..moveTo(size.width * 0.06, size.height * 0.32)..lineTo(size.width * 0.94, size.height * 0.60);
    canvas.drawPath(p1, edgePaint);

    final p2Paint = Paint()..color = Colors.black38..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final p2 = Path()..moveTo(size.width * 0.22, size.height * 0.72)..lineTo(size.width * 0.98, size.height * 0.42);
    canvas.drawPath(p2, p2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
