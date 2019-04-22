import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';
import '../scoped-models/main.dart';
import '../widgets/ui_element/logout_list_tile.dart';
class AllProductsAdminPage extends StatelessWidget{

final MainModel model;
AllProductsAdminPage(this.model);
  Widget _buildSlidDrawer(BuildContext cont){
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("All Products"),
            onTap: () {
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext cont) => AllProductsPage()));
              //Navigator.pushReplacementNamed(cont, '/products');
              Navigator.pushReplacementNamed(cont, '/');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      drawer: _buildSlidDrawer(context),
      appBar: AppBar(
        title: Text("Manage Products"),
        bottom: TabBar(tabs: <Widget>[
          Tab(
            icon: Icon(Icons.create),
            text: "Create Product",
          ),
          Tab(
            icon: Icon(Icons.list),
            text: "My Products",
          )
        ]),
      ),
      //body: ProductManager(proudctName: "Food Tester",),
      body: TabBarView(children: <Widget>[
        ProudctEditPage(),
        ProudctListPage(model)

      ]),
    ),);
  }
}