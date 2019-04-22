import 'package:flutter/material.dart';
import './product_edit.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
class ProudctListPage extends StatefulWidget {
  final MainModel model;
  ProudctListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProudctListPageState();
  }
}
class _ProudctListPageState extends State<ProudctListPage>{

  initState(){
    widget.model.fetchProducts(onlyforUser: true);
    super.initState();
  }
  Widget _buildEditButtons(BuildContext context, int index, MainModel model){

      return IconButton(icon: Icon(Icons.edit), onPressed: (){
        //model.selectProduct(model.allProducts[index].userId);
        model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext cont){
          return ProudctEditPage();
        })).then((_){
          model.selectProduct(null);
        })

        /*.then((_) {
          model.selectProduct(null);
        })*/;
      });

  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child, MainModel model){
      return RefreshIndicator(
        onRefresh: model.fetchProducts,
        child: ListView.builder(itemBuilder: (BuildContext cont, int index){
        return Dismissible(
          onDismissed: (DismissDirection direction) {
            if(direction == DismissDirection.endToStart){
              model.selectProduct(model.allProducts[index].id);
              model.deleteProduct().then((bool sucess){
                if(!sucess){

                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(title: Text("Something went Wrong"),
                      content: Text("Please Try Again!"),
                      actions: <Widget>[
                        FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("Okay"))
                      ],);
                  });

                  model.fetchProducts_user();
                 // model.notifyListeners();
                }
              });
            }
          },


          key: Key(model.allProducts[index].title),
          background: Container(color: Colors.grey,),
          child:Column(
            children: <Widget>[
            ListTile(

              leading:  CircleAvatar(backgroundImage: NetworkImage(model.allProducts[index].image),maxRadius: 25,),
              title: Text(model.allProducts[index].title),
              subtitle: Text('\$${model.allProducts[index].price.toString()}'),
              trailing: _buildEditButtons(context, index, model),
            ),
            Divider(height: 5.0,color: Theme.of(context).accentColor,)
          ],),)
        ;
      },itemCount: model.allProducts.length,),);
    },);
  }
}