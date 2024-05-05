import 'package:flutter/material.dart';

class AddressDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const AddressDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Endereço'),
      ),
      body: Container( // Container para definir o fundo verde claro
        color: Color.fromARGB(255, 203, 240, 207), // Defina a cor de fundo como verde claro
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CEP: ${data['cep']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Logradouro: ${data['logradouro']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Complemento: ${data['complemento']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Bairro: ${data['bairro']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Localidade: ${data['localidade']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('UF: ${data['uf']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('IBGE: ${data['ibge']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('GIA: ${data['gia']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('DDD: ${data['ddd']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('SIAFI: ${data['siafi']}', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
