// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flash_chat/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:image_list/constants.dart';
import 'package:image_list/locator.dart';
import 'package:image_list/services/temp_user_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  TextEditingController _controllerEmail;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController(text: 'Initial value');
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          // ModalProgressHUD(
          //   inAsyncCall: showSpinner,
          //   child:
          Padding(
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
                controller: _controllerEmail,
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
                _setStoredEmail(email);


var userService = getIt<UserService>();
var storedUserName = userService.userName;
print('storedUserName: $storedUserName');
// var storageService = getIt<LocalStorageService>();
userService.userName = 'new guy here';
storedUserName = userService.userName;
print('storedUserName: $storedUserName');


                if (await Permission.storage.request().isGranted) {
                  Navigator.of(context).pushNamed('ItemListScreen');
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          title: Text("Required permissions denied"),
                          content: Text(
                              "Storage permission is requred for this app.")));
                }
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
      // ),
    );
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _controllerEmail.text = prefs.getString('storedEmail');
      print('SharedPreferences (email): $email');
    });
  }
}

_setStoredEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // int counter = (prefs.getInt('counter') ?? 0) + 1;
  // print('Pressed $counter times.');
  await prefs.setString('storedEmail', email);
}

// _getStoredEmail() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('storedEmail') ?? '';
// }
