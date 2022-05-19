import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:testiut/Views/Lobby.dart';
import 'package:testiut/Views/MapView.dart';
import 'package:testiut/Views/PartyLoader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testiut/tools/RandomGarbage.dart';
import 'firebase_options.dart';
import 'Views/SignIn.dart';
import 'package:http/http.dart' as http;


const ModelInterfaces MI = ModelInterfaces();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

///Entrypoint
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Project Tutoré S2',
      routes: {// all the route to the necessary screens
        '/playing' : (context) =>  MapView(),
        '/lobby' : (context) => Lobby()
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      showPerformanceOverlay: false,
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      home: Scaffold(
        appBar: AppBar(
          title:  Text("Project Tutoré S2"),
        ),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}



class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();

}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  var ls = LoginScreen();
  var _name = "name";
  late AndroidDeviceInfo androidInfo ;
  Exception? connectionError;

  ///Initialize the state and start the required services
  @override
  void initState() {
    super.initState();
    waitforStartup();

  }


  final ButtonStyle style =
  ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
///Create a wait thread for the connection to the required services
  void  waitforStartup() async{
    await     ls.signInWithGoogle().then((value) => {
      setState(()=> {
        _name = ls.user!.displayName!,
       MI.setIdUser(ls.user!.uid)
      })
    }).catchError((error) => {connectionError = error});
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;
    connectionError = MI.tryConnectToApi();
  }
  @override
  Widget build(BuildContext context) {
    return connectionError == null ? Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Bienvenue ' +  _name ,
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 30),
          ElevatedButton(

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.play_arrow),
                SizedBox(width: 5),
                Text('Jouer'),

              ],

            ),
            style: style,
            onPressed: _name == "name" ? null : () {
              Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  PartyLoader(
            )),
          ); },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.person),
                SizedBox(width: 5),
                Text('Profile'),
              ],
            ),
            style: style,
            onPressed: () =>showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title:  Text(AppLocalizations.of(context)!.userProfile),
                  content: Text(androidInfo.androidId!),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:const [
                Icon(Icons.exit_to_app),
                SizedBox(width: 5),
                Text('Quitter'),
              ],
            ),
            style: style,
            onPressed: () {SystemChannels.platform.invokeMethod('SystemNavigator.pop');},//suicide
          ), //LoginScreen()
        ],
      ),
    ) : ShowErrorDialog(e: connectionError!);
  }
}
