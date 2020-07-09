import 'package:flutter/material.dart';

class PendingCalls extends StatefulWidget{

  const PendingCalls({Key key}) : super(key: key);

  @override
  _PendingCalls createState() => _PendingCalls();
}

class _PendingCalls extends State<PendingCalls>{

  final europeanCountries = ['Albania', 'Andorra', 'Armenia', 'Austria',
    'Azerbaijan', 'Belarus', 'Belgium', 'Bosnia and Herzegovina', 'Bulgaria',
    'Croatia', 'Cyprus', 'Czech Republic', 'Denmark', 'Estonia', 'Finland',
    'France', 'Georgia', 'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland',
    'Italy', 'Kazakhstan', 'Kosovo', 'Latvia', 'Liechtenstein', 'Lithuania',
    'Luxembourg', 'Macedonia', 'Malta', 'Moldova', 'Monaco', 'Montenegro',
    'Netherlands', 'Norway', 'Poland', 'Portugal', 'Romania', 'Russia',
    'San Marino', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden',
    'Switzerland', 'Turkey', 'Ukraine', 'United Kingdom', 'Vatican City'];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Scaffold(
        appBar: new AppBar(title: new Text("Pending calls"),
          backgroundColor: Colors.redAccent,
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              leading: new Image.network(
                "https://randomuser.me/api/portraits/women/47.jpg",
                fit: BoxFit.cover,
                width: 100.0,
              ),

              title: new Text(
                "Sai",
                style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("Hello",
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),
                    new Text('Work: ${"Hello"}',
                        style: new TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.normal)),
                  ]),

              onTap: () {

              },
            );
          },
        )
      ),
    );
  }

}