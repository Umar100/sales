import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';

class RegComp extends StatefulWidget {
  @override
  _RegCompState createState() => _RegCompState();
}

class _RegCompState extends State<RegComp> {
  TextEditingController nmControl, qtyControl = TextEditingController();
  iniState() {
    super.initState();
    nmControl.text = "";
    qtyControl.text = "";
  }

  String cname, pname;
  int quantity;

  getCName(n) {
    this.cname = n;
  }

  void regComp() async {
    try {
      await Firebase.initializeApp();
      DocumentReference dr =
          FirebaseFirestore.instance.collection("companies").doc();

      //get the document id
      final sn = await dr.get();

      //Check if the Product Exists
      if (sn.exists) {
        //If it exists, show this
        Flushbar(
          title: "Company already exists!".toUpperCase(),
          message:
              "Kindly add a new product or update an existing one from the update page"
                  .toUpperCase(),
          duration: Duration(seconds: 7),
          backgroundColor: Colors.red[900],
          borderColor: Colors.black,
        )..show(context);
      } else {
        //Add if it does not

        Map<String, dynamic> entries = {
          "company name": cname,
          "product name": "",
          "quantity": 0,
          "cost": 0
        };
        dr.set(entries).whenComplete(() {
          //Show this when adding the addition succeeds
          Navigator.pop(context);
          Flushbar(
            title: "Success".toUpperCase(),
            message: "Product Added successfully!".toUpperCase(),
            duration: Duration(seconds: 7),
            backgroundColor: Colors.blue,
            borderColor: Colors.white,
          )..show(context);
        });
      }
    } catch (ex) {
      Flushbar(
        title: "Success".toUpperCase(),
        message: ex.message.toUpperCase(),
        duration: Duration(seconds: 7),
        backgroundColor: Colors.red,
        borderColor: Colors.white,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Register a Company"),
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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(
                labelText: "Company Name",
                prefixIcon: Icon(Icons.add_shopping_cart)),
            onChanged: (String n) {
              getCName(n);
            },
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
              color: Colors.teal,
              textColor: Colors.white,
              focusColor: Colors.teal[100],
              highlightColor: Colors.teal[400],
              hoverColor: Colors.teal[700],
              child: Text("Register Product"),
              onPressed: () {
                regComp();
              }),
        ]),
      ),
    );
  }
}
