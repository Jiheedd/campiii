import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/size_config.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/global_variable.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'signup_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
              (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body:
      SafeArea(
          child: SizeConfig.screenWidth < webScreenSize ?
          Center(
            child: Container(
                padding: SizeConfig.screenWidth > webScreenSize
                    ? EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth / 3)
                    : const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.05,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * .8,
                        height: SizeConfig.screenHeight * 0.4,
                        child: Image.asset("assets/images/logo.png"),
                        //color: Colors.red,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.05,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.03,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        textEditingController: _passwordController,
                        isPass: true,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.05,
                      ),
                      InkWell(
                        onTap: loginUser,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            color: blueColor,
                          ),
                          child: !_isLoading
                              ? const Text(
                            'Log in',
                          )
                              : const CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              'Dont have an account?',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                ' Signup.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.08,
                      ),
                    ],
                  ),
                )
            )
          )
              :
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediaQuery.of(context).viewInsets.bottom == 0 ?
              Center(
                child: Container(
                  width: SizeConfig.screenWidth * 0.45,
                  height: SizeConfig.screenHeight * 0.5,
                  child: Image.asset("assets/images/logo.png"),
                  //color: Colors.red,
                ),
              ) : Container(),
              Container(
                width: MediaQuery.of(context).viewInsets.bottom == 0? SizeConfig.screenWidth * 0.45 : SizeConfig.screenWidth,
                height: SizeConfig.screenHeight ,
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(20)),
                //color: Colors.yellow,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFieldInput(
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _emailController,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFieldInput(
                          hintText: 'Enter your password',
                          textInputType: TextInputType.text,
                          textEditingController: _passwordController,
                          isPass: true,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap: loginUser,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              color: blueColor,
                            ),
                            child: !_isLoading
                                ? const Text(
                              'Log in',
                            )
                                : const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                'Dont have an account?',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: const Text(
                                  ' Signup.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                )
              )
            ],
          ),
      )
    );
  }
}
