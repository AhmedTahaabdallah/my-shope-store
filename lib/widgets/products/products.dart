import 'package:flutter/material.dart';
import './product_card.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';
class Proudcts extends StatelessWidget {
  



  Widget _buildProductList(List<Product> proudcts) {
    Widget productCard;
    if (proudcts.length > 0) {
      productCard = ListView.builder(
          itemCount: proudcts.length, itemBuilder: (BuildContext cont, int index) => ProductCard(proudcts, index));
    } else {
      //productCard = Center(child: Text("No Products Found, Please Add One"),);
      productCard = Container();
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return _buildProductList(model.displayedProducts);
    });

    /*ListView(
      children: proudcts.map((element) => Card(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15.0),
              child: Image.asset("images/food.jpg"),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(element)
          ],
        ),
      )).toList(),
    );*/
  }
}
