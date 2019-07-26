import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status {
  Uninitialized,
  Authenticated,
  VerifyingPhoneNumber,
  VerifyPhoneFailed,
  SmsCodeSent,
  VerifyingSmsCode,
  VerifySmsCodeFailed,
  Unauthenticated
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  String _verificationId;

  Map<String, dynamic> _response = {
    'status': Status.Unauthenticated,
    'user': null,
    'verificationId': '',
    'error': null
  };

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen((FirebaseUser firebaseUser) {
      if (firebaseUser == null) {
        _response = {
          'status': Status.Unauthenticated,
          'user': null,
          'verificationId': '',
          'error': null
        };
      } else {
        _user = firebaseUser;
        _response = {
          'status': Status.Authenticated,
          'user': _user,
          'verificationId': '',
          'error': null
        };
      }
      notifyListeners();
    });
  }

  Map<String, dynamic> get response => _response;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      _user = await _auth.signInWithCredential(phoneAuthCredential);
      _response = {
        'status': Status.Authenticated,
        'user': _user,
        'verificationId': '',
        'error': null
      };
      notifyListeners();
      print('Authenticated Phone');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _response = {
        'status': Status.VerifyPhoneFailed,
        'user': null,
        'verificationId': '',
        'error': 'VERIFY_PHONE_FAILED'
      };
      notifyListeners();
      print('Authentication Phone Failed');
      // print(authException.message);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      // _status = Status.VerifyingPhoneNumber;
      // Future.delayed(Duration(seconds: 4), (){
      //   _status = Status.SmsCodeSent;
      // });
      _response = {
        'status': Status.SmsCodeSent,
        'user': null,
        'verificationId': verificationId,
        'error': null
      };
      notifyListeners();
      _verificationId = verificationId;
      print('SMS Code Sent');
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      _response = {
        'status': Status.SmsCodeSent,
        'user': null,
        'verificationId': verificationId,
        'error': null
      };
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> signInWithPhoneNumber(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      if (user != null) {
        print('Successfully signed in, uid: ' + user.uid);
        _response = {
        'status': Status.Authenticated,
        'user': user,
        'verificationId': '',
        'error': null
      };
      notifyListeners();
      } else {
        print('Sign in failed');
        _response = {
        'status': Status.VerifySmsCodeFailed,
        'user': null,
        'verificationId': '',
        'error': 'VERIFY_SMSCODE_FAILED'
      };
      notifyListeners();
      }
    } catch (e) {
      print('Wrong SMS Code');
      _response = {
        'status': Status.VerifySmsCodeFailed,
        'user': null,
        'verificationId': '',
        'error': 'VERIFY_SMSCODE_FAILED'
      };
      notifyListeners();
    }

  }

  Future signOut() async {
    _auth.signOut();
    _response = {
      'status': Status.Unauthenticated,
      'user': null,
      'verificationId': '',
      'error': null
    };
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
