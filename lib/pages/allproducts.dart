import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/ui_element/logout_list_tile.dart';
class AllProductsPage extends StatefulWidget {
  final MainModel model;
  AllProductsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _AllProductsPageState();
  }
}
class _AllProductsPageState extends State<AllProductsPage>{
  @override
  initState(){
    widget.model.fetchProducts();
    //widget.model.fetchProducts_user();
    super.initState();
  }
  Widget _buildSlidDrawer(BuildContext cont) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {

              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext cont) => AllProductsAdminPage()));
              Navigator.pushReplacementNamed(cont, '/admin');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  Widget _buildProductList(){
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model){
      Widget content = Center(child: Text('No Products Found!'),);
      if(model.displayedProducts.length > 0 && !model.isLoading){
        content = Proudcts();
      } else if(model.isLoading){
        content = Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),);
      }
      return RefreshIndicator(child: content, onRefresh: model.fetchProducts);
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSlidDrawer(context),
      appBar: AppBar(
        title: Text("Easy"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
          child: ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
            return IconButton(
              onPressed: () {
                model.toggleDisplayMode();
              },
              icon: Icon(model.displayFavoretsOnly ? Icons.favorite : Icons.favorite_border,size: 35,),
            );
          }))
        ],
      ),
      //body: ProductManager(proudctName: "Food Tester",),
      body: _buildProductList(),
    );
  }
}