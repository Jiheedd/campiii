import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

import 'text_widget.dart';

import '../utils/size_config.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;
  double textHeight =  SizeConfig.screenHeight / 5.63;
  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt()+1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(bottom: getProportionateScreenHeight(80)),
      child: secondHalf.isEmpty
          ? TextWidget(size:16,text:firstHalf, color: loveColor,height: 1.8,)
          : Column(
        children: <Widget>[
          TextWidget(size:16,height:1.8,text:flag ? (firstHalf + "...") : (firstHalf + secondHalf), color: kPrimaryColor,),
          SizedBox(height: 5,),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextWidget(
                  text: flag ? "Show more" : "Show less",
                  color: kPrimaryColor,
                  size: 14,
                ),
                Icon(flag?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined, color: kPrimaryColor,)
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
          SizedBox(height: 50,)

        ],
      ),
    );
  }
}
