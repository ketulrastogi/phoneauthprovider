import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauthprovider/auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final bool isLoding;

  const LoginPage({Key key, this.isLoding}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return SafeArea(
          child: Scaffold(
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text('Test sign in with phone number'),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration:
                  InputDecoration(labelText: 'Phone number (+x xxx-xxx-xxxx)'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Phone number (+x xxx-xxx-xxxx)';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  try{
                    authService.verifyPhoneNumber(_phoneNumberController.text);
                  } on PlatformException{
                    print('Error Occured');
                  }
                  
                },
                child: const Text('Verify phone number'),
              ),
            ),
            TextField(
              controller: _smsController,
              decoration: InputDecoration(labelText: 'Verification code'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  authService.signInWithPhoneNumber(_smsController.text);
                },
                child: const Text('Sign in with phone number'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _message,
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
}
}