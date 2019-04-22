import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_element/title_default.dart';
import '../products/address_taq.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';
class ProductCard extends StatelessWidget{
  final List<Product> proudcts;
  final int productIndex;
  ProductCard(this.proudcts,this.productIndex);


  Widget _buildTitlePriceRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: TitleDefailt(proudcts[productIndex].title),
        ),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
            flex: 1,
            child: PriceTaq(proudcts[productIndex].price.toString())
        ),
      ],
    );
  }

  Widget _buildActionsButtons(BuildContext cont){
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () => Navigator.pushNamed<bool>(
              cont, '/product/' + model.allProducts[productIndex].id),
          icon: Icon(Icons.info,color: Theme.of(cont).accentColor,size: 40,),
        ),
         IconButton(
            onPressed: ()  {
              model.selectProduct(model.allProducts[productIndex].id);
              model.toggleProductFavoritsStatue();
            },
            icon: Icon(
              model.allProducts[productIndex].isFavorits ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(cont).primaryColor,size: 40,),
          )
        ,
      ],
    );},
    );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                right: 15.0,
                left: 15.0,
                bottom: 10.0,
                top: productIndex == 0 ? 15.0 : 10.0),
            child: FadeInImage(placeholder: AssetImage("images/background.jpg"), image: NetworkImage(proudcts[productIndex].image)),
          ),
          //Padding(padding: EdgeInsets.only(top: 10.0)),
          _buildTitlePriceRow(),
          //SizedBox(height: 2.0,),
          Padding(padding: EdgeInsets.only(right: 15.0,left: 15.0),
          child: AddressTaq(proudcts[productIndex].locationData.address),)
          ,
          //Text("Email : " + proudcts[productIndex].userEmail),
          _buildActionsButtons(context)
        ],
      ),
    );
  }
}