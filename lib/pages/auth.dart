import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';


class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'confirmpassword': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _passwordtextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(.5), BlendMode.dstATop),
        image: AssetImage("images/background.jpg"));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: "Email",
          filled: true,
          fillColor: Colors.white,
          icon: Icon(
            Icons.email,
            size: 32,
            color: Theme.of(context).accentColor,
          )),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordtextController,
      decoration: InputDecoration(
          labelText: "Password",
          filled: true,
          fillColor: Colors.white,
          icon: Icon(
            Icons.lock,
            size: 32,
            color: Theme.of(context).accentColor,
          )),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildconfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "confirm Password",
          filled: true,
          fillColor: Colors.white,
          icon: Icon(
            Icons.lock,
            size: 32,
            color: Theme.of(context).accentColor,
          )),
      obscureText: true,
      validator: (String value) {
        if (value != _passwordtextController.text) {
          return 'Password not match';
        }
      },
      onSaved: (String value) {
        _formData['confirmpassword'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10.0)),
      child: SwitchListTile(
        value: _formData['acceptTerms'],
        onChanged: (bool value) {
          setState(() {
            _formData['acceptTerms'] = value;
          });
        },
        title: Text(
          "Aceept Terms",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _submitForm(Function myAuthenticate) async {
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext cont) => AllProductsPage()));
    if (!_formKey.currentState.validate()) {
      return;
    } else if (_formKey.currentState.validate() && _formData['acceptTerms'] == false){
      String va = _authMode == AuthMode.Login ? 'Login' : 'Signup';
      _scafoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Theme.of(context).accentColor,content: Text('To Complate ${va} You Have To Accept Terms',style:
        TextStyle(fontSize: 20.0),)));
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation =
    await myAuthenticate(_formData['email'], _formData['password'], _authMode);

    if (successInformation['success']) {
      //Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext conte) {
            return AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Okay"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double tarqetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .90;
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      //body: ProductManager(proudctName: "Food Tester",),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: ScopedModelDescendant<MainModel>(builder: (BuildContext cont, Widget child, MainModel model){
                return Form(
                  key: _formKey,
                  child: Container(
                    width: tarqetWidth,
                    child: Column(children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _authMode == AuthMode.Signup
                          ? _buildconfirmPasswordTextField()
                          : Container(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildAcceptSwitch(),
                      SizedBox(
                        height: 15.0,
                      ),
                      model.isLoading
                          ? Center(
                        child: CircularProgressIndicator(
                            valueColor:
                            new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      )
                          : RaisedButton(
                          child: Text(_authMode == AuthMode.Signup
                              ? 'Signup'
                              : 'Login'),
                          //color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () =>
                              _submitForm(model.authenticate)),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                          onPressed: () {
                              _authMode = _authMode == AuthMode.Login
                                  ? AuthMode.Signup
                                  : AuthMode.Login;
                              model.notifyListeners();
                          },
                          child: Text(
                              "Switch To ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}")),
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
