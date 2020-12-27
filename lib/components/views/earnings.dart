import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Earnings extends StatefulWidget {
  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  var data;
  @override
  void initState() {
    super.initState();
    startFire();
  }

  startFire() async {
    await Firebase.initializeApp();
  }

  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Earnings"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Colors.green,
                  Colors.blueGrey,
                  Colors.black,
                ])),
          )),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              Colors.teal,
              Colors.cyan,
              Colors.black,
            ])),
        child: StreamBuilder<QuerySnapshot>(
            stream: (searchString == null || searchString.trim() == '')
                ? FirebaseFirestore.instance.collection("totals").snapshots()
                : FirebaseFirestore.instance
                    .collection("totals")
                    .where("id", isGreaterThanOrEqualTo: searchString)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Huston, we've got a problem: ${snapshot.error}");
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox(
                    child: Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.cyan[100],
                    )),
                  );
                case ConnectionState.none:
                  return SizedBox(
                      child: Center(
                          child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  )));
                case ConnectionState.done:
                  return SizedBox(
                      child: Center(
                          child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  )));
                  break;
                default:
                  return new ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot ds) {
                    return new ListTile(
                      title: Text(
                        "Sales total: ".toUpperCase() +
                            "N" +
                            ds['salestotal'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                          "Debts total: ".toUpperCase() +
                              "N".toUpperCase() +
                              ds['debtstotal'].toString(),
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.bold)),
                      trailing: Text(
                        ds.id.toString().toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList());
              }
            }),
      ),
    );
  }
}
