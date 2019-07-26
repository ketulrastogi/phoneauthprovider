import 'package:flutter/material.dart';
import 'package:phoneauthprovider/auth.dart';
import 'package:provider/provider.dart';

class VerifyCodePage extends StatefulWidget {
  final bool isLoding;
  final String error;
  const VerifyCodePage({Key key, this.isLoding, this.error}) : super(key: key);
  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _smsController = TextEditingController();
  String _message = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    
  }

  

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    if(authService.response['error'] == 'VERIFY_SMSCODE_FAILED'){
      showSnackBar(context, 'Wrong sms code is entered. Please try again.');
    }
    return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
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

showSnackBar(BuildContext context, String message){
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.red,
      content: Container(
        height: 24.0,
        width: double.infinity,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 24.0,
              width: 24.0,
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Icon(Icons.warning)),
            Text(message,
              style:TextStyle(
                color:Colors.white,
                fontSize: 16.0
                ),
            ),
          ],
        ),
      ),
      ),);
    
  }
}