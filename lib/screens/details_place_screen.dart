import 'dart:io';
import 'dart:typed_data';

import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/place_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:screenshot/screenshot.dart';


class DetailPlaceScreen extends StatefulWidget {
  final Place? place;
  late BuildContext? context;

  DetailPlaceScreen({Key? key, this.place, this.context}) : super(key: key);

  @override
  _DetailPlaceScreenState createState() => _DetailPlaceScreenState();
}

class _DetailPlaceScreenState extends State<DetailPlaceScreen> {
  bool isFavourite = false;
  List<int> imageBytes = [];
  Uint8List? listBytes;
  final screenshotController = ScreenshotController();
  late Widget _screenshotDetailScreen;

  @override
  void initState() {
    _screenshotDetailScreen = Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SafeArea(
                  child: CarouselSlider.builder(
                      itemCount: widget.place!.images!.length,
                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                        activeIndex = itemIndex;
                        return Hero(
                          tag: widget.place!.id!,
                          child: Container(
                            width: double.infinity,
                            height: 350.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  widget.place!.images![activeIndex],
                                ),
                                fit: BoxFit.cover,
                              ),
                              //borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: SizeConfig.screenHeight*0.4,
                        aspectRatio: 16/9,
                        viewportFraction: 1,
                        initialPage: 0,
                        //pauseAutoPlayOnManualNavigate: ,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(seconds: 2),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activeIndex = index;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight*0.4),
                  child: Center(
                    child: buildIndicator(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getProportionateScreenHeight(40), left: 10.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(widget.context!),
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.place!.name!,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: (isFavourite==false) ? const Icon(Icons.favorite_border) : const Icon(Icons.favorite),
                    iconSize: 30.0,
                    color: kPrimaryColor,
                    onPressed: () => setState(() {
                      isFavourite = !isFavourite;
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                widget.place!.description!,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              height: 120.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  const SizedBox(width: 30.0),
                  _buildInfoCard('Comments', widget.place!.comments.toString()),
                  _buildInfoCard('Category', "${widget.place!.category!}"),
                  _buildInfoCard('Zone', widget.place!.zone!),
                  _buildInfoCard('ID', widget.place!.id.toString()),
                ],
              ),
            ),
            /*Container(
              margin: const EdgeInsets.only(left: 20.0, top: 30.0),
              width: double.infinity,
              height: 90.0,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF2D0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                leading: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 40.0,
                      width: 40.0,
                      image: AssetImage(owner.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  owner.name!,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'groupe',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Montserrat',
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => print('Share'),
                  icon: const Icon(FontAwesomeIcons.peopleGroup),
                ),
              ),
            ),*/
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
              child: Text(
                "Description",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              width: 60.0,
              child: IconButton(
                onPressed: () async{
                  _onShareWithResult(widget.context!);
                },
                icon: const Icon(Icons.share),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                //MapUtils.openMap(36.80278, 10.17972);
                //MapLauncher.showDirections(mapType: "mapType", destination: );
                //MapsLauncher.launchCoordinates(37.2543799601, 10.0717163086, 'Google Map Cap Zebib');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                ),
              ),
              icon: const Icon(
                FontAwesomeIcons.mapLocationDot,
                color: Colors.white,
              ),
              label: const Text(
                ' Itinétaire',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    super.initState();
  }


  Widget _buildInfoCard(String label, String info) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 100.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2F7),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            info,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: (info=="SAFE")?safeZoneColor:(info=="DANGER")?
              dangerZoneColor : (info=="NORMAL")?
              normalZoneColor : darkColor,
            ),
          ),
        ],
      ),
    );
  }

  int activeIndex = 0;
  Widget buildIndicator() => AnimatedSmoothIndicator(
    count: widget.place!.images!.length,
    activeIndex: activeIndex,
    effect: const JumpingDotEffect(
      dotWidth: 15,
      dotHeight: 15,
      dotColor: kPrimaryLightColor,
      jumpScale: 1.5
    ),
  );


  @override
  Widget build(BuildContext context) {

    return _screenshotDetailScreen;
  }

  void _onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final Directory directory = await getApplicationDocumentsDirectory();

    Directory(directory.path).create(recursive: true).then((dir) {
      print("dir = ${dir.path}");
      screenshotController.captureAndSave(dir.path).then((value) async{
        print("after value = $value");
        if (value!.isNotEmpty) {
          await Share.shareFilesWithResult(
              [value],
              text: "Cap Zebib",
              subject: "Dar El Ain",
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size).then((value) => print("result = ${value.status}"));
        } else {
          await Share.shareWithResult(
              "text",
              subject: "subject",
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size).then((value) => print("result = ${value.status}"));
        }
      });
    });
  }

  FlatButton(double _height, double _width) {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    minimumSize: Size(_width, _height),
    backgroundColor: Colors.grey,
    padding: EdgeInsets.all(0),
  );
  return TextButton(
    style: flatButtonStyle,
    onPressed: () {},
    child: Text(
    "some text",
    style: TextStyle(color: Colors.white),
    ),
  );
}

}





