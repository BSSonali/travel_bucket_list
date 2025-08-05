import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods{
  Future addUserDetails(Map<String,dynamic>userInfoMap,String id)async{
    return await FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);
  }
  Future<QuerySnapshot> getUserbyEmail(String email)async{
    return await FirebaseFirestore.instance.collection("users").where("Email",isEqualTo: email).get();
  }
   Future addPost(Map<String,dynamic>userInfoMap,String id)async{
    return await FirebaseFirestore.instance.collection("Posts").doc(id).set(userInfoMap);
  }
}