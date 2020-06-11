// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_list/constants.dart';
import 'package:image_list/locator.dart';
import 'package:image_list/services/authentication_service.dart';
import 'package:image_list/services/localstorage_service.dart';
import 'package:image_list/services/temp_user_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  // static String id =
  //     'LoginScreen'; // used for routes to prevent string mismatch, static is a class var
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  TextEditingController _emailController =
      TextEditingController(text: 'Initial value');
  final AuthenticationService _authenticationService =
      getIt<AuthenticationService>();
  final LocalStorageService _localStorageService = getIt<LocalStorageService>();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getStoredEmail();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    // padding: EdgeInsetsDirectional.only(top: 40.0),
                    height: 200.0,
                    child: Image.asset('assets/images/icon.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  // textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    print('email: $email');
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  )
                  // decoration:
                  //     kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                  ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                // textAlign: TextAlign.center,
                autofocus: true,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  print('password: $password');
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                ),
                // decoration: kTextFieldDecoration.copyWith(
                //     hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),

              // DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'Email',
              //       hintText: 'Type or select your email',
              //       prefixIcon: Icon(Icons.lock),
              //     ),
              //     items: <DropdownMenuItem<String>>[
              //       DropdownMenuItem<String>(value: 'joe', child: Text('Joe')),
              //       DropdownMenuItem(value: 'dave', child: Text('Dave'))
              //     ],
              //     onChanged: (value) {
              //       setState(() {
              //         // _ratingController = value;
              //       });
              //     }),

              RaisedButton(
                onPressed: () async {
                  print('Login Button Pressed');
                  email = _emailController.text;
                  _setStoredEmail(email);
                  await loginButtonAction();
//                 var userService = getIt<UserService>();
//                 var storedUserName = userService.userName;
//                 print('storedUserName: $storedUserName');
// // var storageService = getIt<LocalStorageService>();
//                 userService.userName = 'new guy here';
//                 storedUserName = userService.userName;
//                 print('storedUserName: $storedUserName');
                },
                color: Theme.of(context).primaryColor,
                child: const Text('Login',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              // RoundedButton(
              //     color: Colors.lightBlueAccent,
              //     text: 'Log In',
              //     onPressed: () async {
              //       print(email);
              //       print(password);
              //       setState(() {
              //         showSpinner = true;
              //       });
              // try {
              //   final foundUser = await _auth.signInWithEmailAndPassword(
              //       email: email, password: password);
              //   if (foundUser != null) {
              //     Navigator.pushNamed(context, ChatScreen.id);
              //   }
              //   setState(() {
              //     showSpinner = false;
              //   });
              // } catch (e) {
              //   print(e);
              // }
              // }),
            ],
          ),
        ),
      ),
    );
  }

  _getStoredEmail() async {
    _emailController.text = await _localStorageService.getStoredEmail();
  }

  _setStoredEmail(String email) {
    _localStorageService.setStoredEmail(email);
  }

  // Future<Null> getSharedPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _controllerEmail.text = prefs.getString('storedEmail');
  //     print('SharedPreferences (email): $email');
  //   });
  // }
  loginButtonAction() async {
    setState(() => showSpinner = true);
    try {
      final foundUser = await signInAuth();
      await checkStoragePermission();
      Navigator.of(context)
          .pushNamed('HomeScreen', arguments: foundUser.user.email);
    } catch (e) {
      print('outer error handler: $e');
      showError(context, title: 'Error logging in...', content: 'Error: $e');
    }
    setState(() => showSpinner = false);
  }

  Future<AuthResult> signInAuth() async {
    print('email: $email');
    print('password: $password');
    try {
      final foundUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (foundUser != null) {
        // print('foundUser: $foundUser');
        return foundUser;
      }
      return Future.error('unexpected authentication error');
    } catch (e) {
      print('error: ${e.message}');
      return Future.error(e.message);
    }
  }

  Future<bool> checkStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      print('error: Storage permission denied by user');
      return Future.error('Storage permission is requred for this app.');
    }
  }
}

showError(context,
    {String title = 'Error', String content = 'No details available'}) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
}
