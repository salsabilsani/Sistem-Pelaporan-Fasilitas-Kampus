import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

    // Menyimpan profil pengguna
  Future<void> simpanProfil({
    required String uid,
    required String nama,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'nama': nama,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

    // Mengambil profil pengguna berdasarkan UID
  Future<Map<String, dynamic>?> getProfil(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  // Menyimpan laporan fasilitas
  Future<void> tambahLaporan(Map<String, dynamic> data) async {
    await _db.collection('reports').add({
      ...data,
      'status': 'Menunggu',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Mengambil seluruh laporan
  Stream<QuerySnapshot<Map<String, dynamic>>> getLaporan() {
    return _db
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Memperbarui status laporan
  Future<void> updateStatus(
    String reportId,
    String status,
  ) async {
    await _db.collection('reports').doc(reportId).update({
      'status': status,
    });
  }

  // Menghapus laporan
  Future<void> hapusLaporan(String reportId) async {
    await _db.collection('reports').doc(reportId).delete();
  }
}