import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ProductsDetail extends StatefulWidget {
  final DocumentSnapshot post;
  ProductsDetail({
    this.post,
  });
  @override
  _ProductsDetailState createState() => _ProductsDetailState();
}

class _ProductsDetailState extends State<ProductsDetail> {
  @override
  void initState() {
    super.initState();
    qtyControl.text = widget.post.data()['quantity'].toString();
    priceControl.text = widget.post.data()['price'].toString();
    nmControl.text = widget.post.data()['product name'];
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
  TextEditingController priceControl = new TextEditingController();
  TextEditingController nmControl = new TextEditingController();

  void updateProd(name, int qty, int pr) async {
    DocumentReference dr = FirebaseFirestore.instance
        .collection("products")
        .doc(widget.post.data()['product name']);

    Map<String, dynamic> entries = {"price": pr, "quantity": qty};
    dr.update(entries).whenComplete(() {
      Navigator.pop(context);
      //Show this when adding the update succeeds
      Flushbar(
        title: "Success".toUpperCase(),
        message: "Product Updated successfully!".toUpperCase(),
        duration: Duration(seconds: 7),
        backgroundColor: Colors.blue,
        borderColor: Colors.white,
      )..show(context);
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

  _deleteData() async {
    var firestore = FirebaseFirestore.instance;
    await firestore
        .collection("products")
        .doc(widget.post.data()['quantity'].toString())
        .delete()
        .whenComplete(() {
      firestore
          .collection("products")
          .doc(widget.post.data()['price'].toString())
          .delete()
          .whenComplete(() {
        firestore
            .collection("products")
            .doc(widget.post.data()['product name'])
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
                controller: priceControl,
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
                child: Text("Update Product"),
                onPressed: () {
                  updateProd(nmControl.text, int.parse(qtyControl.text),
                      int.parse(priceControl.text));
                })
          ]),
        ));
  }
}
