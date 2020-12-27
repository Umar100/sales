import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ViewSold extends StatefulWidget {
  @override
  _ViewSoldState createState() => _ViewSoldState();
}

class _ViewSoldState extends State<ViewSold> {
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    getSold();
    startFire();
  }

  startFire() async {
    await Firebase.initializeApp();
  }

  Future getSold() async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("sales").get();

    return qn.docs;
  }

  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: !isSearching
                ? Center(
                    child: Text(
                    "Sold Products",
                    style: TextStyle(color: Colors.white),
                  ))
                : TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Search Sold Products by Name...",
                      labelStyle: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                      hintText: "Maggi, Hyundai, Dolce etc...",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (text) {
                      setState(() {
                        searchString = text;
                      });
                    }),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    this.isSearching = !this.isSearching;
                  });
                },
              )
            ],
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
                ? FirebaseFirestore.instance.collection("sales").snapshots()
                : FirebaseFirestore.instance
                    .collection("sales")
                    .where('product name', isGreaterThanOrEqualTo: searchString)
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
                      backgroundColor: Colors.blue,
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
                          child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: Colors.grey,
                  )));

                  break;
                default:
                  return new ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot ds) {
                    return new ListTile(
                      title: Text(
                        ds['customer name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        ds['product name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        ds['quantity'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(Icons.attach_money),
                    );
                  }).toList());
              }
            },
          ),
        ));
  }
}
