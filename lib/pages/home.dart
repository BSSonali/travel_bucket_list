import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_bucket_list/pages/add_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_bucket_list/pages/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  List<bool> likedStatus = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    "images/campvan.jpg",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, right: 20.0),
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddPage()),
                            );
                          },
                          child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        TextButton(
  onPressed: _logout,
  style: TextButton.styleFrom(
    backgroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Text(
    'Logout',
    style: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 160.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Travo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato'),
                        ),
                        Text(
                          "Travel Community App",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var posts = snapshot.data!.docs;

                  if (likedStatus.length != posts.length) {
                    likedStatus = List.generate(posts.length, (index) => false);
                  }

                  if (posts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "No posts yet. Add one!",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      var placeName = post['PlaceName'] ?? '';
                      var cityName = post['CityName'] ?? '';
                      var caption = post['Caption'] ?? '';
                      var userName = post.data().containsKey('UserName')
                          ? post['UserName']
                          : 'Unknown';
                      var imagePath = post.data().containsKey('imagePath')
                          ? post['imagePath']
                          : '';
                      var likes = post.data().containsKey('likes') ? post['likes'] : 0;

                      return Container(
                        margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20.0),
                                imagePath.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          File(imagePath),
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Center(child: Icon(Icons.image)),
                                      ),
                                const SizedBox(height: 5.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.blue),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          "$placeName, $cityName",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    caption,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    "Posted by: $userName",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        likedStatus[index]
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: likedStatus[index] ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          likedStatus[index] = !likedStatus[index];
                                        });

                                        int updatedLikes = likedStatus[index]
                                            ? likes + 1
                                            : (likes > 0 ? likes - 1 : 0);

                                        FirebaseFirestore.instance
                                            .collection('Posts')
                                            .doc(post.id)
                                            .update({'likes': updatedLikes});
                                      },
                                    ),
                                    Text(
                                      "$likes ${likes == 1 ? 'Like' : 'Likes'}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
