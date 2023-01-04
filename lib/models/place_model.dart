import '../models/user.dart';
import 'post.dart';

class Place {
  Post? post;
  UserModel? owner;
  int? comments;
  List<String>? category;
  String? zone;

  Place({
    this.post,
    this.owner,
    this.comments,
    this.category,
    this.zone,
  });
}

var owner = const UserModel(
    username: 'Fallega Team',
    photoUrl: 'assets/img/user.png',
    uid: '', email: '', bio: '',
    followers: [], following: [],
  );
var places = [
  Place(
    owner: owner,
    comments: 21,
    category: ['جبل','غابة'],
    zone: 'SAFE',
  ),
  Place(
    owner: owner,
    comments: 9,
    category: ['غابة'],
    zone: 'DANGER',
  ),
];
