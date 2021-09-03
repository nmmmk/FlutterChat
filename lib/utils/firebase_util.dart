import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUtil {
  static Future<User?> signInAnonymously() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      final UserCredential authResult = await auth.signInAnonymously();
      user = authResult.user;
    }

    return user;
  }

  static Future<User?> signInGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return null;
    }

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);

    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    if (user == null) {
      final UserCredential authResult = await auth.signInWithCredential(credential);
      user = authResult.user;
    }

    return user;
  }

  static Future<String?> uploadFile(String fileName, String fullPath) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('user-icon').child(fileName);

    final UploadTask uploadTask = ref.putFile(File(fullPath));

    String? url;
    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {
      throw onError;
    });

    return url;
  }
}
