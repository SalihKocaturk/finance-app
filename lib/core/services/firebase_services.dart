import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../features/auth/models/user.dart';
import '../constants/toast.dart';
import '../domain/enums/alert_type.dart';
import '../domain/enums/transaction_currency.dart';
import '../domain/enums/user_type.dart';
import '../domain/models/account.dart';
import '../domain/models/transaction.dart' as tx;
import '../domain/models/transaction_category.dart';
import '../domain/models/user_account.dart';

class FirebaseService {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) => _firestore.collection('users').doc(uid);
  CollectionReference<Map<String, dynamic>> get accounts => _firestore.collection('accounts');
  Future<DocumentReference<Map<String, dynamic>>?> _currentAccountDocRef() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final qs = await _firestore.collectionGroup('users').where('id', isEqualTo: firebaseUser.uid).limit(1).get();
    if (qs.docs.isEmpty) return null;

    final accRef = qs.docs.first.reference.parent.parent;
    return accRef is DocumentReference<Map<String, dynamic>> ? accRef : null;
  }

  CollectionReference<Map<String, dynamic>> _usersCol(DocumentReference<Map<String, dynamic>> accRef) =>
      accRef.collection('users');

  CollectionReference<Map<String, dynamic>> _txCol(DocumentReference<Map<String, dynamic>> accRef) =>
      accRef.collection('transactions');

  Future<List<tx.Transaction>> getTransactions() async {
    try {
      final accRef = await _currentAccountDocRef();
      if (accRef == null) return [];
      final snap = await _txCol(accRef).orderBy('date', descending: true).get();
      return snap.docs.map((d) {
        final m = d.data();
        return tx.Transaction.fromJson({...m, 'id': m['id'] ?? d.id});
      }).toList();
    } catch (e) {
      showToast(
        'İşlem listesi alınamadı: $e',
        AlertType.fail,
      );
      return [];
    }
  }

  Future<bool> addTransaction(tx.Transaction t) async {
    try {
      final accRef = await _currentAccountDocRef();
      if (accRef == null) return false;
      final col = _txCol(accRef);
      await col.doc(t.id).set(t.toJson(), SetOptions(merge: false));
      return true;
    } catch (e) {
      showToast(
        'İşlem ekleme hatası: $e',
        AlertType.fail,
      );
      return false;
    }
  }

  Future<bool> updateTransaction(tx.Transaction t) async {
    try {
      final accRef = await _currentAccountDocRef();
      if (accRef == null) return false;
      final col = _txCol(accRef);
      final doc = col.doc(t.id);
      final exists = (await doc.get()).exists;
      if (!exists) {
        showToast(
          'Güncellenecek işlem bulunamadı.',
          AlertType.fail,
        );
        return false;
      }
      await doc.update(t.toJson());
      return true;
    } catch (e) {
      showToast(
        'İşlem güncelleme hatası: $e',
        AlertType.fail,
      );
      return false;
    }
  }

  Future<bool> upsertTransaction(tx.Transaction t) async {
    try {
      final accRef = await _currentAccountDocRef();
      if (accRef == null) return false;
      final col = _txCol(accRef);
      await col.doc(t.id).set(t.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      showToast(
        'İşlem upsert hatası: $e',
        AlertType.fail,
      );
      return false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    try {
      final accRef = await _currentAccountDocRef();
      if (accRef == null) return false;
      final col = _txCol(accRef);
      final doc = col.doc(id);
      final exists = (await doc.get()).exists;
      if (!exists) {
        showToast(
          'Silinecek işlem bulunamadı.',
          AlertType.fail,
        );
        return false;
      }
      await doc.delete();
      return true;
    } catch (e) {
      showToast(
        'İşlem silme hatası: $e',
        AlertType.fail,
      );
      return false;
    }
  }

  Future<bool> loginToAccount({required int shareId}) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        showToast(
          "Kullanıcı oturumu bulunamadı.",
          AlertType.fail,
        );
        return false;
      }

      final query = await accounts.where('shareId', isEqualTo: shareId).limit(1).get();
      if (query.docs.isEmpty) {
        showToast(
          "Bu paylaşım kodu ile bir oturum bulunamadı.",
          AlertType.fail,
        );
        return false;
      }
      final accRef = query.docs.first.reference;

      final userDoc = await _usersCol(accRef).doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        showToast(
          "Bu oturuma zaten bağlısınız.",
          AlertType.fail,
        );
        return false;
      }

      await _usersCol(accRef).doc(firebaseUser.uid).set({
        'id': firebaseUser.uid,
        'email': firebaseUser.email,
        'type': 'member',
        'createdAt': FieldValue.serverTimestamp(),
      });

      showToast(
        "Oturuma giriş yapıldı.",
        AlertType.success,
      );
      return true;
    } catch (e) {
      showToast(
        "Oturuma giriş hatası: $e",
        AlertType.fail,
      );
      return false;
    }
  }

  Future<bool> setUserRole({
    required String userId,
    required UserType newType,
  }) async {
    try {
      final accRef = await _currentAccountDocRef();
      if (accRef == null) return false;

      final typeStr = switch (newType) {
        UserType.owner => 'owner',
        UserType.mod => 'mod',
        UserType.member => 'member',
      };

      await _usersCol(accRef).doc(userId).update({'type': typeStr});
      return true;
    } catch (e) {
      showToast('Rol güncelleme hatası: $e', AlertType.fail);
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        showToast(
          "Kullanıcı oturumu bulunamadı.",
          AlertType.fail,
        );
        return false;
      }

      final accRef = await _currentAccountDocRef();
      if (accRef == null) {
        showToast(
          "Bağlı olduğunuz bir hesap bulunamadı.",
          AlertType.fail,
        );
        return false;
      }

      final txSnap = await _txCol(accRef).get();
      for (final d in txSnap.docs) {
        await d.reference.delete();
      }

      final usersSnap = await _usersCol(accRef).get();
      for (final d in usersSnap.docs) {
        if (d.id != firebaseUser.uid) {
          await d.reference.delete();
        }
      }

      await accRef.delete();

      final myUserDoc = _usersCol(accRef).doc(firebaseUser.uid);
      final mySnap = await myUserDoc.get();
      if (mySnap.exists) {
        await myUserDoc.delete();
      }

      showToast(
        "Hesap silindi.",
        AlertType.success,
      );
      return true;
    } catch (e) {
      showToast(
        "Hesap silme hatası: $e",
        AlertType.fail,
      );
      return false;
    }
  }

  Future<bool> removeUserFromAccount(String userId) async {
    try {
      final accRef = await _currentAccountDocRef();
      if (accRef == null) {
        showToast("Bağlı olduğunuz bir hesap bulunamadı.", AlertType.fail);
        return false;
      }

      final doc = _usersCol(accRef).doc(userId);
      final exists = (await doc.get()).exists;
      if (!exists) {
        showToast("Silinecek üye bulunamadı.", AlertType.fail);
        return false;
      }

      await doc.delete();
      showToast("Üye kaldırıldı.", AlertType.success);
      return true;
    } catch (e) {
      showToast("Üye kaldırma hatası: $e", AlertType.fail);
      return false;
    }
  }

  Future<bool> exitAccount() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        showToast(
          "Kullanıcı oturumu bulunamadı.",
          AlertType.info,
        );
        return false;
      }

      final accRef = await _currentAccountDocRef();
      if (accRef == null) {
        showToast(
          "Bağlı olduğunuz bir hesap bulunamadı.",
          AlertType.info,
        );
        return false;
      }

      final userRef = _usersCol(accRef).doc(firebaseUser.uid);
      final userSnap = await userRef.get();
      if (!userSnap.exists) {
        showToast(
          "Bu hesaba zaten bağlı değilsiniz.",
          AlertType.fail,
        );
        return false;
      }

      await userRef.delete();

      showToast(
        "Hesaptan çıkış yapıldı.",
        AlertType.success,
      );
      return true;
    } catch (e) {
      showToast(
        "Hesaptan çıkış hatası: $e",
        AlertType.fail,
      );
      return false;
    }
  }

  Future<Account?> createAccountSession() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        showToast(
          "Kullanıcı oturumu bulunamadı.",
          AlertType.info,
        );
        return null;
      }

      final account = Account(
        accounts: [
          UserAccount(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            type: UserType.owner,
          ),
        ],
        transactions: [],
      );

      final docRef = await accounts.add({
        'shareId': account.shareId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _usersCol(docRef).doc(firebaseUser.uid).set({
        'id': firebaseUser.uid,
        'email': firebaseUser.email,
        'type': 'owner',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Account(
        id: docRef.id,
        accounts: account.accounts,
        transactions: account.transactions,
        shareId: account.shareId,
      );
    } catch (e) {
      showToast(
        'Oturum oluşturma hatası: $e',
        AlertType.fail,
      );
      return null;
    }
  }

  Future<Account?> getAccountSession() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        showToast(
          "Kullanıcı oturumu bulunamadı.",
          AlertType.fail,
        );
        return null;
      }

      final accRef = await _currentAccountDocRef();
      if (accRef == null) {
        showToast(
          "Hesap oturumu bulunamadı.",
          AlertType.fail,
        );
        return null;
      }

      final accSnap = await accRef.get();
      final accData = accSnap.data() ?? {};

      final usersSnap = await _usersCol(accRef).get();
      final userAccount = usersSnap.docs.map((d) {
        final m = d.data();
        final typeStr = (m['type'] as String?)?.toLowerCase();

        final isOnlyMe = usersSnap.docs.length == 1 && (m['id'] == firebaseUser.uid);

        final type = switch (typeStr) {
          'owner' => UserType.owner,
          'member' => UserType.member,
          _ => isOnlyMe ? UserType.owner : UserType.member,
        };

        return UserAccount(
          id: m['id'] as String?,
          email: (m['email'] as String?) ?? '',
          type: type,
        );
      }).toList();

      final isMember = userAccount.any((u) => u.id == firebaseUser.uid);
      if (!isMember) {
        showToast(
          "Bu hesaba erişiminiz yok.",
          AlertType.info,
        );
        return null;
      }

      final txSnap = await _txCol(accRef).orderBy('date', descending: true).get();
      final txs = txSnap.docs.map((d) {
        final t = d.data();
        return tx.Transaction(
          id: t['id'] as String? ?? d.id,
          category: TransactionCategory.fromJson(t['category'] as Map<String, dynamic>),
          amount: (t['amount'] as num).toDouble(),
          date: DateTime.parse(t['date'] as String),
          details: t['details'] as String? ?? '',
          transactionCurrency: CurrencyType.values.firstWhere(
            (c) => c.toString() == t['transactionCurrency'],
            orElse: () => CurrencyType.tl,
          ),
        );
      }).toList();

      return Account(
        id: accRef.id,
        accounts: userAccount,
        transactions: txs,
        shareId: (accData['shareId'] as num?)?.toInt(),
      );
    } catch (e) {
      showToast(
        'Oturum getirme hatası: $e',
        AlertType.fail,
      );

      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = cred.user;
      if (firebaseUser == null) return null;

      final snap = await _userDoc(firebaseUser.uid).get();
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
        await _userDoc(firebaseUser.uid).set({
          'uid': firebaseUser.uid,
          'name': firebaseUser.displayName ?? '',
          'email': firebaseUser.email,
          'birthDate': null,
          'imageUrl': firebaseUser.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        return User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          birthDate: null,
          imageUrl: firebaseUser.photoURL,
        );
      }
    } on firebase.FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        showToast(
          'Kullanıcı bulunamadı.',
          AlertType.fail,
        );
      } else if (error.code == 'wrong-password') {
        showToast(
          'Şifre yanlış.',
          AlertType.fail,
        );
      } else {
        showToast(
          'Firebase hatası: ${error.message}',
          AlertType.fail,
        );
      }
      return null;
    } catch (error) {
      showToast(
        'Beklenmeyen hata: $error',
        AlertType.fail,
      );
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
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null || firebaseUser.uid != uid) return false;

      if (email != null && email.isNotEmpty && email != firebaseUser.email) {
        await firebaseUser.verifyBeforeUpdateEmail(email);
      }
      if (name != null && name.isNotEmpty && name != (firebaseUser.displayName ?? "")) {
        await firebaseUser.updateDisplayName(name);
      }
      if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != (firebaseUser.photoURL ?? "")) {
        await firebaseUser.updatePhotoURL(imageUrl);
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
      showToast(
        'Güncelleme hatası: ${e.message}',
        AlertType.fail,
      );
      return false;
    } catch (e) {
      showToast(
        'Beklenmeyen hata: $e',
        AlertType.fail,
      );
      return false;
    }
  }

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
      showToast(
        'Beklenmeyen hata: $e',
        AlertType.fail,
      );
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
      final firebaseUser = cred.user;
      if (firebaseUser == null) return null;

      await _userDoc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'name': name,
        'email': email,
        'birthDate': birthDate != null ? Timestamp.fromDate(birthDate) : null,
        'imageUrl': firebaseUser.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return User(
        id: firebaseUser.uid,
        name: name,
        email: email,
        birthDate: birthDate,
        imageUrl: firebaseUser.photoURL,
      );
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(
          'E-mail kullanılıyor',
          AlertType.fail,
        );
      } else {
        showToast(
          'Firebase hatası: ${e.message}',
          AlertType.fail,
        );
      }
      return null;
    } catch (e) {
      showToast(
        'hata: $e',
        AlertType.fail,
      );
      return null;
    }
  }
}
