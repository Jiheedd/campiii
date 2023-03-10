import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/size_config.dart';
import '../models/place_model.dart';
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


class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: SizeConfig.screenWidth > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                        print("data = ${snapshot.data}");
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                //widget.snap['profImage'].toString(),
                                snapshot.data!["photoUrl"],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    //widget.snap['username'].toString(),
                                    snapshot.data!["username"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                ),

                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
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
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
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
                    padding: const EdgeInsets.only(left: 40.0, bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: widget.snap["postId"],
                          child: Container(
                            width: double.infinity,
                            height: 250.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(widget.snap['images'][0].toString()),
                                //image: AssetImage(places[0].images![0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 40.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.snap['title'],
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              /*IconButton(
                                icon: const Icon(Icons.favorite_border),
                                iconSize: 30.0,
                                color: Theme.of(context).primaryColor,
                                onPressed: () => print('Favorite ${places[0].name}'),
                              ),*/
                              const Spacer(),
                              LikeAnimation(
                                isAnimating: widget.snap['likes'].contains(user.uid),
                                smallLike: true,
                                child: IconButton(
                                  icon: widget.snap['likes'].contains(user.uid)
                                      ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                      : const Icon(
                                    Icons.favorite_border,
                                  ),
                                  onPressed: () => FireStoreMethods().likePost(
                                    widget.snap['postId'].toString(),
                                    user.uid,
                                    widget.snap['likes'],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.comment_outlined,
                                ),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CommentsScreen(
                                      postId: widget.snap['postId'].toString(),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                  ),
                                  onPressed: () {

                                  }
                              ),
                              //Spacer(),
                              /*
                              Expanded(
                                  child: Align(
                                    alignment: Alignment.Right,
                                    child: IconButton(
                                        icon: const Icon(Icons.bookmark_border),
                                        onPressed: () {}
                                    ),
                                  )
                              )
                               */
                            ],
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
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    )),

                InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
