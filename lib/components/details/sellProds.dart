import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';

class SellProducts extends StatefulWidget {
  final DocumentSnapshot post;
  SellProducts({
    this.post,
  });
  @override
  _SellProductsState createState() => _SellProductsState();
}

class _SellProductsState extends State<SellProducts> {
  List<String> _methods = ['Debt', 'Cash', 'Bank Transfer'];
  String methvalue;

  getMeth(meth) {
    this.methvalue = meth;
  }

  iniState() {
    super.initState();
    startFire();
  }

  startFire() async {
    await Firebase.initializeApp();
  }

  dynamic cname, pname;
  int _qty, amount, quantity, remainingQty, dTotal, sTotal;

  DateTime now = DateTime.now();
  String convertedDate;

  calc(int q, String m, cn) async {
    if (widget.post.data()['quantity'] != 0 &&
        widget.post.data()['quantity'] != '0' &&
        q <= widget.post.data()['quantity']) {
      remainingQty = widget.post.data()['quantity'] - q;
      this.quantity = q;
      this.amount = widget.post.data()['price'] * q;
      await updateProd(this.quantity, m, cn, this.amount);
    } else {
      Flushbar(
        title: "Don't have Enough in Stock".toUpperCase(),
        message: "you don't have enough of ".toUpperCase() +
            widget.post.data()['product name'].toString().toUpperCase() +
            " in stock!".toUpperCase(),
        duration: Duration(seconds: 7),
        backgroundColor: Colors.yellow[900],
        borderColor: Colors.white,
      )..show(context);
    }
  }

  updateProd(int qty, String m, String cn, int am) async {
    DocumentReference dr = FirebaseFirestore.instance
        .collection("products")
        .doc(widget.post.data()['product name']);

    Map<String, dynamic> entries = {"quantity": remainingQty};
    dr.update(entries).whenComplete(() async {
      convertedDate =
          "${now.year.toString()} - ${now.month.toString()} - ${now.day.toString()}";

      if (m == 'Debt') {
        try {
          FirebaseFirestore.instance
              .collection('totals')
              .doc('$convertedDate')
              .get()
              .then((DocumentSnapshot ds) async {
            if (ds['debtstotal'] == null) {
              ds.data()['debtstotal'] = 0;
              recordDebt(cn, am + ds.data()['debtstotal']);
            } else {
              recordDebt(cn, am + ds.data()['debtstotal']);
            }
          });
        } on Exception catch (ex) {
          Flushbar(
            title: "Error".toUpperCase(),
            message: ex.toString(),
            duration: Duration(seconds: 7),
            backgroundColor: Colors.blue,
            borderColor: Colors.white,
          )..show(context);
          print(ex);
        }
      } else {
        try {
          FirebaseFirestore.instance
              .collection('totals')
              .doc('$convertedDate')
              .get()
              .then((DocumentSnapshot ts) async {
            if (ts.data()['salestotal'] == null) {
              ts.data()['salestotal'] = 0;
              sellProd(cn, m, am + ts.data()['salestotal']);
            } else {
              sellProd(cn, m, am + ts.data()['salestotal']);
            }
          });
        } on Exception catch (ex) {
          Flushbar(
            title: "Error".toUpperCase(),
            message: ex.toString(),
            duration: Duration(seconds: 7),
            backgroundColor: Colors.blue,
            borderColor: Colors.white,
          )..show(context);
          print(ex);
        }
      }
    });
  }

  recordDebt(cn, int dT) async {
    await Firebase.initializeApp();
    DocumentReference dr =
        FirebaseFirestore.instance.collection("debts").doc("$cn");

    Map<String, dynamic> entries = {
      "product name": widget.post.data()['product name'],
      "customer name": cn,
      "quantity": this.quantity,
      "amount": this.amount,
      "date": DateTime.now()
    };
    dr.set(entries).whenComplete(() async {
      convertedDate =
          "${now.year.toString()} - ${now.month.toString()} - ${now.day.toString()}";
      DocumentReference dr =
          FirebaseFirestore.instance.collection('totals').doc("$convertedDate");

      final sn = await dr.get();
      if (sn.exists) {
        Map<String, dynamic> tEntry = {
          "debtstotal": dT,
        };
        //Assign total below
        dr.update(tEntry).whenComplete(() {
          Navigator.pop(context);
          Flushbar(
            title: "Success".toUpperCase(),
            message: "Product Loaned successfully!".toUpperCase(),
            duration: Duration(seconds: 7),
            backgroundColor: Colors.amber,
            borderColor: Colors.white,
          )..show(context);
        });
      } else {
        Map<String, dynamic> tEntry = {
          "debtstotal": dT,
        };
        //Assign total below
        dr.set(tEntry).whenComplete(() {
          Navigator.pop(context);
          Flushbar(
            title: "Success".toUpperCase(),
            message: "Product Loaned successfully!".toUpperCase(),
            duration: Duration(seconds: 7),
            backgroundColor: Colors.amber,
            borderColor: Colors.white,
          )..show(context);
        });
      }
    });
  }

  sellProd(cn, m, int sT) async {
    await Firebase.initializeApp();
    DocumentReference dr = FirebaseFirestore.instance.collection("sales").doc();

    Map<String, dynamic> entries = {
      "customer name": cn,
      "product name": widget.post.data()['product name'],
      "quantity": this.quantity,
      "amount": this.amount,
      "transaction type": m,
      "date": DateTime.now()
    };
    dr.set(entries).whenComplete(() async {
      convertedDate =
          "${now.year.toString()} - ${now.month.toString()} - ${now.day.toString()}";
      DocumentReference dr =
          FirebaseFirestore.instance.collection("totals").doc("$convertedDate");
      final sn = await dr.get();

      if (sn.exists) {
        Map<String, dynamic> sEntry = {
          "salestotal": sT,
        };
        //Assign total below
        dr.update(sEntry).whenComplete(() {
          Navigator.pop(context);
          Flushbar(
            title: "Success".toUpperCase(),
            message: "Product Sold successfully!".toUpperCase(),
            duration: Duration(seconds: 7),
            backgroundColor: Colors.blue,
            borderColor: Colors.white,
          )..show(context);
        });
      } else {
        Map<String, dynamic> sEntry = {
          "salestotal": sT,
        };
        //Assign total below
        dr.set(sEntry).whenComplete(() {
          Navigator.pop(context);
          Flushbar(
            title: "Success".toUpperCase(),
            message: "Product Sold successfully!".toUpperCase(),
            duration: Duration(seconds: 7),
            backgroundColor: Colors.blue,
            borderColor: Colors.white,
          )..show(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Sell ".toUpperCase() +
              widget.post.data()['product name'].toString().toUpperCase()),
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
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Customer Name",
              ),
              onChanged: (value) {
                cname = value;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
              ),
              onChanged: (value) {
                _qty = int.parse(value);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField<String>(
              value: methvalue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: "Transaction Type"),
              onChanged: (newValue) {
                setState(() {
                  methvalue = newValue;
                });
                getMeth(newValue);
              },
              items: _methods.map((m) {
                return DropdownMenuItem(
                  child: new Text(m),
                  value: m,
                );
              }).toList(),
            ),
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
              child: Text("Sell Product"),
              onPressed: () {
                calc(_qty, methvalue, cname);
              })
        ]),
      ),
    );
  }
}
