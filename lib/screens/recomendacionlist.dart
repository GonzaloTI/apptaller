import 'package:appeventos/models/diagnostico.dart';
import 'package:appeventos/models/recomendacion.dart';

import 'package:appeventos/screens/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../models/api_response.dart';
import '../services/datos_service.dart';

class RecomendacionList extends StatelessWidget {
  RecomendacionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RecomendacionScreen(),
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Lista de Recomendaciones'),
        centerTitle: true,
      ),
    );
  }

  text(String s) {}
}

class RecomendacionScreen extends StatefulWidget {
  RecomendacionScreen({super.key});

  @override
  _RecomendacionScreenState createState() => _RecomendacionScreenState();
}

class _RecomendacionScreenState extends State<RecomendacionScreen> {
  List<dynamic> _userList = [];

  bool _loading = true;

  // Obtiene todas las recomendaciones
  Future<void> retrieveUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int userId = pref.getInt('userId') ?? 0;

    ApiResponse response = await getRecomendacion(userId);
    if (response.error == null) {
      setState(() {
        _userList = response.data as List<dynamic>;
        _loading = false;
      });
    } else if (response.error == unauthorized) {
      context.push('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: retrieveUsers,
            child: ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (BuildContext context, int index) {
                Recomendacion recomendacion = _userList[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Detalles del Médico"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Nombre Médico: ${recomendacion.nombreMedico}"),
                              Text(
                                  "Recomendación: ${recomendacion.recomendacion}"),
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
                            "ID Recomendación: ${recomendacion.id}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Diagnóstico ID: ${recomendacion.diagnosticoId}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Recomendación: ${recomendacion.recomendacion}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Nombre Médico: ${recomendacion.nombreMedico}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Fecha de Creación: ${recomendacion.createdAt}",
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
