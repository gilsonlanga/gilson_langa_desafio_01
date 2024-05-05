import 'package:flutter/material.dart';

class SearchHistoryPage extends StatelessWidget {
  // Lista de histórico de buscas (apenas um exemplo, substitua com seus próprios dados)
  final List<Map<String, dynamic>> searchHistory = [
    {'cep': '12345-678', 'details': 'Detalhes da busca 1'},
    {'cep': '54321-098', 'details': 'Detalhes da busca 2'},
    {'cep': '98765-432', 'details': 'Detalhes da busca 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search History'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 203, 240, 207),
        ),
        child: ListView.builder(
          itemCount: searchHistory.length,
          itemBuilder: (context, index) {
            final search = searchHistory[index];
            return ListTile(
              title: Text(search['cep']),
              subtitle: Text(search['details']),
              onTap: () {
                // Ação ao clicar em um item do histórico (opcional)
              },
            );
          },
        ),
      ),
    );
  }
}