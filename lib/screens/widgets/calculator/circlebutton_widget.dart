import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String label;
  final bool isNumber;
  final bool isSign;

   const CircleButton({
     super.key,
     required this.onTap,
     required this.label,
     required this.isNumber,
     required this.isSign
   });

  @override
  Widget build(BuildContext context) {
    return  InkResponse(
      onTap: onTap,
      child:  Container(
        width: double.infinity,
        // height: size,
        decoration:  BoxDecoration(
          // color: isSign ? Colors.white : isNumber == true ? Colors.grey : Colors.amber,
          color: (){
            late Color colors;
            if(isSign){
              colors = Colors.white;
              return colors;
            }
            colors = isNumber == true ? Colors.grey : Colors.amber;
            return colors;
          }(),
          shape: BoxShape.circle,
        ),
        child:  Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSign ? Colors.amber : Colors.white,
              fontSize: 50
            ),
          ),
        ),
      ),
    );
  }
}