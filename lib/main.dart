import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
//import 'package:flutter/rendering.dart';
import './pages/auth.dart';
import './pages/allproducts.dart';
import './pages/allproducts_admin.dart';
import './pages/productpage.dart';
import './models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled =true;
  //debugPaintPointersEnabled = true;
  MapView.setApiKey("AIzaSyCqyuBNcIYTHaIyIaYdUXravGKNo-WuuFo");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}
class _MyAppState extends State<MyApp>{

  bool _isAuthenticated = false;
  final MainModel _model = MainModel();
  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated ){
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });

    //_model.notifyListeners();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              fontFamily: "oswald",
              buttonColor: Colors.deepPurple
          ),
          debugShowCheckedModeBanner: false,
          //debugShowMaterialGrid: true,
          title: "Manage System",
          //home: AuthPage(),
          routes: {
            '/' : (BuildContext cont) => !_isAuthenticated ? AuthPage(): AllProductsPage(_model),
            //'/products' : (BuildContext cont) => AllProductsPage(_model),
            '/admin' : (BuildContext cont) => !_isAuthenticated ? AuthPage(): AllProductsAdminPage(_model),
          },
          onGenerateRoute: (RouteSettings settings){
            if(!_isAuthenticated){
              return MaterialPageRoute<bool>(builder: (BuildContext cont) => AuthPage());
            }
            final List<String> pathElement = settings.name.split('/');
            if(pathElement[0] != ''){
              return null;
            }
            if(pathElement[1] == 'product'){
              final String productId = pathElement[2];
              final Product product = _model.allProducts.firstWhere((Product produc){
                return produc.id == productId;
              });
              return MaterialPageRoute<bool>(builder: (BuildContext cont) =>
              !_isAuthenticated ? AuthPage(): ProductPage(product));
            }
          },

          onUnknownRoute: (RouteSettings settings){
            return MaterialPageRoute(builder: (BuildContext cont) => !_isAuthenticated ? AuthPage(): AllProductsPage(_model));
          },
        ));
  }

}


