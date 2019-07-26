import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauthprovider/auth.dart';
import 'package:phoneauthprovider/verify_code.dart';
import 'package:phoneauthprovider/verify_phone.dart';
import 'package:provider/provider.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => AuthService.instance(),
        ),
      ],
          child: MaterialApp(
        title: 'Material App',
        home: InitialPage()
      ),
    );
  }
}

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, AuthService user, _) {
          switch (user.response['status']) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
              return VerifyPhonePage();
            case Status.VerifyingPhoneNumber:
              return VerifyPhonePage(isLoding: true,);
            case Status.VerifyPhoneFailed:
              print('MAIN:44 - ' +user.response['error'].toString());
              return VerifyPhonePage(error: user.response['error'].toString(),);
            case Status.SmsCodeSent:
              return VerifyCodePage();
            case Status.VerifyingSmsCode:
              return VerifyCodePage(isLoding: true,);
            case Status.VerifySmsCodeFailed:
              return VerifyCodePage(error: user.response['error'],);
            case Status.Authenticated:
              return UserInfoPage(user: user.response['user']);
            default: return VerifyPhonePage();
          }
        },
      );
  }
}

class UserInfoPage extends StatelessWidget {
  final FirebaseUser user;

  const UserInfoPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Info"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(authService.response['user'].phoneNumber.toString() ?? ''),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () => Provider.of<AuthService>(context).signOut(),
            )
          ],
        ),
      ),
    );
  }
}



class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}