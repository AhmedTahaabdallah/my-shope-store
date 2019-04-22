import 'package:flutter/material.dart';
class AddressTaq extends StatelessWidget{
  final String address;
  AddressTaq(this.address);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 7.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 5.5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Text(address,textAlign: TextAlign.center,),
    );
  }
}