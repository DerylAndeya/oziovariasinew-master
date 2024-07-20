// FavoriteScreen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorite posts'));
          }

          try {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map;
                print('Document data: $data');
                return ListTile(
                  leading: data.containsKey('imageUrl') && data['imageUrl'].isNotEmpty
                      ? Image.network(data['imageUrl'])
                      : null,
                  title: data.containsKey('username')? Text(data['username']) : Text('No username'),
                  subtitle: data.containsKey('text')? Text(data['text']) : Text('No text'),
                );
              },
            );
          } catch (e, stacktrace) {
            print('Exception caught: $e');
            print(stacktrace);
            return Center(child: Text('An error occurred while processing data.'));
          }
        },
      ),
    );
  }
}
