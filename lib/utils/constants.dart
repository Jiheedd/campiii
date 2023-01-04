import '../utils/size_config.dart';
import 'package:flutter/material.dart';


const kPrimaryColor = Color(0xff187ab4);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const Color yellowColor = Color.fromRGBO(253, 211, 4, 1);
const Color borderContainer = Color.fromRGBO(63, 124, 190, 1.0);
const Color DarkBlueColor = Color.fromRGBO(47, 75, 110, 1);
const safeZoneColor = Color(0xff3ea417);
const dangerZoneColor = Color(0xffea151b);
const normalZoneColor = Color(0xffea8015);
const darkColor = Color(0xff0c0c0c);
const loveColor = Color(0xfff5363b);



final List<Color> backgroundColorDark = [
  const Color.fromRGBO(252, 214, 0, 1),
  const Color.fromRGBO(251, 207, 6, 1),
  const Color.fromRGBO(250, 197, 16, 1),
  const Color.fromRGBO(249, 161, 28, 1),
];

/*
const List<Color> backgroundColorDark = [
  const Color.fromRGBO(54, 54, 54, 1.0),
  const Color.fromRGBO(45, 45, 45, 1.0),
  const Color.fromRGBO(31, 31, 31, 1.0),
  const Color.fromRGBO(17, 17, 17, 1.0),
];*/

const List<Color> backgroundColorLight = [
  Color.fromRGBO(255, 255, 255, 1.0),
  Color.fromRGBO(241, 241, 241, 1),
  Color.fromRGBO(233, 233, 233, 1),
  Color.fromRGBO(222, 222, 222, 1),
];

final List<Color> actionContainerColorDarkBlue = [
    const Color.fromRGBO(47, 75, 110, 1),
    const Color.fromRGBO(43, 71, 105, 1),
    const Color.fromRGBO(39, 64, 97, 1),
    const Color.fromRGBO(34, 58, 90, 1),
  ];

final List<Color> actionContainerColorBlue = [
  const Color.fromRGBO(63, 124, 190, 1.0),
  const Color.fromRGBO(86, 145, 204, 1.0),
  const Color.fromRGBO(8, 80, 147, 1.0),
  const Color.fromRGBO(4, 42, 88, 1.0),
];

final List<Color> actionContainerColorGreen = [
  const Color.fromRGBO(166, 212, 70, 1.0),
  const Color.fromRGBO(172, 215, 108, 1.0),
  //const Color.fromRGBO(76, 146, 11, 1.0),
  const Color.fromRGBO(98, 169, 13, 1.0),
];

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kPhoneNumberLengthError = "The phone number must be 8 digits";
const String kAddressNullError = "Please Enter your address";


final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}
