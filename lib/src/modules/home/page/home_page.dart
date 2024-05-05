import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart'; // Importe esta linha
import 'dart:io' show Platform;

class SearchHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> searchHistory;

  SearchHistoryPage({Key? key, required this.searchHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Buscas'),
      ),
      body: ListView.builder(
        itemCount: searchHistory.length,
        itemBuilder: (context, index) {
          final search = searchHistory[index];
          return ListTile(
            title: Text('CEP: ${search['cep']}'),
            subtitle: Text('Detalhes: ${search['details']}'),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cep = '';
  String _searchResult = ''; // Variável para armazenar o resultado da busca do CEP
  List<Map<String, dynamic>> searchHistory = [];

  Future<void> _openSearchDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar Endereço'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Digite o CEP',
                ),
                onChanged: (value) {
                  setState(() {
                    _cep = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _searchAddress(_cep); 
                  Navigator.of(context).pop();
                },
                child: Text('Buscar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _searchAddress(String cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _searchResult = 'CEP Encontrado: $cep\n'
                        'Logradouro: ${data['logradouro']}\n'
                        'Bairro: ${data['bairro']}\n'
                        'Localidade: ${data['localidade']}\n'
                        'UF: ${data['uf']}';
      });
      _addToSearchHistory(cep, data);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Falha ao buscar o endereço. Verifique o CEP e tente novamente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _addToSearchHistory(String cep, Map<String, dynamic> data) {
    setState(() {
      searchHistory.add({'cep': cep, 'details': '${data['logradouro']}, ${data['bairro']}, ${data['localidade']}, ${data['uf']}'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Fast Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _openSearchDialog(context); 
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 203, 240, 207),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Exibe o resultado da busca do CEP acima do botão "Localizar Endereço"
          if (_searchResult.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _searchResult,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _openSearchDialog(context); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: Text(
                'Localizar Endereço',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchHistoryPage(searchHistory: searchHistory)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: Text(
                'Histórico de Endereços',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (searchHistory.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Último Endereço: ${searchHistory.last['cep']} - ${searchHistory.last['details']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton(
            onPressed: () async {
              if (searchHistory.isNotEmpty) {
                final coordinates = await getCoordinates(searchHistory.last['cep']);
                if (coordinates != null) {
                  final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}';
                  if (Platform.isIOS) {
                    // Para iOS, abre o Apple Maps
                    await launch('maps://?q=${coordinates.latitude},${coordinates.longitude}');
                  } else {
                    // Para Android, abre o Google Maps
                    await launch(googleMapsUrl);
                  }
                }
              }
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.public),
          ),
        ),
      ),
    );
  }

  Future<Location?> getCoordinates(String cep) async {
    try {
      final location = await locationFromAddress(cep);
      return location.isNotEmpty ? location.first : null;
    } catch (e) {
      print('Erro ao obter coordenadas: $e');
      return null;
    }
  }
}
