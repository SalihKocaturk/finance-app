import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../features/auth/models/user.dart';
import '../constants/toast.dart';
import '../domain/models/account.dart';
import '../domain/models/user_account.dart';

class FirebaseService {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) => _firestore.collection('users').doc(uid);
  CollectionReference<Map<String, dynamic>> get _accountCol => _firestore.collection('accounts');

  Future<User?> getUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      final snap = await _userDoc(firebaseUser.uid).get();
      if (!snap.exists) return null;

      final data = snap.data()!;
      final raw = data['birthDate'];
      final birthDate = raw is Timestamp ? raw.toDate() : (raw is String ? DateTime.tryParse(raw) : null);

      return User(
        id: data['uid'] as String?,
        name: data['name'] as String,
        email: data['email'] as String,
        birthDate: birthDate,
        imageUrl: data['imageUrl'] as String?,
      );
    } catch (e) {
      showToast('Beklenmeyen hata: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    DateTime? birthDate,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fu = cred.user;
      if (fu == null) return null;

      await _userDoc(fu.uid).set({
        'uid': fu.uid,
        'name': name,
        'email': email,
        'birthDate': birthDate != null ? Timestamp.fromDate(birthDate) : null,
        'imageUrl': fu.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return User(
        id: fu.uid,
        name: name,
        email: email,
        birthDate: birthDate,
        imageUrl: fu.photoURL,
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

  Future<Account?> createAccountSessionForCurrentUser() async {
    try {
      final fu = _auth.currentUser;
      if (fu == null) {
        showToast("Kullanıcı oturumu bulunamadı.");
        return null;
      }

      final acc = Account(
        accounts: [UserAccount(id: fu.uid, email: fu.email)],
        transactions: [],
      );

      final docRef = await _accountCol.add({
        'shareId': acc.shareId,
        // kullanıcıları 'users' altında sade map olarak tutuyoruz
        'users': [
          {'id': fu.uid, 'email': fu.email},
        ],
        'transactions': [],
        'createdAt': FieldValue.serverTimestamp(),
        // üyelik kontrolleri için (güvenlik kurallarıyla eşleşsin istersen)
        'memberIds': [fu.uid],
      });

      return Account(
        id: docRef.id,
        accounts: acc.accounts,
        transactions: acc.transactions,
        shareId: acc.shareId,
      );
    } catch (e) {
      showToast('Oturum oluşturma hatası: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fu = cred.user;
      if (fu == null) return null;

      final snap = await _userDoc(fu.uid).get();
      if (snap.exists) {
        final data = snap.data()!;
        final raw = data['birthDate'];
        final birthDate = raw is Timestamp ? raw.toDate() : (raw is String ? DateTime.tryParse(raw) : null);

        return User(
          id: data['uid'] as String?,
          name: data['name'] as String,
          email: data['email'] as String,
          birthDate: birthDate,
          imageUrl: data['imageUrl'] as String?,
        );
      } else {
        // İlk girişte profil belgesi yoksa oluştur
        await _userDoc(fu.uid).set({
          'uid': fu.uid,
          'name': fu.displayName ?? '',
          'email': fu.email,
          'birthDate': null,
          'imageUrl': fu.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        return User(
          id: fu.uid,
          name: fu.displayName ?? '',
          email: fu.email ?? '',
          birthDate: null,
          imageUrl: fu.photoURL,
        );
      }
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('Kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        showToast('Şifre yanlış.');
      } else {
        showToast('Firebase hatası: ${e.message}');
      }
      return null;
    } catch (e) {
      showToast('Beklenmeyen hata: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile({
    required String uid,
    String? name,
    String? email,
    DateTime? birthDate,
    String? imageUrl,
  }) async {
    try {
      final fu = _auth.currentUser;
      if (fu == null || fu.uid != uid) return false;

      if (email != null && email.isNotEmpty && email != fu.email) {
        await fu.verifyBeforeUpdateEmail(email);
      }
      if (name != null && name.isNotEmpty && name != (fu.displayName ?? "")) {
        await fu.updateDisplayName(name);
      }
      if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != (fu.photoURL ?? "")) {
        await fu.updatePhotoURL(imageUrl);
      }

      final data = <String, dynamic>{};
      if (name != null && name.isNotEmpty) data['name'] = name;
      if (birthDate != null) data['birthDate'] = Timestamp.fromDate(birthDate);
      if (email != null && email.isNotEmpty) data['email'] = email;
      if (imageUrl != null && imageUrl.isNotEmpty) data['imageUrl'] = imageUrl;

      if (data.isNotEmpty) {
        await _userDoc(uid).set(data, SetOptions(merge: true));
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
