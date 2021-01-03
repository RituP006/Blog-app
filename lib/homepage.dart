import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'authentication.dart';
import 'photoupload.dart';
import 'models/post.dart';
import './widgets/postUI.dart';

class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  HomePage({this.auth, this.onSignedOut});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postslist = [];

  //this method will be invoked whenever the user comes to homepage
  @override
  void initState() {
    super.initState();

    // retriving reference to post node in real time database
    DatabaseReference postReference =
        FirebaseDatabase.instance.reference().child('Posts');

    postReference.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      postslist.clear();

      for (var individualKey in keys) {
        Posts post = Posts(
          data[individualKey]['image'],
          data[individualKey]['description'],
          data[individualKey]['date'],
          data[individualKey]['time'],
        );

        postslist.add(post);
      }

      setState(() {
        print('length : $postslist.length');
      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      print('*****************************************Widget : $widget');
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print('widget : $widget');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: postslist.length == 0
            ? Text('No Blog Post Available, Add now')
            : ListView.builder(
                itemCount: postslist.length,
                itemBuilder: (_, index) {
                  print(postslist[index].image);
                  return PostsUI(
                      postslist[index].image,
                      postslist[index].description,
                      postslist[index].date,
                      postslist[index].time);
                }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).accentColor,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                // color: Theme.of(context).primaryColor,
                icon: Icon(Icons.people),
                onPressed: _logoutUser,
                iconSize: 40,
              ),
              IconButton(
                // color: Theme.of(context).primaryColor,
                icon: Icon(Icons.add_a_photo),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UploadPhotoPage();
                  }));
                },
                iconSize: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
