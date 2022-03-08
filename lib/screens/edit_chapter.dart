import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:record_admin/helpers/my_loader.dart';
import 'package:record_admin/models/Album.dart';
import 'package:record_admin/models/Track.dart';
import 'package:record_admin/providers/media_provider.dart';
import 'package:record_admin/screens/dashboard.dart';
import 'package:record_admin/widgets/my_text_field.dart';

class EditChapterScreen extends StatefulWidget {
  const EditChapterScreen({Key key, @required this.album}) : super(key: key);
  final Album album;

  @override
  State<EditChapterScreen> createState() => _EditChapterScreenState();
}

class _EditChapterScreenState extends State<EditChapterScreen> {
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
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Center(
                            child:
                                Text('Delete ${widget.album.title} Chapter')),
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
                              Provider.of<MediaProvider>(context, listen: false)
                                  .deleteAlbum(widget.album.id.toString());
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
                          const SizedBox(
                            height: 50,
                          ),
                          const SizedBox(
                            width: 25,
                          )
                        ],
                      ));
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
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
                      child: widget.album.content != null
                          ? Image.network(
                              widget.album.cover,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              cover,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                myTextField(
                    hint: 'Title: ${widget.album.title}',
                    onChanged: (val) {
                      setState(() {
                        title = val;
                      });
                    }),
                const SizedBox(height: 15),
                myTextField(
                    hint: 'Description: ${widget.album.content}',
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
                if (tracks.isEmpty)
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
                ...List.generate(widget.album.tracks.length, (index) {
                  descriptions.add('');
                  names.add('');

                  return albumAudioTile(widget.album.tracks[index], index);
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

                  final trackList = widget.album.tracks
                      .map((e) => Track(
                            widget.album.tracks.indexOf(e),
                            // descriptions[widget.album.tracks.indexOf(e)],
                            names[widget.album.tracks.indexOf(e)].isNotEmpty ??
                                widget
                                    .album
                                    .tracks[widget.album.tracks.indexOf(e)]
                                    .title,
                            descriptions[widget.album.tracks.indexOf(e)]
                                    .isNotEmpty ??
                                widget
                                    .album
                                    .tracks[widget.album.tracks.indexOf(e)]
                                    .content,
                            widget.album.tracks[widget.album.tracks.indexOf(e)]
                                .url,
                            widget.album.tracks[widget.album.tracks.indexOf(e)]
                                .cover,
                            null,
                            DateTime.now().toIso8601String(),
                          ))
                      .toList();

                  try {
                    await Provider.of<MediaProvider>(context, listen: false)
                        .updateAlbum(Album(
                            DateTime.now().millisecondsSinceEpoch,
                            title,
                            description,
                            widget.album.cover,
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
                            'Save changes',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget audioWidget(File file) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Text(file.path.split('/').last),
          const Spacer(),
          InkWell(
            onTap: () {
              audioFiles.remove(file);
              setState(() {});
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

  Widget albumAudioTile(Track file, int index) {
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
                myTextField(
                    hint: file.title,
                    onChanged: (val) {
                      setState(() {
                        names[index] = val;
                      });
                    }),
                const SizedBox(height: 10),
                myTextField(
                    hint: file.content,
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
