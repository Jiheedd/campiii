import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../utils/size_config.dart';
import '../utils/utils.dart';
import 'package:provider/provider.dart';

import 'feed_screen.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  //final _keyForm = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Not Used for now
  // *******************
  /*_selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }*/
  // ********************

  void postImage(String uid) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _titleController.text,
        _descriptionController.text,
        _file!,
        uid,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
        clearTextFields();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FeedScreen(),));
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearTextFields() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    //UserProvider().refreshUser();
  }



  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              /*leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  //Navigator.of(context).pop();
                  //clearImage;
                },
              ),*/
              title: const Text(
                'Post to',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    postImage(userProvider.getUser.uid,);
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            //body: const Center(child: Text("add Post")),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  isLoading
                      ? const LinearProgressIndicator()
                      : SizedBox(height: SizeConfig.screenHeight * 0.02),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20), horizontal: getProportionateScreenWidth(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            userProvider.getUser.photoUrl,
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                    hintText: "Write the title...",
                                    border: InputBorder.none),
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.7,
                              child: TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                    hintText: "Write a caption...",
                                    border: InputBorder.none),
                                maxLines: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //const Divider(),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.3,
                    width: SizeConfig.screenWidth * 0.8,
                    child: Center(
                      //alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 3/2,
                        child: _file == null
                            ? Container()
                            : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(_file!),
                              )),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 5.0),
                ],
              ),
            ),
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  splashRadius: 20,
                  color: Colors.white,
                  onPressed: () async {
                    //Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                  //icon: SvgPicture.asset('assets/svg/gallery.svg')),
                  icon: const Icon(Icons.image_outlined),
                ),
                IconButton(
                  splashRadius: 20,
                  color: Colors.white,
                  onPressed: () async {
                    //Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                  //icon: SvgPicture.asset('assets/svg/camera.svg')
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
                IconButton(
                  splashRadius: 20,
                  color: Colors.white,
                  onPressed: () {
                    print("get location point");
                  },
                  //icon: SvgPicture.asset('assets/svg/location.svg')),
                  icon: const Icon(Icons.location_on_outlined),
                ),
              ],
            ),
          );

  }
}
