import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:record_admin/models/Album.dart';

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
}
