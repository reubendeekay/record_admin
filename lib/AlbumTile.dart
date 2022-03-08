import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:record_admin/helpers/BaseMixins.dart';
import 'package:record_admin/models/Album.dart';
import 'package:record_admin/providers/media_provider.dart';
import 'package:record_admin/widgets/BaseImage.dart';

class AlbumTile extends StatelessWidget with BaseMixins {
  final Album album;
  const AlbumTile({Key key, this.album}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              BaseImage(
                heroId: album.id,
                imageUrl: album.cover,
                height: height * 0.2,
                width: 150,
                radius: 5.0,
              ),
              const Positioned(
                  right: 10,
                  bottom: 10,
                  child: Icon(
                    AntDesign.playcircleo,
                    color: Colors.white,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  album.title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Center(
                                child: Text('Delete ${album.title} Chapter')),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Lottie.asset(
                                    'assets/delete.json',
                                    height: 100,
                                  ),
                                  const Text(
                                    'Notice that this action is irreversible. Do you want to continue?',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                width: 120,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<MediaProvider>(context,
                                          listen: false)
                                      .deleteAlbum(album.id.toString());
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                width: 25,
                              )
                            ],
                          ));
                },
                child: const Icon(
                  FlutterIcons.delete_ant,
                  size: 20,
                ),
              ),
            ],
          ),
          // Text(
          //   album.tracks != null ? '${album.tracks.length} Tracks' : '0 Tracks',
          //   style:const TextStyle(
          //     fontSize: 10,
          //   ),
          // ),
        ],
      ),
    );
  }
}
