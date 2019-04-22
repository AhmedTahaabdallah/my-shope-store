import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import '../helpers/ensure_visible.dart';
import '../../models/locationdata.dart';
import '../../models/product.dart';
import 'package:http/http.dart' as http;
//import 'package:location/location.dart' as geoloc;
import 'dart:convert';
import 'dart:async';

class LocationInput extends StatefulWidget{
  final Function setLocation;
  final Product product;
  LocationInput(this.setLocation, this.product);
  @override
  State<StatefulWidget> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput>{
  Uri _staticMapUri;
  LocationData _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if(widget.product != null){
      _getStaticMap(widget.product.locationData.address,geocode: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  _showWarningDailog(BuildContext cont) {
    showDialog(
        context: cont,
        builder: (BuildContext co) {
          return AlertDialog(
            title: Text("End All Map Location Requests !!"),
            content: Text("Sorry! All Map Location Requests For Today was End, Please Try again later."),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(co)
                  , child: Text("Ok")),
            ],
          );
        });
  }

  void _getStaticMap(String address,{bool geocode = true, double lat, double lng}) async {
    try{
      bool resultNull = false;
      //_locationData = null;
      if(address.isEmpty){
        setState(() {
          _staticMapUri = null;
        });
        widget.setLocation(null);
        return;
      }
      if(geocode){
        final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
            {'address':address, 'key':'AIzaSyCqyuBNcIYTHaIyIaYdUXravGKNo-WuuFo'});
        final http.Response response = await http.get(uri);
        final decodedResponse = json.decode(response.body);
        //print(response.statusCode);
        if(response.statusCode == 403){
          //_locationData = null;
          return;
        }
        print(decodedResponse);
        List<dynamic> result = decodedResponse['results'];
        if(result.length != 0){
          final formatedAddress = decodedResponse['results'][0]['formatted_address'];
          final coords = decodedResponse['results'][0]['geometry']['location'];
          _locationData = LocationData(address: formatedAddress,
              latitude: coords['lat'],longitude: coords['lng']);
          resultNull = false;
        } else {
          resultNull = true;
          _showWarningDailog(context);
        }

      } else if(lat == null && lng == null){
        _locationData = widget.product.locationData;
        resultNull = false;
      } else {
        _locationData = LocationData(address: address, latitude: lat, longitude: lng);
        resultNull = false;
      }


      if(mounted && !resultNull){
        final StaticMapProvider staticMapProvider = StaticMapProvider("AIzaSyCqyuBNcIYTHaIyIaYdUXravGKNo-WuuFo");
        final Uri staticMapuri = staticMapProvider.getStaticUriWithMarkers([
          Marker("position", "Position", _locationData.latitude, _locationData.longitude)
        ],
            center: Location(_locationData.latitude, _locationData.longitude),
            width: 500,
            height: 300,
            maptype: StaticMapViewType.roadmap);
        widget.setLocation(_locationData);
        setState(() {
          _addressInputController.text = _locationData.address;
          _staticMapUri = staticMapuri;
        });
      }
    } catch(error){

    }

  }

  /*Future<String> _getAddres(double lat, double lng)async{
    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'latlng': '${lat.toString()},${lng.toString()}',
          'key':'AIzaSyCqyuBNcIYTHaIyIaYdUXravGKNo-WuuFo'});
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    //print(decodedResponse);
    final formatedAddress = decodedResponse['results'][0]['formatted_address'];
    return formatedAddress;
  }
  void _getUserLocation() async{
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    final address = await _getAddres(currentLocation.latitude, currentLocation.longitude);
    _getStaticMap(address,geocode: false,
    lat: currentLocation.latitude,lng: currentLocation.longitude);
  }*/

  void _updateLocation(){

    if(!_addressInputFocusNode.hasFocus){
      _getStaticMap(_addressInputController.text);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      EnsureVisibleWhenFocused(
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            validator: (String value){
              if(_locationData == null || value.isEmpty){
                return 'No vaild Location Found';
              }
            },
            decoration: InputDecoration(labelText: "Address"),

          ), focusNode: _addressInputFocusNode),
      SizedBox(height: 10.0,),
      //FlatButton(onPressed: _getUserLocation, child: Text("Locate User")),
      SizedBox(height: 10.0,),
      _staticMapUri == null ? Container() : Image.network(_staticMapUri.toString())
    ],);
  }
}