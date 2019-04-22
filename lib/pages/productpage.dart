import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_element/title_default.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import 'package:map_view/map_view.dart';
class ProductPage extends StatefulWidget {
  final Product product;
//final MainModel model;
  ProductPage(this.product);
  @override
  State<StatefulWidget> createState() {
    return _ProductPageState();
  }
}

class _ProductPageState extends State<ProductPage>{
  bool isloaded = false;


  _showWarningDailog(BuildContext cont) {

    showDialog(
        context: cont,
        builder: (BuildContext co) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: Text("This Action Cannot be Undone!"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(co), child: Text("Cancle")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(co);
                    Navigator.pop(cont, true);
                  },
                  child: Text("Delete"))
            ],
          );
        });
  }

  void _showMap(){
    setState(() {
      isloaded = true;
    });
    final List<Marker> markers = <Marker>[
      Marker('position', widget.product.locationData.address, widget.product.locationData.latitude, widget.product.locationData.longitude),
    ];
    final camrePosition = CameraPosition(Location(widget.product.locationData.latitude, widget.product.locationData.longitude), 14.5);
    final mapView = MapView();
    mapView.show(MapOptions(
      showUserLocation: true,
      initialCameraPosition: camrePosition,
      mapViewType: MapViewType.normal,
      title: 'Product Location'
    ),toolbarActions: [
      ToolbarAction('Close', 1)
    ]);
    mapView.onToolbarAction.listen((int id) {
      if(id == 1){
        mapView.dismiss();
        /*setState(() {
          isloaded = false;
        });*/
      }
    });
    mapView.onMapReady.listen((_){
      mapView.setMarkers(markers);
      Timer timer;
      timer = Timer(Duration(seconds: 7),(){
        setState(() {
          isloaded = false;
        });
        timer.cancel();
      });
      /*setState(() {
        isloaded = false;
      });*/
    });


  }
  Widget _buildAddressPriceRow(double price, String productAddress, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: 4,
          child: isloaded ? Center(
            child: CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor)),
          ) : GestureDetector(
            onTap: _showMap,
            child:Text(
            //"Cairo, Egypt",
              productAddress,
            style: TextStyle(fontFamily: "oswald", color: Colors.grey),
          ),),
        ),
        Flexible(
          flex: 3,
          child: Text(' | \$' + price.toString(),
              style: TextStyle(fontFamily: "oswald", color: Colors.grey)),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
        return Scaffold(
          appBar: AppBar(
            title: Text(model.oneProduct == null ? widget.product.title : model.oneProduct.title),
          ),
          //body: ProductManager(proudctName: "Food Tester",),
          body: RefreshIndicator(
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 20.0, right: 10.0, left: 10.0, bottom: 10.0),
                    child: FadeInImage(placeholder: AssetImage("images/background.jpg"), image:
                    NetworkImage(model.oneProduct == null ? widget.product.image : model.oneProduct.image)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Center(child: TitleDefailt(model.oneProduct == null ? widget.product.title : model.oneProduct.title)),),
                  _buildAddressPriceRow(model.oneProduct == null ? widget.product.price : model.oneProduct.price, widget.product.locationData.address, context),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      model.oneProduct == null ? widget.product.description : model.oneProduct.description,
                      textAlign: TextAlign.center,
                    ),
                  )
                  /*Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: RaisedButton(
                onPressed: () => _showWarningDailog(context),
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
              ))*/
                ],
              ),
              onRefresh: () => model.fetchOneProducts(widget.product.id)) ,
        );
      })

    ,);
  }
}
