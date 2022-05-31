import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:testiut/Views/MapView.dart';
import 'package:testiut/Views/PartyLoader.dart';
import 'package:testiut/Views/ShowView.dart';
import 'package:testiut/Views/WaitingView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testiut/tools/RandomGarbage.dart';
import 'firebase_options.dart';
import 'Views/SignIn.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

ModelInterfaces MI = ModelInterfaces();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
late LocationPermission permission;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Tutoré S2',
      routes: {'/playing': (context) => MapView()},
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
          title: Text("Project Tutoré S2"),
        ),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

//List of the state of the main Window
enum currentState {
  none,
  showMap,
  showPartySelection,
  showSingin,
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  currentState _cs = currentState.none;
  var ls = LoginScreen();
  var _name = "name";
  late AndroidDeviceInfo androidInfo;
  @override
  void initState() {
    super.initState();
    waitforStartup();
  }

  callback(currentState cs) {
    setState(() {
      _cs = cs;
    });
  }

//Select the correct view for the job from [_cs]
  Widget showCorrectWidget() {
    switch (_cs) {
      case currentState.none:
        return WaitingView(
          callbackFunction: callback,
        );
        break;
      case currentState.showMap:
        return MapView();
        break;
      case currentState.showPartySelection:
        return PartyLoader();
        break;
      case currentState.showSingin:
        return LoginScreen();
        break;
    }
  }

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  Exception? initialisationError;

  void waitforStartup() async {
    await ls
        .signInWithGoogle()
        .then((value) => {
              setState(() => {_name = ls.user!.displayName!,MI.setIdUser(ls.user!.uid)})
            })
        .catchError((error) => {print(error)});
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;
    if (!await Geolocator.isLocationServiceEnabled()) {
      initialisationError = Exception("La localisation doit être active pour le fonctionnement de l'application");
    }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          initialisationError = Exception(
              "La location est nécessaire au fonction de l'application");
        }
      } else if (permission == LocationPermission.deniedForever) {
        initialisationError = Exception(
            "La location est nécessaire au fonction de l'application");

    }
  }

  @override
  Widget build(BuildContext context) {
    return initialisationError == null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Bienvenue ' + _name,
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 5),
                      Text('Jouer'),
                    ],
                  ),
                  style: style,
                  onPressed: _name == "name"
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PartyLoader()),
                          );
                        },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 5),
                      Text('Profile'),
                    ],
                  ),
                  style: style,
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title:
                                Text(AppLocalizations.of(context)!.userProfile),
                            content: Text(androidInfo.androidId!),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
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
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 5),
                      Text('Quitter'),
                    ],
                  ),
                  style: style,
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }, //suicide
                ), //LoginScreen()
              ],
            ),
          )
        : ShowErrorDialog(e: initialisationError!);
  }
}
