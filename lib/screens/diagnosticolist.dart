import 'package:appeventos/models/diagnostico.dart';

import 'package:appeventos/screens/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../models/api_response.dart';
import '../services/datos_service.dart';

class Clientelist extends StatelessWidget {
  Clientelist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClienteScreen(),
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Lista de Diagnosticos'),
        centerTitle: true,
      ),
    );
  }

  text(String s) {}
}

class ClienteScreen extends StatefulWidget {
  ClienteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _clienteScreen createState() => _clienteScreen();
}

class _clienteScreen extends State<ClienteScreen> {
  List<dynamic> _userList = [];

  bool _loading = true;

  // get all clientes
  Future<void> retrieveUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int userId = pref.getInt('userId') ?? 0;

    ApiResponse response = await getDiagnosticos(userId);
// obtiene a los clientes
    if (response.error == null) {
      setState(() {
        _userList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      /* logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });*/
      // ignore: use_build_context_synchronously
      context.push('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveUsers(); // obtiene a los usuarios
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrieveUsers();
            },
            child: ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (BuildContext context, int index) {
                Diagnostico diagnostico = _userList[index];
                return GestureDetector(
                  onTap: () {
                    if (diagnostico.medico != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Detalles del Médico"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nombre: ${diagnostico.medico!.name}"),
                                Text("Email: ${diagnostico.medico!.email}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cerrar"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID Diagnóstico: ${diagnostico.id}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Resultado IA: ${diagnostico.resultadoIa ?? 'No disponible'}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Resultado: ${diagnostico.resultado ?? 'No disponible'}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Estado: ${diagnostico.estado ?? 'No disponible'}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Confianza: ${diagnostico.confidence ?? 'No disponible'}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
