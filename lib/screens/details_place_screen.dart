import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/place_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:screenshot/screenshot.dart';


class DetailPlaceScreen extends StatefulWidget {
  final Place? place;
  //Function onChangeLike;
  bool isFavourite = false;
  late BuildContext? context;

  DetailPlaceScreen({
    Key? key,
    this.place,
    required this.isFavourite,
    //required this.onChangeLike,
    this.context
  }) : super(key: key);

  @override
  _DetailPlaceScreenState createState() => _DetailPlaceScreenState();
}

class _DetailPlaceScreenState extends State<DetailPlaceScreen> {

  var array;
  late List<String> images;
  var box;
  //final Directory directory = getApplicationDocumentsDirectory() as Directory;
  final screenshotController = ScreenshotController();
  // late Widget _screenshotDetailScreen;
  late int activeIndex;


  @override
  void initState() {
    super.initState();
    array = widget.place!.post!.Images;
    images = List<String>.from(array);
    box = widget.context!.findRenderObject() as RenderBox?;
    activeIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
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
              color: DarkBlueColor,
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

  Widget buildIndicator() => AnimatedSmoothIndicator(
    count: images.length,
    activeIndex: activeIndex,
    effect: JumpingDotEffect(
      dotWidth: getProportionateScreenWidth(13),
      dotHeight: getProportionateScreenWidth(13),
      dotColor: kPrimaryLightColor.withOpacity(0.2),
      jumpScale: 1.5
    ),
  );


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SafeArea(
                  child: CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                        activeIndex = itemIndex;
                        return Hero(
                          tag: widget.place!.post!.postId,
                          child: Container(
                            width: double.infinity,
                            height: getProportionateScreenHeight(350),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.place!.post!.Images[activeIndex],
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
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.place!.post!.title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    (widget.isFavourite==false) ? Icons.favorite_border : Icons.favorite,
                    size: 30.0,
                    color: kPrimaryLightColor,
                    //color: (isFavourite==false) ? kPrimaryLightColor : loveColor,
                    //onPressed: () {}
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                widget.place!.post!.description,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ),
            /*Expanded(
              child: SingleChildScrollView(
                child: DescriptionTextWidget(text:"jdiejdeijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
                    "jdiejdijiejijdjee"
                    "jdiejidjiejdijedje"
                    ""
                    ""
                    "jidejiedjedijdeidejiedjjde"
                    ""
                    "djiejdijedidejidejdejdeijdeidejideijdeijedjed"),
              ),
            ),*/
            Container(
              margin: EdgeInsets.only(top: getProportionateScreenHeight(30)),
              height: 120.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  const SizedBox(width: 30.0),
                  _buildInfoCard('Comments', widget.place!.comments.toString()),
                  _buildInfoCard('Category', "${places[0].category}"),
                  _buildInfoCard('Zone', places[0].zone!),
                  //_buildInfoCard('ID', widget.place!.post!.postId.toString()),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40), vertical: getProportionateScreenWidth(25)),
              child: const Text(
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
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(40), vertical: getProportionateScreenWidth(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              width: 60.0,
              child: IconButton(
                onPressed: () {
                  //_onShare(widget.context!);
                  //_onShareWithResult(widget.context!);
                },
                icon: const Icon(Icons.share),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final availableMaps = await MapLauncher.installedMaps;
                print("Availible maps = $availableMaps}");
                //MapUtils.openMap(36.80278, 10.17972);
                //MapLauncher.showDirections(mapType: MapType.google, destination: Coords(36.80278, 10.17972));
                MapLauncher.showDirections(mapType: availableMaps[0].mapType, destination: Coords(36.80278, 10.17972), destinationTitle: widget.place!.post!.title,);
                /*if ((await MapLauncher.isMapAvailable(MapType.google))!) {
                  await MapLauncher.showMarker(
                    mapType: MapType.google,
                    coords: Coords(36.80278, 10.17972),
                    title: "title",
                    description: "description",
                  );
                }*/

                //MapLauncher.launchCoordinates(37.2543799601, 10.0717163086, 'Google Map Cap Zebib');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(18), horizontal: getProportionateScreenWidth(20)),
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
  }

 /* void _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    if (images.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < images.length; i++) {
        files.add(XFile(images[i], name: "${widget.place!.post!.title} 1"));
      }
      Share.shareXFiles(files,
          text: widget.place!.post!.title,
          subject: widget.place!.post!.description,
          //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
      );
    } else {
      await Share.share(widget.place!.post!.title,
          subject: widget.place!.post!.description,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  void _onShareWithResult(BuildContext context) async {
    final Directory directory = await getApplicationDocumentsDirectory();

    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult;
    if (images.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < images.length; i++) {
        files.add(XFile(images[i], name: "${widget.place!.post!.title} 1"));
      }
      shareResult = await Share.shareXFiles(files,
          text: widget.place!.post!.title,
          subject: widget.place!.post!.description,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      shareResult = await Share.shareWithResult(widget.place!.post!.title,
          subject: widget.place!.post!.description,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));


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

  SnackBar getResultSnackBar(ShareResult result) {
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
  }

*/
}





