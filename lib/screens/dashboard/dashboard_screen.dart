
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String nama;
  final String email;
  final VoidCallback? onBuatLaporan;
  final VoidCallback? onRiwayat;
  final VoidCallback? onProfil;
  final VoidCallback? onLogout;

  const DashboardScreen({
    super.key,
    required this.nama,
    required this.email,
    this.onBuatLaporan,
    this.onRiwayat,
    this.onProfil,
    this.onLogout,
  });

  static const _primary = Color(0xFF2B124C);
  static const _purple = Color(0xFF7518C9);
  static const _pink = Color(0xFFC38EB4);
  static const _background = Color(0xFFF8F6FA);
  static const _muted = Color(0xFF6E6476);

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFECE3F2)),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 27),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _muted),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFECE3F2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final namaTampil = nama.trim().isEmpty ? 'Mahasiswa' : nama.trim();

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        title: const Row(
          children: [
            Icon(Icons.apartment_rounded, color: _primary),
            SizedBox(width: 8),
            Text(
              'SILAPOR',
              style: TextStyle(
                color: _primary,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: onProfil,
            tooltip: 'Profil',
            icon: const Icon(Icons.account_circle_outlined, color: _primary),
          ),
          IconButton(
            onPressed: onLogout,
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout_rounded, color: _primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primary, _purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Halo,',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      namaTampil,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Yuk, ikut menjaga fasilitas kampus agar tetap nyaman!',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: onBuatLaporan,
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Text('Buat Laporan'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Ringkasan Laporan',
                style: TextStyle(
                  color: _primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _statCard(
                    title: 'Menunggu',
                    value: '0',
                    icon: Icons.hourglass_empty_rounded,
                    color: _pink,
                  ),
                  const SizedBox(width: 10),
                  _statCard(
                    title: 'Diproses',
                    value: '0',
                    icon: Icons.sync_rounded,
                    color: _purple,
                  ),
                  const SizedBox(width: 10),
                  _statCard(
                    title: 'Selesai',
                    value: '0',
                    icon: Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Menu Utama',
                style: TextStyle(
                  color: _primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 14),
              _menuCard(
                icon: Icons.edit_note_rounded,
                title: 'Buat Laporan',
                subtitle: 'Laporkan fasilitas kampus yang bermasalah',
                color: _purple,
                onTap: onBuatLaporan,
              ),
              const SizedBox(height: 12),
              _menuCard(
                icon: Icons.history_rounded,
                title: 'Riwayat Laporan',
                subtitle: 'Lihat laporan yang pernah kamu kirim',
                color: _pink,
                onTap: onRiwayat,
              ),
              const SizedBox(height: 12),
              _menuCard(
                icon: Icons.person_outline_rounded,
                title: 'Profil Saya',
                subtitle: email,
                color: const Color(0xFF86A8CF),
                onTap: onProfil,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1CBD7).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: _primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Laporanmu membantu kampus menjadi lingkungan yang lebih aman, nyaman, dan terawat.',
                        style: TextStyle(
                          color: _primary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
