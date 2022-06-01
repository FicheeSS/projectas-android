import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:testiut/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  //bool pr le btn et timer pour le CD du btn kill
  bool isKillEnable = true;
  late Timer _timerKill;

  //fct appelé quand le bouton est pressé
  void fctCallBack() {
    //on change le bool pour disable le btn
    setState(() {
      isKillEnable=false;
    });
    //on lance le timer pour 5 sec (durée du CD)
    _timerKill = Timer(const Duration(seconds: 5), handleTimeOut);

    //TODO
    // fonction que tue les autres players

  }

  //fct appelé quand le timer se finit apres sa const Duration()
  void handleTimeOut() {
    //on stop le timer pour pas qu'il continue dans le vide
    _timerKill.cancel();
    //on rechange le bool pour que le btn se réactive apres le CD
    setState(() {
      isKillEnable = true;
    });
  }

  Future<Widget> createPlayerControls(BuildContext context) async {
    //on crée le btnKill avant pour pouvoir l'ajouter dans la liste des abilités
    ElevatedButton btnKill = ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
        onPressed:
        isKillEnable ? fctCallBack : null, // si le bool est vrai on lance la fctCallBack sinon le btn est disable (null)
        child: Text(AppLocalizations.of(context)!.kill));

    List<ElevatedButton> listeBtn = [];
    //le btn kill est ajouté en 1er pour qu'il soit en haut de la liste
    listeBtn.add(btnKill);
    var listeTemp = await updateAbilities(context); // le reste des abilité est donné par l'API
    for (var i = 0; i < listeTemp.length; i++) {
      listeBtn.add(listeTemp[i]);
    }
    if (MI.getPlayerType() == playerType.loup) {
      return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: listeBtn, // si c'est un loup on met la liste avec le Kill
          ));
    } else {
      return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: listeTemp, // sinon la liste sans le kill
          ));
    }
  }

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
