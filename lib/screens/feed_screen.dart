import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/post_card_second.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/global_variable.dart';
import '../utils/size_config.dart';
import '../models/user.dart' as usermodel;


class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late usermodel.UserModel user;

  @override
  void initState() {
    super.initState();
    //_snap = widget.snap.data();
    //user = const usermodel.UserModel(username: "username", uid: "userID", photoUrl: "https://..", email: "example@gmail.com", bio: "Infinity Camp", followers: [], following: []);
    user = Provider.of<UserProvider>(context, listen: false).getUser;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    user = Provider.of<UserProvider>(context, listen: false).getUser;

    //final width = SizeConfig.screenWidth;

    return Scaffold(
      backgroundColor:
      SizeConfig.screenWidth > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: SizeConfig.screenWidth > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: const Text(
                  "Infinity CAMP",
                style: TextStyle(
                  color: Colors.white,
                  height: 32,
                  //fontFamily: 'MontSerratLight',
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizeConfig.screenWidth < webScreenSize ?
          ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.01),
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth > webScreenSize ? SizeConfig.screenWidth * 0.3 : 0,
                vertical: SizeConfig.screenWidth > webScreenSize ? 15 : 0,
              ),
              //child: Container(),
              child: PostCardSecond(
                snap: snapshot.data!.docs[index],
                user: user,
              ),
            ),
          )
              :
          GridView.builder(
            shrinkWrap: true,
            itemCount: (snapshot.data! as dynamic).docs.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1.5,
              childAspectRatio: SizeConfig.screenHeight * 0.00235,
            ),
            itemBuilder: (context, index) {

              return Container(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.01),
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.005,
                  //vertical: SizeConfig.screenHeight * 0.05,
                ),
                //child: Container(),
                child: PostCardSecond(
                  snap: snapshot.data!.docs[index],
                  user: user,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
