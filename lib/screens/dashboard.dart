import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/route_manager.dart';

import 'package:record_admin/AlbumTile.dart';
import 'package:record_admin/helpers/AppColors.dart';
import 'package:record_admin/models/Album.dart';
import 'package:record_admin/screens/admin_add_podcast.dart';
import 'package:record_admin/screens/auth/auth_screen.dart';
import 'package:record_admin/screens/edit_chapter.dart';
import 'package:record_admin/screens/manage_carousel.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScrollController scrollController = ScrollController();

  _buildGridItem(BuildContext context, Album album) => InkWell(
        onTap: () {
          // Navigator.of(context).pushNamed(
          //   AppRoutes.albumDetail,
          //   arguments: album,
          // );
          Get.to(EditChapterScreen(album: album));
        },
        child: AlbumTile(album: album),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 10,
                ),
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        height: 40,
                        child: Image.asset('assets/images/logo.png')),
                    const Spacer(),
                    InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.off(() => const AuthScreen());
                        },
                        child: const Icon(Icons.logout)),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => AdminAddPodcast());
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            child: const Icon(
                              Icons.music_note,
                              size: 24,
                            ),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: primary),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Add Audio',
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const ManageSlider());
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            child: const Icon(
                              Icons.image,
                              size: 24,
                            ),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Manage Carousel',
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('albums').snapshots(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                if (snapshot.hasError) {
                  return Container();
                }
                List<DocumentSnapshot> docs = snapshot.data.docs;
                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  itemBuilder: (context, index) {
                    return _buildGridItem(
                        context, Album.fromJson(docs[index].data()));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
