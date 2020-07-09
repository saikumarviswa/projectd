import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteranimaters/Notifications/SendNotification.dart';
import 'package:flutteranimaters/Notifications/notificatinSender.dart';
import'package:flutteranimaters/Screens/MapScreen.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../PendingCalls.dart';
import 'styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/FadeContainer.dart';
import 'homeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<double> containerGrowAnimation;
  AnimationController _screenController;
  AnimationController _buttonController;
  Animation<double> buttonGrowAnimation;
  Animation<double> listTileWidth;
  Animation<Alignment> listSlideAnimation;
  Animation<Alignment> buttonSwingAnimation;
  Animation<EdgeInsets> listSlidePosition;
  Animation<Color> fadeScreenAnimation;
  var animateStatus = 0;

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  StreamSubscription iosSubscription;

  String month = new DateFormat.MMMM().format(
    new DateTime.now(),
  );
  int index = new DateTime.now().month;
  String tok;


  @override
  void initState() {
    super.initState();

    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1500), vsync: this);

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );
    containerGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

    buttonGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOut,
    );
    containerGrowAnimation.addListener(() {
      this.setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

    listTileWidth = new Tween<double>(
      begin: 1000.0,
      end: 600.0,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.bounceIn,
        ),
      ),
    );

    listSlideAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.700,
          curve: Curves.ease,
        ),
      ),
    );
    buttonSwingAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.ease,
        ),
      ),
    );
    listSlidePosition = new EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 16.0),
      end: const EdgeInsets.only(bottom: 80.0),
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );
    _screenController.forward();


    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
         // _messageText = "Push Messaging message: $message";
        });
        /*print("onMessage: $message");*/

        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          //_messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          //_messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print(token);
        tok = token;
      });

    });



    /*print("oiuoniugiludxrcny g yu");
    print(_fcm.getToken());
    print("oiuoniugiludxrcny g yu");*/


  }

  @override
  void dispose() {
    _screenController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Are you sure?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: (){
              /*if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {*/
              SystemNavigator.pop();
              //}
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;
    Size screenSize = MediaQuery.of(context).size;
    String mainProfilePicture = "https://randomuser.me/api/portraits/women/44.jpg";
/*
    String otherProfilePicture = "https://randomuser.me/api/portraits/women/47.jpg";
*/

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          body: new Scaffold(
            appBar: new AppBar(title: new Text("Dashboard"),
              backgroundColor: Colors.redAccent,
            ),
            drawer: new Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                      accountName: new Text("Sai Kumar"),
                      accountEmail: new Text("saikumar@gmail.com"),
                      currentAccountPicture: new GestureDetector(
                        //onTap: () => switchUser(),
                        child: new CircleAvatar(
                            backgroundImage: new NetworkImage(mainProfilePicture)
                        ),
                      ),
                      otherAccountsPictures: <Widget>[
                        new GestureDetector(
                          onTap: () => print("this is the other user"),
                         /* child: new CircleAvatar(
                              backgroundImage: new NetworkImage(otherProfilePicture)
                          ),*/
                        ),
                      ],
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage("https://orig00.deviantart.net/20eb/f/2015/030/6/f/_minflat__dark_material_design_wallpaper__4k__by_dakoder-d8fjqzu.jpg")
                          )
                      )
                  ),
                  new ListTile(
                      title: new Text("Pending Calls"),
                      trailing: new Icon(Icons.arrow_upward),
                      onTap: () {
                        //Navigator.of(context).pop();
                        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage("First Page")));
                      }
                  ),
                  new ListTile(
                      title: new Text("Check List"),
                      trailing: new Icon(Icons.arrow_right),
                      onTap: () {

                        Navigator.of(context).pop();
                        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage("Second Page")));
                      }
                  ),
                  new Divider(),
                  new ListTile(
                    title: new Text("LogOut"),
                    trailing: new Icon(Icons.cancel),
                    onTap: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
            body: new Container(
              padding: EdgeInsets.all(30.0),
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PendingCalls()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.home,size: 70.0,),
                            Text("Pending Calls",style: new TextStyle(fontSize: 17.0),)

                          ],
                        ),
                      ),
                      
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: InkWell(
                      onTap: (){

                        NotificationSender().sendAndRetrieveMessage("f0iSZatcTVa2-uytxik0xF:APA91bFfnYTTGZ31kbqpRP5wiEzJkP9if7zSk8ikooc2Pm1pVvW4Q9T3KfrHpjrczrODd7h_XwSYG4baB6pZkS3QfCGzT6KROwhw9BTX-2dCKGBxpOXwWJRdVy2Dtj6LTBalzz39Dvnq");
                        /*Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PendingCalls()));*/
                      },
                      splashColor: Colors.yellow,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.home,size: 70.0,),
                            Text("Call History",style: new TextStyle(fontSize: 17.0,color: Colors.white),)

                          ],
                        ),
                      ),

                    ),
                  ),

                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.green,
                    child: InkWell(
                      onTap: (){

/*
                        MapsLauncher.launchCoordinates(37.4220041, -122.0862462);
*/

                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SendNotif(tok: tok,)));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.home,size: 70.0,),
                            Text("Check List",style: new TextStyle(fontSize: 17.0,color: Colors.white),)

                          ],
                        ),
                      ),

                    ),
                  ),

                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: InkWell(
                      onTap: (){
                       /* Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PendingCalls()));*/
                        openMap(16.517454,81.725342);
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.home,size: 70.0,),
                            Text("Map",style: new TextStyle(fontSize: 17.0,color: Colors.white),)

                          ],
                        ),
                      ),

                    ),
                  ),

                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MapScreen()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.home,size: 70.0,),
                            Text("Map Screen",style: new TextStyle(fontSize: 15.0,color: Colors.white),)

                          ],
                        ),
                      ),

                    ),
                  ),

                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PendingCalls()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.home,size: 70.0,),
                            Text("Appointment Calls",style: new TextStyle(fontSize: 17.0,color: Colors.white),)

                          ],
                        ),
                      ),

                    ),
                  ),

                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PendingCalls()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.home,size: 70.0,color: Colors.white),
                            Text("Attendance & Leave",style: new TextStyle(fontSize: 15.0,color: Colors.white),)

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        )
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
