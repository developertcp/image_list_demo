import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  HomeScreen({Key key, this.userEmail}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userEmail;
  // String userData = '';

  @override
  void initState() {
    super.initState();
    _getAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    // final FirebaseUser args = ModalRoute.of(context).settings.arguments; // returns null, likely conflict with gererateRoute
    userEmail = widget.userEmail;
print('userEmail: $userEmail');

    return WillPopScope(
      onWillPop: () async =>
          // false, // prevent device back button from exiting page
          confirmDeviceExit(), // check with user in case back button accidently pressed
      child: Scaffold(
          appBar: AppBar(
            title: Text('Item List App'),
            // backgroundColor: Colors.lightBlueAccent,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    print('settings pressed');
                    _getAuthUser();
                  }),
            ],
          ),
          body: Column(children: [Text(userEmail)]),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  //TODO: get a user name and avatar image or rebuild a smaller header
                  accountEmail: Text('name'),
                  accountName: Text(userEmail),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    print(widget.toString());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    print('pressed logout');
                    logout();
                  },
                ),
              ],
            ),
          )),
    );
  }

  logout() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut().then((res) {
      Navigator.of(context).pushReplacementNamed('LoginScreen');
    });
  }

  confirmDeviceExit() {
    showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        content: Text('Do you really want to exit'),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(c, true),
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    );
  }

  _getAuthUser() async {
    // changed to passing in email instead
    final _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    setState(() {
      userEmail = user.email;
      // userData = 'lastSignInTime: '+ user.metadata.lastSignInTime.toString();
      // userData += '\n''email: '+user.email;
      // userData += '\n''uid: '+user.uid;
    });
  }
}
