import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/size_config.dart';
import '../models/place_model.dart';
import '../models/post.dart';
import '../models/user.dart' as usermodel;
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/comments_screen.dart';
import '../screens/details_place_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/global_variable.dart';
import '../utils/utils.dart';
import '../widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:carousel_slider/carousel_slider.dart';
import 'text_custom.dart';




class PostCardSecond extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;
  usermodel.UserModel user;
  PostCardSecond({
    Key? key,
    required this.user,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCardSecond> createState() => _ViewPosts();
}

class _ViewPosts extends State<PostCardSecond> {

  int commentLen = 0;
  bool isLikeAnimating = false;
  bool isFavourite = false;
  late usermodel.UserModel user;
  final Place _place = Place();
  //late Map<String,dynamic> _snap;

  fetchCommentLen() async {
    try {
      QuerySnapshot snapComments = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snapComments.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    _place.comments = commentLen;
    setState(() {});
  }

  onChangeLike() {
    //setState(() {
      isFavourite = !isFavourite;
    //});
  }


  @override
  void initState() {

    //_snap = widget.snap.data();
    //user = const usermodel.UserModel(username: "username", uid: "userID", photoUrl: "https://..", email: "example@gmail.com", bio: "Infinity Camp", followers: [], following: []);
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    fetchCommentLen();
    _place.post = Post.fromSnap(widget.snap);
    if (widget.snap['likes'].contains(user.uid)){
      isFavourite = true;
    }
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    user = Provider.of<UserProvider>(context).getUser;
    final List listImages = widget.snap["images"];
    _place.owner = user;
    //Post postModel = Post.fromSnap(widget.snap);
    final timeAgo =  timeago.format(widget.snap["datePublished"].toDate());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth < webScreenSize ? getProportionateScreenWidth(8.0) : getProportionateScreenWidth(0)),
      child: Column(
        children: [
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
                onChangeLike();
              });
            },
            child: Stack(
              alignment: const Alignment(0, -0.35),
              children: [

                Padding(
                  padding: EdgeInsets.only(bottom: getProportionateScreenHeight(25),),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /*Hero(
                        tag: widget.snap["postId"],
                        child:
                      ),*/
                      Container(
                        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(5)),
                        height: SizeConfig.screenWidth < webScreenSize ? SizeConfig.screenHeight * 0.45 : SizeConfig.screenHeight * 0.8,
                        width: SizeConfig.screenWidth < webScreenSize ? SizeConfig.screenWidth : SizeConfig.screenWidth * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[100]
                        ),
                        child: Stack(
                          children: [

                            GestureDetector(
                              onTap: () {

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DetailPlaceScreen(place: _place, context: context, isFavourite: isFavourite,),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CarouselSlider.builder(
                                  itemCount: listImages.length,
                                  options: CarouselOptions(
                                    viewportFraction: 1.0,
                                    enableInfiniteScroll: false,
                                    height: 350,
                                    scrollPhysics: const BouncingScrollPhysics(),
                                    autoPlay: false,
                                  ),
                                  itemBuilder: (context, i, realIndex)
                                  => Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(listImages[i].toString())
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        //heroTag: heroTag,
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                              uid: widget.snap['uid'].toString(),
                                            ),
                                          ),
                                        ),
                                        child: FutureBuilder(
                                          future: FirebaseFirestore.instance.collection('users').doc(widget.snap["uid"]).get(),
                                          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,

                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(snapshot.data!["photoUrl"]),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextCustom(text: snapshot.data!["username"], color: Colors.white, fontWeight: FontWeight.w500 ),
                                                    TextCustom(text: timeAgo, fontSize: 15, color: Colors.white ),
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                        ),

                                      ),
                                      widget.snap["uid"]==user.uid ? InkWell(
                                          onTap: () {
                                            showDialog(
                                              useRootNavigator: false,
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: ListView(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 16),
                                                      shrinkWrap: true,
                                                      children: [
                                                        'Delete',
                                                      ]
                                                          .map(
                                                            (e) => InkWell(
                                                            child: Container(
                                                              padding:
                                                              const EdgeInsets.symmetric(
                                                                  vertical: 12,
                                                                  horizontal: 16),
                                                              child: Text(e),
                                                            ),
                                                            onTap: () {
                                                              deletePost(
                                                                widget.snap['postId']
                                                                    .toString(),
                                                              );
                                                              // remove the dialog box
                                                              Navigator.of(context).pop();
                                                            }),
                                                      )
                                                          .toList()),
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 25)
                                      )
                                          : Container(),
                                    ],
                                  ),

                                  Positioned(
                                      bottom: getProportionateScreenHeight(10),
                                      left: SizeConfig.screenWidth < webScreenSize ? -getProportionateScreenHeight(20) : getProportionateScreenHeight(35),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
                                        height: SizeConfig.screenWidth < webScreenSize ? getProportionateScreenHeight(45) : getProportionateScreenHeight(75),
                                        width: SizeConfig.screenWidth < webScreenSize ? SizeConfig.screenWidth : SizeConfig.screenWidth * 0.33,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 5.0),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
                                              color: Colors.white.withOpacity(0.2),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          FireStoreMethods().likePost(
                                                            widget.snap['postId'].toString(),
                                                            user.uid,
                                                            widget.snap['likes'],
                                                          );
                                                          setState(() {
                                                            //isLikeAnimating = true;
                                                            onChangeLike();
                                                          });
                                                        },
                                                        child: (isFavourite==false)
                                                            ? const Icon(Icons.favorite_outline_rounded, color: Colors.white)
                                                            : const Icon(Icons.favorite_rounded, color: Colors.red),
                                                      ),
                                                      const SizedBox(width: 8.0),
                                                      TextCustom(text: widget.snap['likes'].length.toString(), fontSize: 16, color: Colors.white)
                                                    ],
                                                  ),
                                                  const SizedBox(width: 20.0),
                                                  InkWell(
                                                    onTap: () =>
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) =>
                                                              CommentsScreen(postId: widget.snap['postId'].toString(),
                                                              ),
                                                          ),
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.message, color: Colors.white),
                                                        const SizedBox(width: 5.0),
                                                        commentLen < 10 ?
                                                        TextCustom(text: SizeConfig.screenWidth < webScreenSize ? "View all $commentLen comments" : "$commentLen", fontSize: 16, color: Colors.white)
                                                            :
                                                        TextCustom(text: SizeConfig.screenWidth < webScreenSize ? "View all 9+ comments" : "+9", fontSize: 16, color: Colors.white)
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20.0),

                                                  InkWell(
                                                    onTap: (){
                                                      //_onShareWithResult(context);
                                                    },
                                                    //alignment: Alignment.topRight,
                                                    //icon: SvgPicture.asset('assets/svg/send-icon.svg', height: 24, color: Colors.white)
                                                    child: const Icon(Icons.send, color: Colors.white,),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 40.0, 0.0),
                        child: Text(
                          widget.snap['title'],
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 40.0, 12.0),
                        child: Text(
                          widget.snap['description'],
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // **************************************************

                GestureDetector(
                  onTap: () {

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailPlaceScreen(place: _place, context: context, isFavourite: isFavourite,),
                      ),
                    );
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(Icons.favorite_rounded, color: Colors.red, size: 100,)
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      )
    );
  }


  // void _onShareWithResult(BuildContext context) async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //
  //   final box = context.findRenderObject() as RenderBox?;
  //   final scaffoldMessenger = ScaffoldMessenger.of(context);
  //   ShareResult shareResult;
  //   if (widget.snap["images"].isNotEmpty) {
  //     final files = <XFile>[];
  //     for (var i = 0; i < widget.snap["images"].length; i++) {
  //       files.add(XFile(widget.snap["images"][i], name: "${widget.snap["title"]} 1"));
  //     }
  //     shareResult = await Share.shareXFiles(files,
  //         text: widget.snap["title"],
  //         subject: widget.snap["description"],
  //         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  //   } else {
  //     shareResult = await Share.shareWithResult(widget.snap["title"],
  //         subject: widget.snap["description"],
  //         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  //   }
  //   scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  //
  //
  //   /*Directory(directory.path).create(recursive: true).then((dir) {
  //     print("dir = ${dir.path}");
  //     screenshotController.captureAndSave(dir.path).then((value) async{
  //       print("after value = $value");
  //       if (value!.isNotEmpty) {
  //         await Share.shareFilesWithResult(
  //             [value],
  //             text: "Cap Zebib",
  //             subject: "Dar El Ain",
  //             sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size).then((value) => print("result = ${value.status}"));
  //       } else {
  //         await Share.shareWithResult(
  //             "text",
  //             subject: "subject",
  //             sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size).then((value) => print("result = ${value.status}"));
  //       }
  //     });
  //   });*/
  // }

  /*SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }*/
}
