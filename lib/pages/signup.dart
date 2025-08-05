import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:travel_bucket_list/pages/home.dart';
import 'package:travel_bucket_list/pages/login.dart';
import 'package:travel_bucket_list/services/database.dart';
import 'package:travel_bucket_list/services/shared_pref.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email="",password="",name="";
  TextEditingController namecontroller=new TextEditingController();
  TextEditingController Passwordcontroller=new TextEditingController();
  TextEditingController mailcontroller=new TextEditingController();
  

  registration() async {
    if (password != null && namecontroller.text!=""&& mailcontroller.text!="") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
            String id=randomAlphaNumeric(10);
            Map<String,dynamic> userInfoMap={
              "Name":namecontroller.text,
              "Email":mailcontroller.text,
              "Id":id
            };
            await SharedPreferenceHelper().saveUserDisplayName(namecontroller.text);
            await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
            await SharedPreferenceHelper().saveUserId(id);

            await DatabaseMethods().addUserDetails(userInfoMap, id).then((value){
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: const Color.fromARGB(255, 18, 117, 21),
                content:Text("Registered Successfully",style: TextStyle(fontSize:20.0,color: Colors.green),
                )));
                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Home()));
            });
      }
    on FirebaseAuthException catch(e){
      if(e.code=='weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.orangeAccent,
        content: Text("password provided is too weak",
        style: TextStyle(fontSize: 18.0),),));
      }else if(e.code=="email-already-in-use"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.orangeAccent,
        content: Text("Account already exists",
        style: TextStyle(fontSize: 18.0),),));
      }
    }   
    }
  }

  @override
  Widget build(BuildContext context) {
     return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30.0),
  child: Center(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 45.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 50.0),
          Text(
            "Name",
            style: TextStyle(
              color: Color.fromARGB(157, 255, 255, 255),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: namecontroller,
            decoration: InputDecoration(
              hintText: "Enter Name",
              hintStyle: TextStyle(
                color: Color.fromARGB(219, 255, 255, 255),
              ),
              suffixIcon: Icon(Icons.person, color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 40.0),
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
          SizedBox(height: 40.0),
          Text(
            "Password",
            style: TextStyle(
              color: Color.fromARGB(157, 255, 255, 255),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: Passwordcontroller,
            decoration: InputDecoration(
              hintText: "Enter Password",
              hintStyle: TextStyle(
                color: Color.fromARGB(219, 255, 255, 255),
              ),
              suffixIcon: Icon(Icons.password, color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 50.0),
          GestureDetector(
            onTap: () {
              if(Passwordcontroller.text!=""&& namecontroller.text!=""&& mailcontroller.text!=""){
                setState(() {
                   name=namecontroller.text;
                password=Passwordcontroller.text;
                email=mailcontroller.text;
                });
               registration();
              }
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(left: 20.0,right: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.amber[400],
                borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text("Sign Up",
                  style: TextStyle(color: Colors.black,fontSize: 24.0,fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            "Already have an account?",
            style: TextStyle(
              color: Color.fromARGB(157, 255, 255, 255),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
            } ,
            child: Text(
              "Login",
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
  