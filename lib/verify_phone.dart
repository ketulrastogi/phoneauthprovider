import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauthprovider/auth.dart';
import 'package:provider/provider.dart';

class VerifyPhonePage extends StatefulWidget {
  final bool isLoding;
  final String error;
  const VerifyPhonePage({Key key, this.isLoding, this.error}) : super(key: key);
  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage>{
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    if(authService.response['error'] == 'VERIFY_PHONE_FAILED'){
      showSnackBar(context, 'Sending sms code is failed. Please try again.');
    }
    
    return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
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