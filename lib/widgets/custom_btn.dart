import 'package:electronic_app/constants.dart';
import 'package:flutter/material.dart';
class CustomBtn extends StatelessWidget {
  final String btnStr ;
  final Function onPressed;
  final bool outlineBtn;
  final bool isLoading;
  CustomBtn({this.btnStr,this.onPressed,this.outlineBtn,this.isLoading});
  @override
  Widget build(BuildContext context) {
    bool _outlinebtn = outlineBtn ?? false;
    bool  _isLoading = isLoading ?? false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 65.0,
        decoration: BoxDecoration(
          color: _outlinebtn ? Colors.transparent:Colors.black,
          border: Border.all(
            color: Colors.black,
            width: 2.0,

          ),
          borderRadius: BorderRadius.circular(12.0)
        ),
       margin: EdgeInsets.symmetric(
         horizontal: 24.0,vertical: 8.0
       ),
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: _isLoading ? false : true,
              child: Center(
                child: Text(btnStr??"TEXT",style:TextStyle(
                  color: outlineBtn? Colors.black: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),
                ),
              ),
            ),
            Visibility(
                visible: _isLoading ?true:  false,
              child: Center(
                child: SizedBox(
                  height: 30,
                    width: 30,
                    child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
