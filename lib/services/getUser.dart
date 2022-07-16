import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kimyapar/models/UserModel.dart';

class UserHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<UserModel> list = [];

  Future<UserHelper> init() async {
    await retrieveUsers().then((value) {
      list = value;
      // print(list.length);
    });
    filterGeo();
    return this;
  }

  Future<List<UserModel>> retrieveUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("users").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  double drawDistance  (double lat, long, endLat,endLong){
     return Geolocator.distanceBetween(lat, long, endLat, endLong);
  }
  
  List<UserModel>filterGeo() {
    List<UserModel> nearList = [];
    nearList.addAll(list);

    nearList.retainWhere((element) => drawDistance(element.lat, element.long, 40.599391, 33.610534)<1200);
    print(nearList.length);
    nearList.forEach((element) {print(element.name);});
    return nearList;
  }
}