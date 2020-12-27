import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sales/components/details/compDetail.dart';

class ViewCompanies extends StatefulWidget {
  @override
  _ViewCompaniesState createState() => _ViewCompaniesState();
}

class _ViewCompaniesState extends State<ViewCompanies> {
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    getComps();
    startFire();
  }

  startFire() async {
    await Firebase.initializeApp();
  }

  Future getComps() async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("companies").get();

    return qn.docs;
  }

  String searchString;

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompanyDetail(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
          ),
          title: !isSearching
              ? Center(
                  child: Text(
                  "Companies",
                  style: TextStyle(color: Colors.white),
                ))
              : TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Search Companies",
                    labelStyle: TextStyle(color: Colors.white),
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
        ),
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
                ? FirebaseFirestore.instance.collection("companies").snapshots()
                : FirebaseFirestore.instance
                    .collection("companies")
                    .where('company name', isGreaterThanOrEqualTo: searchString)
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
                        ds['company name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        ds['product name'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        'N' + ds['cost'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Text(
                        ds['quantity'],
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => navigateToDetail(ds),
                    );
                  }).toList());
              }
            },
          ),
        ));
  }
}
