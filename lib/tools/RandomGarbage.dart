import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowErrorDialog extends StatelessWidget{

  final Exception e ;
  const ShowErrorDialog({Key? key,required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return AlertDialog(

        title: Text(AppLocalizations.of(context)!.errorTitle),
        content: Column(children: [
          Text(e.toString())
        ],),
        actions: [TextButton(onPressed: () => {SystemChannels.platform.invokeMethod('SystemNavigator.pop')}, child: Text("Ok"))],
      );
  }

}