import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/size_config.dart';
import '../models/place_model.dart';
import '../models/post.dart';
import '../models/post_second.dart';
import '../models/user.dart' as usermodel;
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/comments_screen.dart';
import '../screens/details_place_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/colors.dart';
import '../utils/global_variable.dart';
import '../utils/utils.dart';
import '../widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'text_custom.dart';




class PostCardSecond extends StatefulWidget {
  final snap;
  const PostCardSecond({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCardSecond> createState() => _ViewPosts();
}

class _ViewPosts extends State<PostCardSecond> {

  int commentLen = 0;
  bool isLikeAnimating = false;
  late usermodel.UserModel user;


  @override
  void initState() {
    super.initState();
    user = const usermodel.UserModel(username: "username", uid: "userID", photoUrl: "https://..", email: "example@gmail.com", bio: "Infinity Camp", followers: [], following: []);
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
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
    //final time =  timeago.format(widget.snap["datePublished"], locale: 'es');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                /*SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),*/
                // ************************************************************
                GestureDetector(
                  onTap: () {
                    /*Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailPlaceScreen(place: places[0], context: context,),
                      ),
                    );*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: widget.snap["postId"],
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5.0),
                            height: 350,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey[100]
                            ),
                            child: Stack(
                              children: [

                                ClipRRect(
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

                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              FutureBuilder(
                                                future: FirebaseFirestore.instance.collection('users').doc(widget.snap["uid"]).get(),
                                                builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  print("data = ${snapshot.data}");
                                                  return Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage(snapshot.data!["photoUrl"]),
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextCustom(text: snapshot.data!["username"], color: Colors.white, fontWeight: FontWeight.w500 ),
                                                          const TextCustom(text: "time", fontSize: 15, color: Colors.white ),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                  onPressed: (){},
                                                  icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 25)
                                              )

                                            ],
                                          ),
                                        ],
                                      ),

                                      Positioned(
                                          bottom: 15,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                            height: 45,
                                            width: SizeConfig.screenWidth * .9,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50.0),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  color: Colors.white.withOpacity(0.2),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () => FireStoreMethods().likePost(
                                                                  widget.snap["postId"],
                                                                  widget.snap["uid"],
                                                                  listImages,
                                                                ),
                                                                child: isLikeAnimating == true
                                                                    ? const Icon(Icons.favorite_rounded, color: Colors.red)
                                                                    : const Icon(Icons.favorite_outline_rounded, color: Colors.white),
                                                              ),
                                                              const SizedBox(width: 8.0),
                                                              InkWell(
                                                                  onTap: () {},
                                                                  child: TextCustom(text: widget.snap['likes'].length.toString(), fontSize: 16, color: Colors.white)
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(width: 20.0),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(context).push(
                                                                  MaterialPageRoute(builder: (context) =>
                                                                      CommentsScreen(postId: widget.snap['postId'].toString(),
                                                                      ),
                                                                  ),
                                                                ),
                                                            //Navigator.of(context).push(
                                                            //                     MaterialPageRoute(
                                                            //                       builder: (context) => CommentsScreen(
                                                            //                         postId: widget.snap['postId'].toString(),
                                                            //                       ),
                                                            //                     ),
                                                            //                   ),
                                                            /* => Navigator.push(
                                            context
                                            //routeFade(page: CommentsPostPage(uidPost: widget.posts.postUid))
                                        ),*/
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons.message, color: Colors.white),
                                                                const SizedBox(width: 5.0),
                                                                TextCustom(text: "View all $commentLen comments", fontSize: 16, color: Colors.white)
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: (){},
                                                            //icon: SvgPicture.asset('assets/svg/send-icon.svg', height: 24, color: Colors.white)
                                                            icon: const Icon(Icons.send, color: Colors.white,),
                                                          ),
                                                        ],
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
                ),
                // **************************************************
                AnimatedOpacity(
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
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

}
