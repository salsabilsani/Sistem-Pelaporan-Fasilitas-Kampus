import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 28),
    ),
    const SizedBox(width: 12),
    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('SILAPOR', style: TextStyle(fontWeight: FontWeight.w900,
          fontSize: 22, letterSpacing: 2, color: AppColors.primary)),
      Text('Fasilitas baik, kampus nyaman.',
          style: TextStyle(fontSize: 11, color: AppColors.muted)),
    ]),
  ]);
}

class AppPanel extends StatelessWidget {
  final Widget child;
  const AppPanel({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.blush),
    ),
    child: child,
  );
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const AppButton({super.key, required this.label,
    required this.onPressed, this.loading = false});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: loading ? null : onPressed,
      child: loading
        ? const SizedBox(width: 22, height: 22,
            child: CircularProgressIndicator(strokeWidth: 2))
        : Text(label),
    ),
  );
}

enum ReportStatus { waiting, processing, completed, rejected }

class StatusBadge extends StatelessWidget {
  final ReportStatus status;
  const StatusBadge({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    final (label, foreground, background) = switch (status) {
      ReportStatus.waiting => ('Menunggu', const Color(0xFF795700), const Color(0xFFFFF0C2)),
      ReportStatus.processing => ('Diproses', const Color(0xFF26425A), const Color(0xFFDCE9F5)),
      ReportStatus.completed => ('Selesai', const Color(0xFF205C43), const Color(0xFFDDF3E7)),
      ReportStatus.rejected => ('Ditolak', const Color(0xFF922B43), const Color(0xFFFBE3E9)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: foreground, fontWeight: FontWeight.w600)),
    );
  }
}
