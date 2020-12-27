import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:sales/components/home.dart';

class CompanyDetail extends StatefulWidget {
  final DocumentSnapshot post;
  CompanyDetail({
    this.post,
  });
  @override
  _CompanyDetailState createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail> {
  @override
  void initState() {
    super.initState();
    qtyControl.text = widget.post.data()['quantity'].toString();
    costControl.text = widget.post.data()['cost'].toString();
    prNmControl.text = widget.post.data()['product name'];
  }

  turnRead() {
    setState(() {
      isUpdatingQty = false;
    });
  }

  offRead() {
    setState(() {
      isUpdatingQty = true;
    });
  }

  bool isUpdatingQty = true;
  bool isUpdatingPrice = true;
  TextEditingController qtyControl = new TextEditingController();
  TextEditingController costControl = new TextEditingController();
  TextEditingController prNmControl = new TextEditingController();

  void updateComp(name, int qty, int cost) async {
    DocumentReference dr = FirebaseFirestore.instance
        .collection("companies")
        .doc(widget.post.data().toString());

    Map<String, dynamic> entries = {
      "cost": cost,
      "quantity": qty,
      "product name": name
    };
    dr.update(entries).whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
      //Show this when adding the update succeeds
      Flushbar(
        title: "Success".toUpperCase(),
        message: "Company Updated successfully!".toUpperCase(),
        duration: Duration(seconds: 7),
        backgroundColor: Colors.blue,
        borderColor: Colors.white,
      )..show(context);
    });
  }

  _deleteData() async {
    var firestore = FirebaseFirestore.instance;
    await firestore
        .collection("companies")
        .doc(widget.post.data()['quantity'].toString())
        .delete()
        .whenComplete(() {
      firestore
          .collection("companies")
          .doc(widget.post.data()['cost'].toString())
          .delete()
          .whenComplete(() {
        firestore
            .collection("companies")
            .doc(widget.post.data()['product name'])
            .delete()
            .whenComplete(() {
          firestore
              .collection("companies")
              .doc(widget.post.data()['company name'])
              .delete()
              .whenComplete(() {
            Navigator.pop(context);
            Flushbar(
              title: "Deleted!".toUpperCase(),
              message:
                  "${widget.post.data()['product name']} deleted successfully"
                      .toUpperCase(),
              duration: Duration(seconds: 7),
              backgroundColor: Colors.red[900],
              borderColor: Colors.black,
            )..show(context);
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
            title: Text("Modify/Delete " + widget.post.data()['product name']),
            actions: <Widget>[
              FlatButton(
                onPressed: (() {
                  showAlertDialog(context);
                }),
                child: Icon(Icons.delete_sharp, color: Colors.red),
              ),
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                readOnly: isUpdatingQty,
                controller: qtyControl,
                decoration: InputDecoration(
                    labelText: "Quantity",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: isUpdatingQty ? turnRead : offRead)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                readOnly: isUpdatingQty,
                controller: costControl,
                decoration: InputDecoration(
                    labelText: "Price",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: isUpdatingQty ? turnRead : offRead)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                color: Colors.teal,
                textColor: Colors.white,
                focusColor: Colors.teal[100],
                highlightColor: Colors.teal[400],
                hoverColor: Colors.teal[700],
                child: Text("Update"),
                onPressed: () {
                  updateComp(prNmControl.text, int.parse(qtyControl.text),
                      int.parse(costControl.text));
                })
          ]),
        ));
  }
}
