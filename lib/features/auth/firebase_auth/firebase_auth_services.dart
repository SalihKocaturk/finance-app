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
  }) async {
    try {
      firebase.UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final mailUser = credential.user;

      if (mailUser != null) {
        await _firestore.collection('users').doc(mailUser.uid).set({
          'uid': mailUser.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      final user = User(
        id: mailUser?.uid,
        name: name,
        email: email,
      );
      return user;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'E-mail kullanılıyor');

        //email kullanılıyor giris yapın uyarısı
      } else {
        //  hata donmeli
      }
      return null;
    } catch (e) {
      showToast(message: 'hata: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      firebase.UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          final data = doc.data()!;
          final user = User(
            id: data['uid'],
            name: data['name'],
            email: data['email'],
          );
          return user;
        } else {
          showToast(message: 'Firestore’da kullanıcı verisi bulunamadı.');
        }
      }
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: 'Kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password') {
        showToast(message: 'Şifre yanlış.');
      } else {
        showToast(message: 'Firebase hatası: ${e.message}');
      }
    } catch (e) {
      showToast(message: 'Beklenmeyen hata: $e');
    }
    return null;
  }
}
