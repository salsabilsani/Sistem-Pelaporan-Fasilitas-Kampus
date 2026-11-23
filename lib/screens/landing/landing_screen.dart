import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  final VoidCallback onLogin;

  const LandingScreen({
    super.key,
    required this.onLogin,
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static const _primary = Color(0xFF2B124C);
  static const _background = Color(0xFFF8F6FA);
  static const _muted = Color(0xFF65566F);

  final _scrollController = ScrollController();
  final _stepsKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToSteps() {
    final targetContext = _stepsKey.currentContext;

    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  Widget _buildBrand(bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.apartment_rounded,
          color: _primary,
          size: isDesktop ? 38 : 28,
        ),
        const SizedBox(width: 8),
        Text(
          'SILAPOR',
          style: TextStyle(
            color: _primary,
            fontSize: isDesktop ? 25 : 19,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFCFAFF),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFECE3F2),
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 20,
              vertical: isDesktop ? 16 : 10,
            ),
            child: Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: _buildBrand(isDesktop),
                  ),
                ),
                const Spacer(),
                if (isDesktop) ...[
                  TextButton(
                    onPressed: _scrollToTop,
                    child: const Text(
                      'Beranda',
                      style: TextStyle(
                        color: _primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  TextButton(
                    onPressed: _scrollToSteps,
                    child: const Text(
                      'Cara kerja',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
                OutlinedButton(
                  onPressed: widget.onLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    minimumSize: const Size(84, 44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    side: const BorderSide(
                      color: Color(0xFF79428D),
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEED6F7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'Pelaporan Fasilitas Kampus',
            style: TextStyle(
              color: Color(0xFF5C246F),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: isDesktop ? 22 : 16),
        Text(
          'Kampus nyaman,\n'
          'mulai dari\n'
          'laporanmu.',
          style: TextStyle(
            color: _primary,
            fontSize: isDesktop ? 46 : 34,
            fontWeight: FontWeight.w900,
            height: 1.12,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Bantu menjaga fasilitas kampus dengan '
          'melaporkan kerusakan dan memantau '
          'perkembangan penanganannya dalam satu tempat.',
          style: TextStyle(
            color: _muted,
            fontSize: isDesktop ? 16 : 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildReportButton({bool fullWidth = false}) {
    final button = FilledButton(
      onPressed: widget.onLogin,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF55206B),
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 54),
        padding: const EdgeInsets.symmetric(
          horizontal: 26,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'Mulai Melapor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 14),
          Icon(
            Icons.arrow_forward_rounded,
            size: 22,
          ),
        ],
      ),
    );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildCampusImage(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          isDesktop ? 30 : 20,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x102B124C),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          isDesktop ? 30 : 20,
        ),
        child: AspectRatio(
          aspectRatio: isDesktop ? 1.48 : 1.8,
          child: Image.asset(
            'assets/images/kampus_silapor.png',
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            semanticLabel:
                'Ilustrasi gedung JPTK FKIP UNS',
          ),
        ),
      ),
    );
  }

  Widget _buildHero(bool isDesktop) {
    return CustomPaint(
      painter: _LandingWavePainter(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 32 : 20,
              isDesktop ? 54 : 28,
              isDesktop ? 32 : 20,
              isDesktop ? 66 : 40,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntro(true),
                            const SizedBox(height: 28),
                            _buildReportButton(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 38),
                      Expanded(
                        flex: 7,
                        child: _buildCampusImage(true),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntro(false),
                      const SizedBox(height: 24),
                      _buildCampusImage(false),
                      const SizedBox(height: 20),
                      _buildReportButton(fullWidth: true),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required bool showNumber,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFECE4F2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C2B124C),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showNumber) ...[
                  Text(
                    number,
                    style: const TextStyle(
                      color: Color(0xFF8B4398),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(bool isDesktop) {
    final cards = [
      _buildStepCard(
        number: '01',
        title: 'Temukan kendala',
        description: 'Ada fasilitas yang rusak?',
        icon: Icons.search_rounded,
        iconBackground: const Color(0xFFE4D4F6),
        iconColor: const Color(0xFF592777),
        showNumber: isDesktop,
      ),
      _buildStepCard(
        number: '02',
        title: 'Kirim laporan',
        description: 'Sertakan foto dan lokasi.',
        icon: Icons.image_outlined,
        iconBackground: const Color(0xFFF8D2E4),
        iconColor: const Color(0xFF923665),
        showNumber: isDesktop,
      ),
      _buildStepCard(
        number: '03',
        title: 'Pantau penanganan',
        description: 'Lihat perkembangan laporanmu.',
        icon: Icons.checklist_rounded,
        iconBackground: const Color(0xFFD6E4FB),
        iconColor: const Color(0xFF3F4388),
        showNumber: isDesktop,
      ),
    ];

    return Center(
      key: _stepsKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 32 : 20,
            isDesktop ? 30 : 8,
            isDesktop ? 32 : 20,
            isDesktop ? 54 : 36,
          ),
          child: Column(
            crossAxisAlignment: isDesktop
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                isDesktop
                    ? 'Lapor mudah, kampus lebih nyaman'
                    : 'Cara kerja',
                textAlign:
                    isDesktop ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  color: _primary,
                  fontSize: isDesktop ? 29 : 24,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 24),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 18),
                    Expanded(child: cards[1]),
                    const SizedBox(width: 18),
                    Expanded(child: cards[2]),
                  ],
                )
              else
                Column(
                  children: [
                    cards[0],
                    const SizedBox(height: 14),
                    cards[1],
                    const SizedBox(height: 14),
                    cards[2],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFEBDFF2),
            Color(0xFFE5D8EC),
          ],
        ),
      ),
      child: const Text(
        'SILAPOR · Universitas Sebelas Maret',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 950;

            return Column(
              children: [
                _buildHeader(isDesktop),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        _buildHero(isDesktop),
                        _buildSteps(isDesktop),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LandingWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;

    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF8F6FC),
          Color(0xFFF7EDF6),
          Color(0xFFF8F6FA),
        ],
      ).createShader(bounds);

    canvas.drawRect(bounds, background);

    final topWave = Path()
      ..moveTo(size.width * 0.30, 0)
      ..cubicTo(
        size.width * 0.51,
        size.height * 0.16,
        size.width * 0.64,
        -size.height * 0.07,
        size.width,
        size.height * 0.09,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      topWave,
      Paint()..color = const Color(0xFFDFE6F7),
    );

    final pinkWave = Path()
      ..moveTo(0, size.height * 0.91)
      ..cubicTo(
        size.width * 0.17,
        size.height * 0.83,
        size.width * 0.28,
        size.height * 1.06,
        size.width * 0.50,
        size.height * 0.96,
      )
      ..cubicTo(
        size.width * 0.71,
        size.height * 0.85,
        size.width * 0.84,
        size.height * 1.05,
        size.width,
        size.height * 0.88,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      pinkWave,
      Paint()..color = const Color(0xFFF0DDED),
    );

    final blueWave = Path()
      ..moveTo(0, size.height * 0.98)
      ..cubicTo(
        size.width * 0.16,
        size.height * 1.06,
        size.width * 0.24,
        size.height * 0.88,
        size.width * 0.40,
        size.height * 0.95,
      )
      ..cubicTo(
        size.width * 0.60,
        size.height * 1.07,
        size.width * 0.78,
        size.height * 0.91,
        size.width,
        size.height * 0.98,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      blueWave,
      Paint()..color = const Color(0xFFDCE3F5),
    );
  }

  @override
  bool shouldRepaint(
    covariant _LandingWavePainter oldDelegate,
  ) {
    return false;
  }
}