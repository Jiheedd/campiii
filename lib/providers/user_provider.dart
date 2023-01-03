import 'package:flutter/widgets.dart';
import '../models/user.dart';
import '../resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserProvider(){
    refreshUser();
  }

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    //DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    //_user = UserModel.fromSnap(documentSnapshot);
    notifyListeners();
  }

  UserModel get getUser {
    print("user provider = ${_user!.username}");

    return _user!;
  }
      //??UserModel(username: FirebaseAuth.instance.currentUser!.displayName!, uid: FirebaseAuth.instance.currentUser!.uid, photoUrl: FirebaseAuth.instance.currentUser!.photoURL!, email: "email", bio: "bio", followers: [], following: []);
}