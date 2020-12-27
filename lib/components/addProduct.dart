import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nmControl, qtyControl = TextEditingController();
  iniState() {
    super.initState();
    nmControl.text = "";
    qtyControl.text = "";
  }

  String name;
  int quantity;

  getName(n) {
    this.name = n;
  }

  getQty(int q) {
    this.quantity = q;
  }

  void addProd() async {
    try {
      await Firebase.initializeApp();
      DocumentReference dr =
          FirebaseFirestore.instance.collection("products").doc('$name');

      //get the document id
      final sn = await dr.get();

      //Check if the Product Exists
      if (sn.exists) {
        //If it exists, show this
        Flushbar(
          title: "Product already exists!".toUpperCase(),
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
          "product name": name,
          "quantity": quantity,
          "price": 0
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
          title: Text("Register a Product"),
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
                hintText: "Maggi, flour, keyboard etc",
                labelText: "Product Name",
                prefixIcon: Icon(Icons.add_shopping_cart)),
            onChanged: (String n) {
              getName(n);
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "0, 15, 100, 2053 etc",
                labelText: "Product Quantity",
                prefixIcon: Icon(Icons.wallet_membership)),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              getQty(int.parse(value));
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
                addProd();
              }),
        ]),
      ),
    );
  }
}
