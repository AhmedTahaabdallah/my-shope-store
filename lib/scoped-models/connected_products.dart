import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import '../models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../models/auth.dart';
import 'package:rxdart/subjects.dart';
import '../models/locationdata.dart';
mixin ConnectedProductsModel on Model{
  List<Product> _proudcts = [];
  List<Product> _proudcts_user = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;
  Product _oneProduct;
}

mixin ProductsModel on ConnectedProductsModel{
  bool _showFavorets = false;

  List<Product> get allProducts {
    return List.from(_proudcts);
  }
  List<Product> get allProducts_user {
    return List.from(_proudcts_user);
  }
  List<Product> get displayedProducts {
    if(_showFavorets){
      return _proudcts.where((Product product) => product.isFavorits).toList();
    }
    return List.from(_proudcts);
  }
  String get selectProductId{
    return _selProductId;
  }

  Product get selectedProduct{
    if(selectProductId == null){
      return null;
    }
    return _proudcts.firstWhere((Product product){
      return product.id == _selProductId;

    });
  }

  bool get displayFavoretsOnly{
    return _showFavorets;
  }


  int get selectProductIndex {
   return _proudcts.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Product get oneProduct{
    return _oneProduct;
  }

  Future<bool> addProduct(String title, String description, String image, double price,LocationData locData) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> prductData= {
      'title': title,
      'description': description,
      'image': 'https://cdn1.harryanddavid.com/wcsstore/HarryAndDavid/images/catalog/18_26468_30J_01ex.jpg',
      'price':price,
      'userEmail': _authenticatedUser.email,
      'userId' : _authenticatedUser.id,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
    };
    try{
      final http.Response response =
      await http.post('https://flutter-products-5cb4d.firebaseio.com/products.json?auth=${_authenticatedUser.token}',body: json.encode(prductData));

      if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> resposeData = json.decode(response.body);
      final Product newProduct = Product(
          id: resposeData['name'],
          title: title, description: description, price: price,
          locationData: locData,
          image: image,
          userEmail: _authenticatedUser.email, userId: _authenticatedUser.id);
      _proudcts.add(newProduct );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch(error){
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String title, String description, String image, double price,LocationData locdata) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateDate = {
      'title': title,
      'description': description,
      'image': 'https://cdn1.harryanddavid.com/wcsstore/HarryAndDavid/images/catalog/18_26468_30J_01ex.jpg',
      'price':price,
      'userEmail': selectedProduct.userEmail,
      'userId' : selectedProduct.userId,
      'loc_lat': locdata.latitude,
      'loc_lng': locdata.longitude,
      'loc_address': locdata.address
    };

    try{
      final http.Response response =
      await http.put("https://flutter-products-5cb4d.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}", body: json.encode(updateDate));

      if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Product updateProduct = Product(
          id: selectedProduct.id,
          title: title, description: description, price: price,locationData: locdata, image: image,
          userEmail: selectedProduct.userEmail, userId: selectedProduct.userId);

      _proudcts[selectProductIndex] = updateProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }catch(error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() async {
    _isLoading = true;
    final deleteProductId = selectedProduct.id;
    //_proudcts.removeAt(selectProductIndex);
    _proudcts_user.removeAt(selectProductIndex);
    _selProductId = null;
    notifyListeners();
    try{
      final http.Response response =
      await http.delete("https://flutter-products-5cb4d.firebaseio.com/products/${deleteProductId}.json?auth=${_authenticatedUser.token}");

      if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }catch(error){
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchProducts({onlyforUser = false}) async {
    _isLoading = true;
    notifyListeners();
    final http.Response response =
    await http.get("https://flutter-products-5cb4d.firebaseio.com/products.json?auth=${_authenticatedUser.token}");
      final List<Product> fetchListProduct = [];
    //final List<Product> fetchListProduct_user = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if(productListData == null){
        _isLoading = false;
        _proudcts.clear();
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData){
        final Product productss = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            locationData: LocationData(address: productData['loc_address']
            ,latitude: productData['loc_lat'],longitude: productData['loc_lng']),
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorits: productData['wishListUsers'] == null ? false : (productData['wishListUsers'] as Map<String, dynamic>)
                .containsKey(_authenticatedUser.id)
        );
        fetchListProduct.add(productss);
        /*if(productData['userId'] == _authenticatedUser.id){
          fetchListProduct_user.add(productss);
        }*/
      });
      _proudcts = onlyforUser ? fetchListProduct.where((Product pro){
        return pro.userId == _authenticatedUser.id;
      }).toList() : fetchListProduct;
      //_proudcts_user = fetchListProduct_user;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;

  }

  Future<Null> fetchProducts_user() async {
    _isLoading = true;
    notifyListeners();
    final http.Response response =
    await http.get("https://flutter-products-5cb4d.firebaseio.com/products.json?auth=${_authenticatedUser.token}");
    final List<Product> fetchListProduct_user = [];
    final Map<String, dynamic> productListData = json.decode(response.body);
    if(productListData == null){
      _isLoading = false;
      _proudcts_user.clear();
      notifyListeners();
      return;
    }
    productListData.forEach((String productId, dynamic productData){
      final Product productss = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          image: productData['image'],
          locationData: LocationData(address: productData['loc_address']
              ,latitude: productData['loc_lat'],longitude: productData['loc_lng']),
          userEmail: productData['userEmail'],
          userId: productData['userId']);
      if(productData['userId'] == _authenticatedUser.id){
        fetchListProduct_user.add(productss);
      }
    });
    _proudcts_user = fetchListProduct_user;
    _isLoading = false;
    notifyListeners();
    _selProductId = null;
  }

  Future<Null> fetchOneProducts(String productId) async {
   // _isLoading = true;
    //notifyListeners();
    final http.Response response = await http.get("https://flutter-products-5cb4d.firebaseio.com/products/${productId}.json?auth=${_authenticatedUser.token}");
      //final List<Product> fetchListProduct = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if(productListData == null){
        //_isLoading = false;
        //_proudcts.clear();
        _oneProduct = null;
        notifyListeners();
        return;
      }
      final Product productss = Product(
          id: productId,
          title: productListData['title'],
          description: productListData['description'],
          price: productListData['price'],
          image: productListData['image'],
          locationData: LocationData(address: productListData['loc_address']
              ,latitude: productListData['loc_lat'],longitude: productListData['loc_lng']),
          userEmail: productListData['userEmail'],
          userId: productListData['userId']);
      _oneProduct = productss;
      //_isLoading = false;
      //print(_oneProduct.title);
      notifyListeners();
       //productss;
      //_selProductId = null;

  }



  void toggleProductFavoritsStatue() async {
    final bool isCurrentFavorites = selectedProduct.isFavorits;
    final bool newFavoritesStatue = !isCurrentFavorites;
    final Product updateProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        locationData: selectedProduct.locationData,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorits: newFavoritesStatue);

    _proudcts[selectProductIndex] = updateProduct;
    notifyListeners();
    http.Response response;
    if(newFavoritesStatue){
      response = await http.put("https://flutter-products-5cb4d.firebaseio.com/products/${selectedProduct.id}/wishListUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}",
      body: json.encode(true));
    } else{
      response = await http.delete("https://flutter-products-5cb4d.firebaseio.com/products/${selectedProduct.id}/wishListUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}");
    }
    if(response.statusCode != 200 && response.statusCode != 201){
      final Product updateProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          locationData: selectedProduct.locationData,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorits: !newFavoritesStatue);

      _proudcts[selectProductIndex] = updateProduct;
      notifyListeners();
    }
  }
  void selectProduct(String productId){
    _selProductId = productId;
    if(productId != null){
      notifyListeners();
    }

  }

  /*void selectProduct(String productId) {
    _selProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }*/
  void toggleDisplayMode() {
    _showFavorets = !_showFavorets;
    notifyListeners();
  }
}


mixin UserModel on ConnectedProductsModel{

  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();
  PublishSubject<bool> get userSubject{
    return _userSubject;
  }
  User get user{
    return _authenticatedUser;
  }
  Future<Map<String, dynamic>> authenticate(String email, String password, [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password' : password,
      'returnSecureToken': true
    };
    http.Response response;
    if(mode == AuthMode.Login){
      response= await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyA-G0wsrMfMr2tlSxFshZST07FhWtOE-sw',
          body: json.encode(authData),
          headers: {'Content-Type':'application/json'});
    } else{
      response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyA-G0wsrMfMr2tlSxFshZST07FhWtOE-sw',
          body: json.encode(authData),
          headers: {'Content-Type':'application/json'});
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if(responseData.containsKey("idToken")){
      hasError = false;
      message = 'Authentication Succeeded!';
      _authenticatedUser = User(id: responseData['localId'], email: email, token: responseData['idToken']);
      setAuthTimout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expireTime = now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("token", responseData['idToken']);
      pref.setString("userEmail", email);
      pref.setString("userId", responseData['localId']);
      pref.setString("expireTime", expireTime.toIso8601String());
    } else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
      message = 'This Email Alredy Exists';
    } else if(responseData['error']['message'] == 'EMAIL_NOT_FOUND'){
      message = 'This Email Not Found';
    } else if(responseData['error']['message'] == 'INVALID_PASSWORD'){
      message = 'The Password Wrong';
    } else if(responseData['error']['message'] == 'USER_DISABLED'){
      message = 'The Email is Disabled';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError,'message' : message};
  }

  void autoAuthenticate() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString("token");
    final String userEmail = pref.getString("userEmail");
    final String userId = pref.getString("userId");
    final String expireTimeString = pref.getString("expireTime");
    if(token != null && userEmail != null && userId != null && expireTimeString != null){
      final DateTime now = DateTime.now();
      final parseExpiredTime = DateTime.parse(expireTimeString);
      if(parseExpiredTime.isBefore(now)){
        _authenticatedUser =null;
        notifyListeners();
        return;
      }
      final int tokenLifeSpan = parseExpiredTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimout(tokenLifeSpan);
      notifyListeners();
    }
  }

  void logout() async{
    //print("logout");
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");
    pref.remove("userEmail");
    pref.remove("userId");

  }

  void setAuthTimout(int time){
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtiltyModel on ConnectedProductsModel{
  bool get isLoading{
    return _isLoading;
  }
}