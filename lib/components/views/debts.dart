import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sales/components/details/debtDetail.dart';

class DebtList extends StatefulWidget {
  @override
  _DebtListState createState() => _DebtListState();
}

class _DebtListState extends State<DebtList> {
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    getDebts();
    startFire();
  }

  startFire() async {
    await Firebase.initializeApp();
  }

  Future getDebts() async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("debts").get();

    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DebtDetail(
                  post: post,
                )));
  }

  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: !isSearching
                ? Center(
                    child: Text(
                    "Debts",
                    style: TextStyle(color: Colors.white),
                  ))
                : TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Search Debtors by Name".toUpperCase(),
                      labelStyle: TextStyle(color: Colors.white),
                      hintText:
                          "Zulqiflu, Yusufzai, Ibn Sirin, Yondaime, Minato etc...",
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
        backgroundColor: Colors.blue[200],
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
          child: Container(
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
                  ? FirebaseFirestore.instance.collection("debts").snapshots()
                  : FirebaseFirestore.instance
                      .collection("debts")
                      .where('customer name',
                          isGreaterThanOrEqualTo: searchString)
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
                          ds['customer name'].toString().toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          ds['product name'].toString().toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          'N' + ds['amount'].toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(Icons.money_off_csred_outlined,
                            color: Colors.white),
                        onTap: () => navigateToDetail(ds),
                      );
                    }).toList());
                }
              },
            ),
          ),
        ));
  }
}
