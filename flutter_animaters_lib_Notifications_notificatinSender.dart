import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;


class NotificationSender{
  final String serverToken = '<AAAA9On0LqY:APA91bF4rWMuB0g2GhssjITEOSxgq_SPK7JXlnvQiXOn2TtZKm6EJGnJy_M4EXbkujDgUAS9d4dyHiGmDbAUNxilxZncTv4mFaIFQPtvEcqrjxM7Cdhqh8d0S3CNCjeAQoJ0WsONsLMn>';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();


  // ignore: missing_return
  Future<Map<String, dynamic>> sendAndRetrieveMessage(String fcmToken) async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true),
    );



    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(

        <String, dynamic>{
          'to': fcmToken,
          'notification': <String, dynamic>{
            'title': 'this is a title',
            'body': 'this is a body'

          },
          "collapse_key" : "type_a",
          'data': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            "key_1" : "Value for key_1",
            "key_2" : "Value for key_2"
          },

        },
      ),
    );

    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");


    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}