import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/form-inputs/location.dart';
import '../models/locationdata.dart';
import '../widgets/helpers/ensure_visible.dart';
class ProudctEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProudctEditPageState();
  }
}

class _ProudctEditPageState extends State<ProudctEditPage> {
  final Map<String, dynamic> _formData = {
    "title": null,
    "image": "images/food.jpg",
    "description": null,
    "price": null,
    'location': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _titileTextControler = TextEditingController();
   //static final String title_ina = widget.proudcts["description"].toString();
  //TextEditingController _titleController = new TextEditingController();
  //TextEditingController _descriptionController = new TextEditingController();

  /*void _onTitleChange() {
    String text = _titleController.text;
    setState(() {
      if (text.trim().length <= 20) {
        _formData['title'] = text;
      }
    });*/
    //bool hasFocus = _textFocus.hasFocus;
    //do your text transforming
    //_controller.text = _titleValue;
    /*_controller.selection = new TextSelection(
        baseOffset: _titleValue.length,
        extentOffset: _titleValue.length
    );*/
  //}

  /*void _onDescriptionChange() {
    String text = _descriptionController.text;
    setState(() {
      if (text.trim().length <= 300) {
        _formData['description'] = text;
      }
    });
  }*/


  Widget _buildTitleTextField(Product product) {
    if(product == null && _titileTextControler.text.trim() == ''){
      _titileTextControler.text = '';
    } else if(product != null && _titileTextControler.text.trim() == ''){
      _titileTextControler.text = product.title;
    } else if(product != null && _titileTextControler.text.trim() != ''){
      _titileTextControler.text = _titileTextControler.text;
    } else if(product == null && _titileTextControler.text.trim() != ''){
      _titileTextControler.text = _titileTextControler.text;
    } else {
      _titileTextControler.text = '';
    }
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
      //initialValue: product == null ? '' : product.title,
      controller: _titileTextControler,
      focusNode: _titleFocusNode,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title Must Be Not Empty';
        } else if (value.trim().length < 5) {
          return 'Title Must Be Not Less 5';
        } else if (value.trim().length > 20) {
          return 'Title Must Be Not More 20';
        }
      },
      //initialValue: widget.proudcts == null ? '' : widget.proudcts["title"],
      onSaved: (String value) {
        //setState(() {
          //if (value.trim().length <= 20) {
            _formData['title'] = value;
          //}
        //});
      }
          /*onChanged: (String value){
      setState(() {
        if(value.length <= 20 ){
          _titleValue = value;
        }

      });
    }*/
          ,
      maxLength: 20,
      style: TextStyle(fontSize: 18.0),
      decoration: InputDecoration(

          /*counterText: _formData['title'].toString().length.toString() + " of 20",
          counterStyle:
              TextStyle(fontSize: 18.0, color: Theme.of(context).accentColor),*/
          labelText: "Product Title",
          labelStyle: TextStyle(fontSize: 18.0),
          icon: Icon(
            Icons.title,
            size: 32,
          )),
    ),);
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
      initialValue: product == null ? '' : product.description,
      //controller: _descriptionController ,
      focusNode: _descriptionFocusNode,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description Must Be Not Empty';
        } else if (value.trim().length < 10) {
          return 'Title Must Be Not Less 10';
        } else if (value.trim().length > 300) {
          return 'Title Must Be Not More 300';
        }
      },
      //initialValue: widget.proudcts == null ? '' : widget.proudcts["description"],
      onSaved: (String value) {
        //setState(() {
          //if (value.trim().length <= 300) {
            _formData['description'] = value;
          //}
        //});
      }
          /*onChanged: (String value){
      setState(() {
        if(value.length <= 300 ){
          _descriptionValue = value;
        }

      });
    }*/
          ,
      maxLength: 300,
      style: TextStyle(fontSize: 18.0,),
      decoration: InputDecoration(

          /*counterText: _formData['description'].toString().length.toString() + " of 300",
          counterStyle:
              TextStyle(fontSize: 18.0, color: Theme.of(context).accentColor),*/
          labelText: "Product Description",
          labelStyle: TextStyle(fontSize: 18.0),
          /*border: OutlineInputBorder(
                  borderSide: BorderSide(style:
                  BorderStyle.solid,width: 2.0,color: Colors.deepPurple),borderRadius: BorderRadius.circular(7.0)),*/
          icon: Icon(
            Icons.description,
            size: 32,
          )),
      keyboardType: TextInputType.multiline,
      maxLines: 4,
    ),);
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
      focusNode: _priceFocusNode,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price Must Be Not Empty';
        } else if (!RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price Must Be a Number';
        }
      },
      initialValue: product == null ? '' : product.price.toString(),
      onSaved: (String value) {
        //setState(() {
          _formData['price'] = double.parse(value);
        //});
      }
          /*onChanged: (String value){
      setState(() {
        _priceValue = double.parse(value);
      });
    }*/
          ,
      style: TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
          labelText: "Product Price",
          labelStyle: TextStyle(fontSize: 18.0),
          icon: Icon(
            Icons.monetization_on,
            size: 32,
          )),
      keyboardType: TextInputType.number,
    ),);
  }

  Widget _buildSubmitButton(Product product){
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child, MainModel model){
      return model.isLoading ? Center(child: CircularProgressIndicator(valueColor:
      new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),) : GestureDetector(
        onTap: () => _submitForm(model.addProduct,model.updateProduct, model.selectProduct,model.selectProductIndex),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            product == null ? "Save" : "Update",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          //color: Colors.deepPurple,
        ),
      );;
    },);

  }

  void _setLocation(LocationData locdata){
    _formData['location'] = locdata;
  }

  void _submitForm(Function addProduct, Function updateProduct, Function setSelectedProduct,[int selectProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if(selectProductIndex == -1){
      addProduct(
          //_formData['title'],
          _titileTextControler.text,
          _formData['description'],
          _formData['image'],
          _formData['price'],
          _formData['location']

      ).then((bool sucess) {
        if(sucess){
          Navigator.pushReplacementNamed(context, "/products").then((_) => setSelectedProduct(null));
        } else{
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(title: Text("Something went Wrong"),
            content: Text("Please Try Again!"),
            actions: <Widget>[
              FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("Okay"))
            ],);
          });
        }
      } );
    } else {
      updateProduct(
        //_formData['title'],
          _titileTextControler.text,
        _formData['description'],
        _formData['image'],
        _formData['price'],
        _formData['location']
      ).then((bool sucess) {
        if(sucess){
          Navigator.pushReplacementNamed(context, "/products").then((_) => setSelectedProduct(null));
        } else{
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(title: Text("Something went Wrong"),
              content: Text("Please Try Again!"),
              actions: <Widget>[
                FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("Okay"))
              ],);
          });
        }
      } );
    }
    //if (selectProductIndex == null){

    /*} else {
      Navigator.pop(context);
    }*/

  }

  @override
  void initState() {
    // TODO: implement initState
    //_titleController.addListener(_onTitleChange);
    //_descriptionController.addListener(_onDescriptionChange);
    super.initState();

    //_textFocus.addListener(onChange);
  }

  Widget _buildPageContent(BuildContext context, Product product){
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double tarqetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .90;
    final double targetPadding = deviceWidth - tarqetWidth;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              //Padding(padding: EdgeInsets.only(top: 15.0)),
              SizedBox(
                height: 15.0,
              ),
              LocationInput(_setLocation, product),
              SizedBox(
                height: 15.0,
              ),
              /*RaisedButton(
          //color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 18.0),),
            onPressed: _submitForm)*/
              _buildSubmitButton(product)
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child, MainModel model){
      final Widget pageContent = _buildPageContent(context, model.selectedProduct);
      return model.selectProductIndex == -1 ?
      pageContent : Scaffold(
        appBar: AppBar(
          title: Text("Edit Product"),
        ),
        body: pageContent,
      );
    },);



  }
}
