import 'package:flutter/material.dart';
import 'story_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Stories',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> usersStories = [
    {
      'user': 'Vetrimaaran',
      'stories': [
        'https://picsum.photos/400/800?random=1',
        'https://picsum.photos/400/800?random=2',
        'https://picsum.photos/400/800?random=3',
      ],
      'profilePhoto': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdVqQ8Qk674o6_xaA8bIxbEScp0g-fVPYcbLYKuZYCXxtAbp7R',
    },
    {
      'user': 'Sudha Kongara',
      'stories': [
        'https://picsum.photos/400/800?random=4',
        'https://picsum.photos/400/800?random=5',
        'https://picsum.photos/400/800?random=6',
        'https://picsum.photos/400/800?random=7',
      ],
      'profilePhoto': 'https://images.ottplay.com/images/sudha-kongara-1720152278.jpg?impolicy=images_ottplay_com-108673182023&width=274&height=154',
    },
    {
      'user': 'Balu Mahendra',
      'stories': [
        'https://picsum.photos/400/800?random=8',
        'https://picsum.photos/400/800?random=9',
      ],
      'profilePhoto': 'https://images.ottplay.com/images/moondram-pirai-287.jpg?impolicy=ottplay-20210210&width=1200&height=675',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
      ),
      body: ListView.builder(
        itemCount: usersStories.length,
        itemBuilder: (context, index) {
          final userStory = usersStories[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userStory['profilePhoto']),
            ),
            title: Text(userStory['user']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryPage(
                    user: userStory['user'],
                    stories: userStory['stories'],
                    usersStories: usersStories,
                    currentUserIndex: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
