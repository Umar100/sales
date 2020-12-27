import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales/components/addProduct.dart';
import 'package:sales/components/registerCompany.dart';
import 'package:sales/components/views/debts.dart';
import 'package:sales/components/views/sales.dart';
import 'package:sales/components/views/sold.dart';
import 'package:sales/components/views/viewCompanies.dart';
import 'package:sales/components/views/viewProducts.dart';
import 'views/earnings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    startFire();
  }

  startFire() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text("Home Page")),
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
        child: ListView(children: <Widget>[
          Container(
            decoration:
                new BoxDecoration(border: new Border(bottom: new BorderSide())),
            child: Padding(
              padding: const EdgeInsets.all(27.0),
              child: ListTile(
                  leading: Icon(Icons.local_grocery_store),
                  title: Text('View Products',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewProducts()))),
            ),
          ),
          Container(
            decoration:
                new BoxDecoration(border: new Border(bottom: new BorderSide())),
            child: Padding(
              padding: const EdgeInsets.all(27.0),
              child: ListTile(
                  leading: Icon(Icons.money),
                  title: Text('View Companies',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewCompanies()))),
            ),
          ),
          Container(
            decoration:
                new BoxDecoration(border: new Border(bottom: new BorderSide())),
            child: Padding(
              padding: const EdgeInsets.all(27.0),
              child: ListTile(
                  leading: Icon(Icons.store_mall_directory),
                  title: Text('View Sold Products',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewSold()))),
            ),
          ),
          Container(
            decoration:
                new BoxDecoration(border: new Border(bottom: new BorderSide())),
            child: Padding(
              padding: const EdgeInsets.all(27.0),
              child: ListTile(
                  leading: Icon(Icons.store_mall_directory),
                  title: Text('View Borrowed items',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DebtList()))),
            ),
          ),
          Container(
            decoration:
                new BoxDecoration(border: new Border(bottom: new BorderSide())),
            child: Padding(
              padding: const EdgeInsets.all(27.0),
              child: ListTile(
                  leading: Icon(Icons.local_grocery_store),
                  title: Text('View Earnings',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Earnings()))),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        color: Colors.teal,
        backgroundColor: Colors.tealAccent,
        buttonBackgroundColor: Colors.orange[200],
        items: <Widget>[
          Icon(Icons.add_shopping_cart, size: 20, color: Colors.white),
          Icon(Icons.money, size: 20, color: Colors.white),
          // Icon(Icons.home, size: 20, color: Colors.white),
          Icon(Icons.precision_manufacturing_outlined,
              size: 20, color: Colors.white),
          // Icon(Icons.person, size: 20, color: Colors.white)
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        index: 1,
        onTap: (index) {
          if (index == 0) {
            print('$index tapped');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SalesProducts()));
          } else if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RegComp()));
            print('$index tapped');
          }
          // else if (index == 4) {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => SalesProducts()));
          // }
        },
      ),
    );
  }
}
