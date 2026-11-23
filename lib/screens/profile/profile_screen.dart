import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String roleLabel;
  final Future<void> Function() onSignOut;
  final VoidCallback onSignedOut;
  final bool preview;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.roleLabel,
    required this.onSignOut,
    required this.onSignedOut,
    this.preview = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _primary = Color(0xFF2B124C);
  static const _background = Color(0xFFF8F6FA);
  static const _text = Color(0xFF301B40);
  static const _muted = Color(0xFF72617E);

  bool _isLoading = false;
  String? _errorMessage;

  String get _initials {
    final words = widget.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return '?';

    return words
        .take(2)
        .map((word) => word.characters.first)
        .join()
        .toUpperCase();
  }

  void _goBack() {
    if (_isLoading) return;

    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop();
    } else if (widget.preview) {
      widget.onSignedOut();
    }
  }

  Future<void> _logout() async {
    if (_isLoading) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            widget.preview
                ? 'Tutup pratinjau profil?'
                : 'Keluar dari akun?',
            style: const TextStyle(
              color: _primary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            widget.preview
                ? 'Kamu akan kembali ke halaman login. '
                    'Data yang ditampilkan adalah data contoh.'
                : 'Kamu dapat masuk kembali untuk '
                    'melaporkan dan memantau fasilitas kampus.',
            style: const TextStyle(
              color: _muted,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onSignOut();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      widget.onSignedOut();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Belum bisa keluar. Silakan coba kembali.';
      });
    }
  }

  Widget _buildTopBar() {
    final canGoBack =
        widget.preview || Navigator.of(context).canPop();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: canGoBack
                ? IconButton(
                    tooltip: 'Kembali',
                    onPressed: _isLoading ? null : _goBack,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: _primary,
                    ),
                  )
                : null,
          ),
          const Expanded(
            child: Text(
              'Profil saya',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _primary,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ClipRect(
      child: CustomPaint(
        painter: _ProfileHeaderPainter(),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              28,
              24,
              60,
            ),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF0D9E4),
                        Color(0xFFD4AACB),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x22200035),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D6E5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    widget.roleLabel,
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0E8F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: _primary,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 14,
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

  Widget _buildAccountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF0E8F3),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x142B124C),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi akun',
            style: TextStyle(
              color: _primary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama lengkap',
            value: widget.name,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFECE3F0),
          ),
          _buildInfoRow(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: widget.email,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFECE3F0),
          ),
          _buildInfoRow(
            icon: Icons.school_outlined,
            label: 'Peran',
            value: widget.roleLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _isLoading ? null : _logout,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF42165C),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFD8C8E2),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: _primary,
                ),
              )
            : const Text(
                'Keluar dari akun',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTopBar(),
        _buildProfileHeader(),
        Transform.translate(
          offset: const Offset(0, -30),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                _buildAccountCard(),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 18),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFB3261E),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                _buildLogoutButton(),
                const SizedBox(height: 28),
                const Text(
                  'SILAPOR · Universitas Sebelas Maret',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final outerPadding = isWide ? 32.0 : 0.0;

            final minimumHeight =
                constraints.maxHeight > outerPadding * 2
                    ? constraints.maxHeight -
                        outerPadding * 2
                    : 0.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(outerPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minimumHeight,
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 440,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: _background,
                      borderRadius: BorderRadius.circular(
                        isWide ? 28 : 0,
                      ),
                      border: isWide
                          ? Border.all(
                              color: const Color(0xFFD9CDE4),
                            )
                          : null,
                      boxShadow: isWide
                          ? const [
                              BoxShadow(
                                color: Color(0x162B124C),
                                blurRadius: 32,
                                offset: Offset(0, 12),
                              ),
                            ]
                          : null,
                    ),
                    child: _buildProfileContent(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;

    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF652D70),
          Color(0xFF2B124C),
        ],
      ).createShader(bounds);

    canvas.drawRect(bounds, backgroundPaint);

    final upperWave = Path()
      ..moveTo(0, size.height * 0.68)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.33,
        size.width * 0.49,
        size.height * 0.94,
        size.width * 0.76,
        size.height * 0.49,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.28,
        size.width,
        size.height * 0.30,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      upperWave,
      Paint()..color = const Color(0xFF663467),
    );

    final lowerWave = Path()
      ..moveTo(0, size.height * 0.83)
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.58,
        size.width * 0.50,
        size.height * 1.05,
        size.width * 0.78,
        size.height * 0.69,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.52,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      lowerWave,
      Paint()..color = const Color(0xFF925C83),
    );
  }

  @override
  bool shouldRepaint(
    covariant _ProfileHeaderPainter oldDelegate,
  ) {
    return false;
  }
}