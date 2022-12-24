import 'package:cloud_firestore/cloud_firestore.dart';

class PostSecond {

  final String postUid;
  final int isComment;
  final String typePrivacy;
  final DateTime createdAt;
  final String personUid;
  final String username;
  final String avatar;
  final String images;
  final int countComment;
  final int countLikes;
  final int isLike;

  const PostSecond({
    required this.postUid,
    required this.isComment,
    required this.typePrivacy,
    required this.createdAt,
    required this.personUid,
    required this.username,
    required this.avatar,
    required this.images,
    required this.countComment,
    required this.countLikes,
    required this.isLike
  });


  static PostSecond fromSnap(DocumentSnapshot snap) {

    var snapshot = snap.data() as Map<String, dynamic>;

    return PostSecond(
        postUid: snapshot["post_uid"],
        isComment: snapshot["is_comment"],
        typePrivacy: snapshot["type_privacy"],
        createdAt: DateTime.parse(snapshot["created_at"]),
        personUid: snapshot["person_uid"],
        username: snapshot["username"],
        avatar: snapshot["avatar"],
        images: snapshot["images"],
        countComment: snapshot["count_comment"] ?? -0,
        countLikes: snapshot["count_likes"] ?? -0,
        isLike: snapshot["is_like"] ?? -0
    );
  }

  Map<String, dynamic> toJson() => {
    "post_uid": postUid,
    "is_comment": isComment,
    "type_privacy": typePrivacy,
    "created_at": createdAt.toIso8601String(),
    "person_uid": personUid,
    "username": username,
    "avatar": avatar,
    "images": images,
    "count_comment": countComment,
    "count_likes": countLikes,
    "is_like": isLike
  };
}