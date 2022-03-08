import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:record_admin/models/Album.dart';
import 'package:record_admin/models/Track.dart';

class MediaProvider with ChangeNotifier {
  Future<void> uploadMedia(Album album) async {
    await FirebaseFirestore.instance
        .collection('albums')
        .doc(album.id.toString())
        .set(album.toJson());
    notifyListeners();
  }

  Future<void> deleteAlbum(String id) async {
    await FirebaseFirestore.instance.collection('albums').doc(id).delete();
    notifyListeners();
  }

  Future<void> updateAlbum(Album album) async {
    await FirebaseFirestore.instance
        .collection('albums')
        .doc(album.id.toString())
        .update(album.toJson());
    notifyListeners();
  }

  Future<void> deleteTrack(String id, int index) async {
    await FirebaseFirestore.instance.collection('albums').doc(id).update({
      'tracks': FieldValue.arrayRemove([index])
    });
    notifyListeners();
  }

  Future<void> addTrack(String id, List<Track> tracks) async {
    FirebaseFirestore.instance.collection('albums').doc(id).update({
      'tracks': FieldValue.arrayUnion([tracks.map((e) => e.toJson()).toList()])
    });
    notifyListeners();
  }
}
