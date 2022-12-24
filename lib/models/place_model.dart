import '../models/user.dart';

class Place {
  final UserModel? owner;
  final String? name;
  final List<String>? images;
  final String? description;
  final int? comments;
  final List<String>? category;
  final String? zone;
  final int? id;

  Place({
    this.owner,
    this.name,
    this.images,
    this.description,
    this.comments,
    this.category,
    this.zone,
    this.id,
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
    name: 'Cap Zbib',
    images: [
      'assets/img/cap_zbib.jpg',
      'assets/img/dar_el_ain.jpg',
      'assets/img/cap_zbib.jpg',
      'assets/img/user.png',
      'assets/img/cap_zbib.jpg',
      'assets/img/dar_el_ain.jpg',
      'assets/img/cap_zbib.jpg',
      'assets/img/user.png',
      'assets/img/cap_zbib.jpg',
      'assets/img/dar_el_ain.jpg',
    ],
    description: 'Bizerte Tunisia',
    comments: 21,
    category: ['جبل','غابة'],
    zone: 'SAFE',
    id: 12,
  ),
  Place(
    owner: owner,
    name: 'Dar El Ain',
    images: [
      'assets/img/cap_zbib.jpg',
      'assets/img/dar_el_ain.jpg',
      'assets/img/search.png',
      'assets/img/logo.png',
    ],
    description: 'Tabarka Jendouba',
    comments: 9,
    category: ['غابة'],
    zone: 'DANGER',
    id: 98,
  ),
];
