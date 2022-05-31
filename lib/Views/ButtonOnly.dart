import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:testiut/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ButtonOnly extends StatefulWidget {
  const ButtonOnly({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ButtonOnlyState();
  }


}


class _ButtonOnlyState extends State<ButtonOnly> {

  Future<List<ElevatedButton>> updateAbilities(BuildContext context) async {
    List<Abilities>? listesAbilite = await MI.getPlayerAbilities();
    List<ElevatedButton> temp = [];
    for (int i = 0; i < listesAbilite.length; i++) {
      temp.add(ElevatedButton(
          onPressed: () => {}, child: Text(listesAbilite[i].nom!)));
    }
    return temp;
  }

  bool isKillEnable = true;
  //final RestartableTimer _timerKill = RestartableTimer(const Duration(seconds: 2),handleTimeOut);
  late Timer _timerKill;

  void fctCallBack() {
    /*setState(() {
        //_timerKill.reset();
        //_timerKill = Timer(const Duration(seconds: 5),handleTimeOut);
        //isKillEnable=false;
      });*/
    setState(() {
      isKillEnable=false;
    });

    _timerKill = Timer(const Duration(seconds: 5), handleTimeOut);
    print("timerKill debut");
  }

  void handleTimeOut() {
    /*setState(() {
      //isKillEnable=true;
      //_timerKill.cancel();
    });*/
    _timerKill.cancel();
    setState(() {
      isKillEnable = true;
    });

    print("timerKill fin");
  }

  /*void fctCallBackTemp(){
    _timerKill = Timer(const Duration(seconds: 5), () =>
    {
      setState(() => {isKillEnable = true, _timerKill.cancel()})
    });
    setState(() => {isKillEnable = false});

    /*setState(() {
      isKillEnable=true;
      _timerKill.cancel();
    });*/
  }*/

  Future<Widget> createPlayerControls(BuildContext context) async {
    //Timer timer = Timer(const Duration(seconds: 5), () =>{setState(()=>{isKillEnable=true})});
    ElevatedButton btnKill = ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
        onPressed:
        isKillEnable ? () => {fctCallBack(), isKillEnable = false} : null,
        child: Text("kill"));

    List<ElevatedButton> listeBtn = [];
    listeBtn.add(btnKill);
    var listeTemp = await updateAbilities(context);
    for (var i = 0; i < listeTemp.length; i++) {
      listeBtn.add(listeTemp[i]);
    }
    if (MI.getPlayerType() == playerType.loup) {
      return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: listeBtn,
          ));
    } else {
      return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: listeTemp,
          ));
    }
  }

  //fct callback du timer
  /*void fctCB(){
    getPositionsFromRest(mapController);
    if(count++>2&&!isKillEnable){
      setState(() {
        count=0;
        isKillEnable=true;
      });
    }
  }*/

  int count = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<Widget>(
        future: createPlayerControls(context),
        builder:
            (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          Widget children;
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const Text("Waiting...");
          }
        });
  }

}
