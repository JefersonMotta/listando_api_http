import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:listando_api_http/usuario.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Usuario>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = pegarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuário'),
      ),
      body: Center(
        child: FutureBuilder<List<Usuario>>(
          future: usuarios,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, int index) {
                  Usuario usuario = snapshot.data![index];
                  return ListTile(
                    title: Text(usuario.name!),
                    subtitle: Text(usuario.phone!),
                    onLongPress: () {},
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List<Usuario>> pegarUsuario() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var reponse = await http.get(url);
    if (reponse.statusCode == 200) {
      List listaUsuario = json.decode(reponse.body);
      await Future.delayed(const Duration(seconds: 2));
      return listaUsuario.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Não foi possivel carregar os usuarios');
    }
  }
}
