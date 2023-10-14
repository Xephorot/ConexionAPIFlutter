import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  final List<dynamic> data;

  InfoScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información completa'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow, Colors.orange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListTile(
                leading: Image.network(data[index]['srcSmall']),
                title: Text(data[index]['prompt']),
                subtitle: Text('Ancho: ' + data[index]['width'].toString() + ', Alto: ' + data[index]['height'].toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
