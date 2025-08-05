import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_bucket_list/pages/home.dart';
import 'package:travel_bucket_list/services/database.dart';
import 'package:travel_bucket_list/services/shared_pref.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ImagePicker _picker=ImagePicker();
  File? selectedImage;
  String userName = "";
  Future getImage()async{
    var image=await _picker.pickImage(source: ImageSource.gallery);
    selectedImage=File(image!.path);
    setState(() {
      
    });
  }
  TextEditingController placenamecontroller=new TextEditingController();
  TextEditingController citynamecontroller=new TextEditingController();
  TextEditingController captioncontroller=new TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserName();
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName =
          prefs.getString(SharedPreferenceHelper.userNameKey) ?? "Unknown";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 40.0),
              child: Row(
                children: [
                  GestureDetector(
                     onTap: () {
                       Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30)),
                        child: Icon(Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                        
                        )
                        ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/4.5,),
                  Text("Add Post",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold
                    ),
                    ),
                   
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Expanded(
               child: SingleChildScrollView(
                 child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                   child:  Container(
                    padding: EdgeInsets.only(left: 20.0,right: 10.0,top: 30.0),
                              decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))) ,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 GestureDetector (
                                  onTap: () {
                                    getImage();  
                                  },
                                    child: selectedImage!=null?Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(selectedImage!,height: 180,
                                          width: 180,fit: BoxFit.cover,),
                                      ),
                                    ):
                                                                Center(
                                    child: Container(
                                      height: 180,
                                      width: 180,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.black45,width: 2.0),borderRadius: BorderRadius.circular(20)),
                                      child: Icon(Icons.camera_alt_outlined),
                                    ),
                                                                ),
                                  ),
                                SizedBox(height: 10.0,),
                                Text("Place Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(color:Color(0xFFececf8),borderRadius: BorderRadius.circular(10) ),
                        child: TextField(
                          controller: placenamecontroller,
                          decoration: InputDecoration(border: InputBorder.none,hintText: "Enter Place Name"),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                                Text("City Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(color:Color(0xFFececf8),borderRadius: BorderRadius.circular(10) ),
                        child: TextField(
                          controller: citynamecontroller, 
                          decoration: InputDecoration(border: InputBorder.none,hintText: "Enter City Name"),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                                Text("Caption",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(color:Color(0xFFececf8),borderRadius: BorderRadius.circular(10) ),
                        child: TextField(
                          controller: captioncontroller,
                          maxLines: 6,
                          decoration: InputDecoration(border: InputBorder.none,hintText: "Enter Caption..."),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      GestureDetector(
                        onTap: ()async {
                          if(selectedImage!=null && placenamecontroller.text!=""&& citynamecontroller.text!="" && captioncontroller.text!=""){
                            Map<String,dynamic>addPost={
                              "PlaceName":placenamecontroller.text,
                              "CityName":citynamecontroller.text,
                              "Caption":captioncontroller.text,
                              "UserName": userName,
                              "imagePath": selectedImage!.path,
                               "likes": 0,
                            };
                           String postId = randomAlphaNumeric(10); 
                         
                          await DatabaseMethods().addPost(addPost, postId);
                         
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             backgroundColor: const Color.fromARGB(255, 18, 117, 21),
                             content: Text(
                         "Post has uploaded Successfully",
                         style: TextStyle(fontSize: 20.0, color: Colors.white),
                             ),
                           ),
                         );
                         
                            
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
                            child:  Text("Post",
                                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold
                          ),
                          ),
                          ),
                        ),
                      )
                         
                              ]))),
               ))
            ],
          ),
        ),
      ),
      
    );
  }
}