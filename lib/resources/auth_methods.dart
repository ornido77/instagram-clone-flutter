import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String message = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set(
          {
            'username': username,
            'uid': cred.user!.uid,
            'email': email,
            'bio': bio,
            'followers': [],
            'following': [],
            'photoUrl': photoUrl
          },
        );
        message = "Success";
      }
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  Future<String>loginUser({
    required String email,
    required String password
  }) async {
    String res = 'Some error occured';

    try {
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }else{
        res = "Please enter all the fields";
      }
    } catch(err){
      res = err.toString();
    }
    return res;
  }
}
