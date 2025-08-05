
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_bucket_list/pages/home.dart';
import 'package:travel_bucket_list/pages/signup.dart';
import 'package:travel_bucket_list/services/database.dart';
import 'package:travel_bucket_list/services/shared_pref.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email="",password="",myname="",myid="";
  TextEditingController passwordcontroller=new TextEditingController();
  TextEditingController mailcontroller=new TextEditingController();
  userLogin() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
      QuerySnapshot querySnapshot=await DatabaseMethods().getUserbyEmail(email);
      myname="${querySnapshot.docs[0]["Name"]}";
      myid="${querySnapshot.docs[0]["Id"]}";
      await SharedPreferenceHelper().saveUserDisplayName(myname);
      await SharedPreferenceHelper().saveUserId(myid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Home()));
    } on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No user found for that Email",
        style: TextStyle(fontSize: 18.0,color: Colors.black),)));
      }else if(e.code=='wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("wrong password provided by the User",style: TextStyle(fontSize: 18.0,color: Colors.black),)) );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30.0),
  child: Center(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
      
          Text(
            "welcome!",
            style: TextStyle(
              color: Color.fromARGB(157, 255, 255, 255),
              fontSize: 34.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "LogIn",
            style: TextStyle(
              color: Colors.white,
              fontSize: 45.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 50.0),
          Text(
            "Email",
            style: TextStyle(
              color: Color.fromARGB(157, 255, 255, 255),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: mailcontroller,
            decoration: InputDecoration(
              hintText: "Enter Email",
              hintStyle: TextStyle(
                color: Color.fromARGB(219, 255, 255, 255),
              ),
              suffixIcon: Icon(Icons.email, color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20.0),
          Text(
            "Password",
            style: TextStyle(
              color: Color.fromARGB(157, 255, 255, 255),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            obscureText: true,
            controller: passwordcontroller,
            decoration: InputDecoration(
              hintText: "Enter Password",
              hintStyle: TextStyle(
                color: Color.fromARGB(219, 255, 255, 255),
              ),
              suffixIcon: Icon(Icons.password, color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          
          SizedBox(height: 40.0),
          GestureDetector(
            onTap: () {
              if(mailcontroller.text!="" && passwordcontroller.text!=""){
                setState(() {
                  email=mailcontroller.text;
                  password=passwordcontroller.text;
                });
              }
              userLogin();

            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(left: 20.0,right: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.amber[400],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "LogIn",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500
                  ),
                )),
              ),
            ),
           SizedBox(height: 50.0,),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            "Don't have an account?",
            style: TextStyle(
              color: Color.fromARGB(157, 255, 255, 255),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
            } ,
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: const Color.fromARGB(255, 113, 125, 194),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
            ],
          )
        ],
      ),
    ),
  ),
),
    );
  }
}