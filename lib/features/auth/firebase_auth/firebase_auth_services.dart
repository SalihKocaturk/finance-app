import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../../core/constants/toast.dart';
import '../models/user.dart';

class FirebaseAuthService {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    DateTime? birthDate,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final mailUser = credential.user;

      if (mailUser != null) {
        await _firestore.collection('users').doc(mailUser.uid).set({
          'uid': mailUser.uid,
          'name': name,
          'email': email,
          'birthDate': birthDate != null ? Timestamp.fromDate(birthDate) : null,
          'imageUrl': null, // başlangıçta boş
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return User(
        id: mailUser?.uid,
        name: name,
        email: email,
        birthDate: birthDate,
        imageUrl: null,
      );
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast('E-mail kullanılıyor');
      } else {
        showToast('Firebase hatası: ${e.message}');
      }
      return null;
    } catch (e) {
      showToast('hata: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          final ts = data['birthDate'];
          final birthDate = ts is Timestamp ? ts.toDate() : (ts is String ? DateTime.tryParse(ts) : null);

          return User(
            id: data['uid'] as String?,
            name: data['name'] as String,
            email: data['email'] as String,
            birthDate: birthDate,
            imageUrl: data['imageUrl'] as String?, // Storage URL
          );
        } else {
          showToast('Firestore’da kullanıcı verisi bulunamadı.');
        }
      }
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('Kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        showToast('Şifre yanlış.');
      } else {
        showToast('Firebase hatası: ${e.message}');
      }
    } catch (e) {
      showToast('Beklenmeyen hata: $e');
    }
    return null;
  }

  Future<bool> updateUserProfile({
    required String uid,
    String? name,
    String? email,
    DateTime? birthDate,
    String? imageUrl, // Storage URL
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      if (email != null && email.isNotEmpty && email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
      }

      if (name != null && name.isNotEmpty && name != (user.displayName ?? "")) {
        await user.updateDisplayName(name);
      }

      if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != (user.photoURL ?? "")) {
        await user.updatePhotoURL(imageUrl); // Auth profiline de yaz (opsiyonel ama güzel)
      }

      final data = <String, dynamic>{};
      if (name != null && name.isNotEmpty) data['name'] = name;
      if (birthDate != null) data['birthDate'] = Timestamp.fromDate(birthDate);
      if (email != null && email.isNotEmpty && email != user.email) data['email'] = email;
      if (imageUrl != null && imageUrl.isNotEmpty) data['imageUrl'] = imageUrl;

      if (data.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(data);
      }
      return true;
    } on firebase.FirebaseAuthException catch (e) {
      showToast('Güncelleme hatası: ${e.message}');
      return false;
    } catch (e) {
      showToast('Beklenmeyen hata: $e');
      return false;
    }
  }
}
