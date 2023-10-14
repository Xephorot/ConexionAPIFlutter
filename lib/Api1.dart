// Contenido del archivo Api1.dart
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Images.dart';
import 'package:flutter_tutorial/Info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SimpleAPI extends StatefulWidget {
  const SimpleAPI({super.key});
  @override
  State<SimpleAPI> createState() => _SimpleAPIPageState();
}

class _SimpleAPIPageState extends State<SimpleAPI> {
  List<dynamic> data = [];
  final TextEditingController searchController = TextEditingController();

  Future<void> fetchData([String query = 'apples']) async {
    final response = await http.get(Uri.parse('https://lexica.art/api/v1/search?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        data = convert.jsonDecode(response.body)['images'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Buscar',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        fetchData(searchController.text.isEmpty ? 'apples' : searchController.text);
                      },
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageScreen(data: data)),
                );
              },
              child: const Text('Ver solo imágenes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoScreen(data: data)),
                );
              },
              child: const Text('Ver información completa'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return getItem(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget getItem (int index){
    return Container(
      width: 300,
      child: SizedBox(
        height: 400, // Ajusta este valor según tus necesidades
        child: Card(
          color: Colors.transparent, // Hacer el color de la tarjeta transparente
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow, Colors.orange], // Degradado de amarillo a anaranjado
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Image.network(data[index]['src']),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity, // Hacer que la imagen ocupe todo el ancho disponible
                      child: AspectRatio(
                        aspectRatio: 16 / 9, // Ajusta este valor según tus necesidades
                        child: Image.network(data[index]['src'], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Prompt: ' + (data[index]['prompt'].length > 20 ? data[index]['prompt'].substring(0, 20) + '...' : data[index]['prompt']),
                            style: TextStyle(color: Colors.white)
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Ancho: ' + data[index]['width'].toString(), style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(width: 100), // Reducir el espacio entre los textos de ancho y alto
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Alto: ' + data[index]['height'].toString(), style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Modelo: ' + data[index]['model'], style: TextStyle(color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Escala de orientación: ' + data[index]['guidance'].toString(), style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
