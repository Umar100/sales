import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';

class DebtDetail extends StatefulWidget {
  final DocumentSnapshot post;
  DebtDetail({
    this.post,
  });
  @override
  _DebtDetailState createState() => _DebtDetailState();
}

class _DebtDetailState extends State<DebtDetail> {
  @override
  void initState() {
    super.initState();
    cnControl.text = widget.post.data()['customer name'];
    qtyControl.text = widget.post.data()['quantity'].toString();
    amControl.text = widget.post.data()['amount'].toString();
  }

  List<String> _methods = ['Cash', 'Bank Transfer'];
  String methvalue;

  TextEditingController cnControl = new TextEditingController();
  TextEditingController qtyControl = new TextEditingController();
  TextEditingController amControl = new TextEditingController();

  getMeth(meth) {
    this.methvalue = meth;
  }

  dynamic cname, pname;
  int amount, quantity, remainingDebt, prevDebt;
  bool isUpdatingQty = true;

  calc(int q, String m, cn, int am) async {
    this.prevDebt = widget.post.data()['amount']; //assign Prev Debt
    this.quantity = q;
    this.amount = am;
    if (am == widget.post.data()['amount']) {
      await clearDebt(m);
    } else if (am < widget.post.data()['amount']) {
      remainingDebt = widget.post.data()['amount'] - am;
      adjustDebt(m);
    } else if (am > widget.post.data()['amount']) {
      Flushbar(
        title: "Overpayment!".toUpperCase(),
        message: "You are overpaying".toUpperCase(),
        duration: Duration(seconds: 7),
        backgroundColor: Colors.red[900],
        borderColor: Colors.black,
      )..show(context);
    }
  }

  adjustDebt(m) async {
    await Firebase.initializeApp();
    DocumentReference dr = FirebaseFirestore.instance.collection("debts").doc();

    Map<String, dynamic> entries = {
      "customer name": widget.post.data()['customer name'],
      "product name": widget.post.data()['product name'],
      "quantity": this.quantity,
      "amount": this.remainingDebt,
      "transaction type": m,
      "previous debt": this.prevDebt,
      "date": DateTime.now()
    };
    dr.update(entries).whenComplete(() {
      Navigator.pop(context);
      Flushbar(
        title: "Debt Adjusted!".toUpperCase(),
        message: "Part-Payment made successfully".toUpperCase(),
        duration: Duration(seconds: 7),
        backgroundColor: Colors.red[900],
        borderColor: Colors.black,
      )..show(context);
    });
  }

  clearDebt(m) async {
    await Firebase.initializeApp();
    DocumentReference dr = FirebaseFirestore.instance.collection("sales").doc();

    Map<String, dynamic> entries = {
      "customer name": widget.post.data()['customer name'],
      "product name": widget.post.data()['product name'],
      "quantity": this.quantity,
      "amount": this.amount,
      "transaction type": m,
      "date": DateTime.now()
    };
    dr.set(entries).whenComplete(() async {
      await _deleteData();
    });
  }

  _deleteData() async {
    var firestore = FirebaseFirestore.instance;
    await firestore
        .collection("debts")
        .doc(widget.post.data()['quantity'].toString())
        .delete()
        .whenComplete(() {
      firestore
          .collection("debts")
          .doc(widget.post.data()['amount'].toString())
          .delete()
          .whenComplete(() {
        firestore
            .collection("debts")
            .doc(widget.post.data()['product name'])
            .delete()
            .whenComplete(() {
          firestore
              .collection("debts")
              .doc(widget.post.data()['customer name'])
              .delete()
              .whenComplete(() {
            firestore
                .collection("debts")
                .doc(widget.post.data()['date'].toString())
                .delete()
                .whenComplete(() {
              Navigator.pop(context);
              Flushbar(
                title: "Cleared!".toUpperCase(),
                message:
                    "Debt Record has been successfully cleared".toUpperCase(),
                duration: Duration(seconds: 7),
                backgroundColor: Colors.red[900],
                borderColor: Colors.black,
              )..show(context);
            });
          });
        });
      });
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = FlatButton(
      child: Text("Delete", style: TextStyle(color: Colors.red)),
      onPressed: () {
        _deleteData();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Icon(Icons.warning),
      content: Text("Are you sure you want to delete this product?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Adjust ".toUpperCase() + widget.post.data()['product name']),
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
          actions: <Widget>[
            FlatButton(
              onPressed: (() {
                showAlertDialog(context);
              }),
              child: Icon(Icons.delete_sharp, color: Colors.red),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              // readOnly: isUpdatingQty,
              controller: cnControl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Customer Name",
              ),
              onChanged: (value) {
                cname = cnControl.text;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              // readOnly: isUpdatingQty,
              controller: qtyControl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: amControl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
              ),
              onChanged: (value) {
                amount = int.parse(amControl.text);
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
              child: Text("Pay Debt"),
              onPressed: () {
                calc(int.parse(qtyControl.text), methvalue, cnControl.text,
                    int.parse(amControl.text));
              })
        ]),
      ),
    );
  }
}
