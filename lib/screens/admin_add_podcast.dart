import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:record_admin/helpers/my_loader.dart';
import 'package:record_admin/models/Album.dart';
import 'package:record_admin/models/Track.dart';
import 'package:record_admin/providers/media_provider.dart';
import 'package:record_admin/screens/dashboard.dart';
import 'package:record_admin/widgets/my_text_field.dart';

class AdminAddPodcast extends StatefulWidget {
  @override
  State<AdminAddPodcast> createState() => _AdminAddPodcastState();
}

class _AdminAddPodcastState extends State<AdminAddPodcast> {
  List<File> audioFiles = [];
  File cover;
  String title;
  String description;
  List<Track> tracks = [];
  List<String> descriptions = [];
  List<String> names = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Get.to(() => const Dashboard());
          },
        ),
        elevation: 0,
        title: const Text(
          'Add Audio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: GestureDetector(
                    onTap: () async {
                      FilePickerResult result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        cover = File(result.files.single.path);
                        setState(() {});
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor.withOpacity(0.4),
                      ),
                      child: cover == null
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                SizedBox(height: 5),
                                Text('Select cover Image'),
                              ],
                            ))
                          : Image.file(
                              cover,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                myTextField(
                    hint: 'Title',
                    onChanged: (val) {
                      setState(() {
                        title = val;
                      });
                    }),
                const SizedBox(height: 15),
                myTextField(
                    hint: 'Description',
                    onChanged: (val) {
                      setState(() {
                        description = val;
                      });
                    }),
                const SizedBox(height: 15),
                const Text(
                  'Add Tracks',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                ...List.generate(
                  tracks.length,
                  (index) => Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          FilePickerResult result = await FilePicker.platform
                              .pickFiles(allowMultiple: true);

                          if (result != null) {
                            audioFiles =
                                result.paths.map((path) => File(path)).toList();
                            setState(() {});
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(25),
                          child: const Icon(Icons.music_note),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: myTextField(hint: 'Title'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                if (audioFiles.isEmpty)
                  InkWell(
                    onTap: () async {
                      FilePickerResult result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);

                      if (result != null) {
                        audioFiles =
                            result.paths.map((path) => File(path)).toList();
                        setState(() {});
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(25),
                      child: const Icon(Icons.music_note),
                    ),
                  ),
                ...List.generate(audioFiles.length, (index) {
                  descriptions.add('');
                  names.add('');

                  return albumAudioTile(audioFiles[index], index);
                }),
                const SizedBox(
                  height: 60,
                ),
              ]),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  List<String> trackurls = [];
                  final result = await FirebaseStorage.instance
                      .ref('covers/${DateTime.now().toIso8601String()}')
                      .putFile(cover);
                  final url = await result.ref.getDownloadURL();

                  await Future.wait(audioFiles.map((file) async {
                    final result = await FirebaseStorage.instance
                        .ref('audios/${DateTime.now().toIso8601String()}')
                        .putFile(file);
                    final url = await result.ref.getDownloadURL();
                    trackurls.add(url);
                  }));
                  final trackList = trackurls
                      .map((e) => Track(
                            trackurls.indexOf(e),
                            // descriptions[trackurls.indexOf(e)],
                            names[trackurls.indexOf(e)],
                            descriptions[trackurls.indexOf(e)],
                            e,
                            url,
                            null,
                            DateTime.now().toIso8601String(),
                          ))
                      .toList();

                  try {
                    await Provider.of<MediaProvider>(context, listen: false)
                        .uploadMedia(Album(
                            DateTime.now().millisecondsSinceEpoch,
                            title,
                            description,
                            url,
                            trackList));
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                  }

                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Uploaded'),
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: isLoading
                        ? const MyLoader()
                        : const Text(
                            'Upload',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget albumAudioTile(File file, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              FilePickerResult result =
                  await FilePicker.platform.pickFiles(allowMultiple: false);

              if (result != null) {
                setState(() {
                  audioFiles.add(File(result.paths.first));
                });
              } else {
                // User canceled the picker
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.music_note),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          file.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        audioFiles.remove(file);
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                myTextField(
                    hint: 'Name of audio',
                    onChanged: (val) {
                      setState(() {
                        names[index] = val;
                      });
                    }),
                const SizedBox(height: 10),
                myTextField(
                    hint: 'Subtitles',
                    onChanged: (val) {
                      setState(() {
                        descriptions[index] = val;
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
