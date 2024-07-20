import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oziovariasi/screens/sign_in_screen.dart';
import 'package:oziovariasi/screens/add_post_screen.dart';
import 'package:oziovariasi/screens/detail_screen.dart';
import 'package:oziovariasi/screens/favorite_screen.dart';
import 'package:oziovariasi/screens/akun_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const HomeScreen({Key? key, this.onThemeChanged}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text('Home', style: textTheme.titleLarge),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: Icon(Icons.clear),
            ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: theme.dialogBackgroundColor,
                  title: Text('Cari Postingan', style: TextStyle(color: theme.textTheme.titleLarge!.color)),
                  content: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata kunci',
                      hintStyle: TextStyle(color: theme.hintColor),
                    ),
                    style: TextStyle(color: theme.textTheme.bodyLarge!.color),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Batal', style: TextStyle(color: theme.textTheme.bodyLarge!.color)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text('Cari', style: TextStyle(color: theme.textTheme.bodyLarge!.color)),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: theme.canvasColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                ),
                child: Text(
                  'Menu',
                  style: textTheme.titleLarge!.copyWith(color: theme.textTheme.titleLarge!.color),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: theme.textTheme.bodyLarge!.color),
                title: Text('Beranda', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: theme.textTheme.bodyLarge!.color),
                title: Text('Favorit', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoriteScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: theme.textTheme.bodyLarge!.color),
                title: Text('Profil', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AkunScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_6, color: theme.textTheme.bodyLarge!.color),
                title: Text('Mode Terang', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)),
                onTap: () {
                  if (widget.onThemeChanged != null) {
                    widget.onThemeChanged!(ThemeMode.light);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_2, color: theme.textTheme.bodyLarge!.color),
                title: Text('Mode Gelap', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)),
                onTap: () {
                  if (widget.onThemeChanged != null) {
                    widget.onThemeChanged!(ThemeMode.dark);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_auto, color: theme.textTheme.bodyLarge!.color),
                title: Text('Mode Sistem', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)),
                onTap: () {
                  if (widget.onThemeChanged != null) {
                    widget.onThemeChanged!(ThemeMode.system);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: theme.textTheme.bodyLarge!.color),
                title: Text('Logout', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: theme.dialogBackgroundColor,
                      title: Text('Konfirmasi Logout', style: TextStyle(color: theme.textTheme.bodyLarge!.color)),
                      content: Text('Apakah Anda yakin ingin logout?', style: TextStyle(color: theme.textTheme.bodyLarge!.color)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Batal', style: TextStyle(color: theme.textTheme.bodyLarge!.color)),
                        ),
                        TextButton(
                          onPressed: () {
                            signOut(context);
                          },
                          child: Text('Logout', style: TextStyle(color: theme.textTheme.bodyLarge!.color)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada postingan tersedia', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color)));
          }

          var posts = snapshot.data!.docs;
          var filteredPosts = posts.where((post) {
            var data = post.data() as Map<String, dynamic>;
            var username = data['username']?.toString().toLowerCase() ?? '';
            var text = data['text']?.toString().toLowerCase() ?? '';
            return username.contains(_searchController.text.toLowerCase()) ||
                text.contains(_searchController.text.toLowerCase());
          }).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              var post = filteredPosts[index];
              var data = post.data() as Map<String, dynamic>;
              var postTime = data['timestamp'] as Timestamp;
              var date = postTime.toDate();
              var formattedDate = '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';

              var username = data.containsKey('username') ? data['username'] : 'Anonim';
              var imageUrl = data.containsKey('image_url') ? data['image_url'] : '';
              var text = data.containsKey('text') ? data['text'] : '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        postId: post.id,
                        username: username,
                        imageUrl: imageUrl,
                        text: text,
                        formattedDate: formattedDate,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: theme.cardColor,
                  margin: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl.isNotEmpty)
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(child: Text('Gagal memuat gambar', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color))),
                          ),
                        )
                      else
                        Expanded(
                          child: Center(child: Text('Gambar tidak tersedia', style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color))),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username, style: textTheme.bodyLarge!.copyWith(color: theme.textTheme.bodyLarge!.color, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4.0),
                            Text(
                              text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium!.copyWith(color: theme.textTheme.bodyLarge!.color),
                            ),
                            const SizedBox(height: 4.0),
                            Text(formattedDate, style: textTheme.bodySmall!.copyWith(color: theme.textTheme.bodySmall!.color)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
      ),
    );
  }
}
