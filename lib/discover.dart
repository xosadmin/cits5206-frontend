import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://example.com/profile.jpg'),
              ),
            ),
            title: Text('Discover'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  print("Settings pressed");
                },
              ),
            ],
          ),
          body: DiscoverBody(),
        ),
    );
  }
}

class DiscoverBody extends StatelessWidget {
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(items[index]),
            subtitle: Text('Description of ${items[index]}'),
            leading: Icon(Icons.explore),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to a detailed view or perform another action
              print('Tapped on ${items[index]}');
            },
          ),
        );
      },
    );
  }
}

void main() =>
    runApp(MaterialApp(
      home: DiscoverPage(),
    ));
