import 'package:flutter/material.dart';
import 'package:flutteranimaters/Notifications/notificatinSender.dart';
import 'package:url_launcher/url_launcher.dart';

class SendNotif extends StatefulWidget{

  String tok;
    SendNotif({Key key,@required this.tok}) : super(key: key);

  @override
  SendNot createState() => new SendNot(tok);

}

class SendNot extends State<SendNotif>{

  TextEditingController textEditingController = new TextEditingController();

  String fcmTok;
  SendNot(String fcmTok){
    this.fcmTok = fcmTok;
  }

  @override
  Widget build(BuildContext context) {

    textEditingController.text = fcmTok;
    print(fcmTok);

    return new Scaffold(
      appBar: new AppBar(title: new Text("Dashboard"),
        backgroundColor: Colors.redAccent,
      ),
      body: new Scaffold(
        body: new Column(
          children: <Widget>[
            new TextFormField(
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: textEditingController,
              decoration: new InputDecoration(

                border: InputBorder.none,
                hintText: "FCM",
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                contentPadding: const EdgeInsets.only(
                    top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
              ),
            ),
            new FlatButton(
              onPressed: (){



              },
              child: new Text('Send'),
            ),
          ],
        ),

      ),
    );
  }



}