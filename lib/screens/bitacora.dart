import 'package:appeventos/models/cita.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/comunicados.dart';
import '../services/datos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navbar.dart';

class bitacoralist extends StatelessWidget {
  bitacoralist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BitacoraScreen(),
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('LISTA DE CITAS PROGRAMADAS '),
        centerTitle: true,
      ),
    );
  }

  text(String s) {}
}

class BitacoraScreen extends StatefulWidget {
  BitacoraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _bitacoraScreen createState() => _bitacoraScreen();
}

class _bitacoraScreen extends State<BitacoraScreen> {
  List<dynamic> _userList = [];
  SharedPreferences? usershared;
  bool _loading = true;

  // get all Users
  Future<void> obtenerSharedPreferences() async {
    usershared = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<void> retrieveBitacora() async {
    //  ApiResponse response = await getBitacoras();
    usershared = await SharedPreferences.getInstance();
    ApiResponse response = await getCitas(usershared?.getInt('userId'));
// obtiene a los usuarios
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
    obtenerSharedPreferences();
    retrieveBitacora(); // obtiene las bitacoras
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrieveBitacora();
            },
            child: ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (BuildContext context, int index) {
                Cita cita = _userList[index];
                return Card(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ID: ${cita.id ?? 'N/A'}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              cita.estado ?? 'Estado no disponible',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: cita.estado == "confirmado"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Fecha: ${cita.fecha ?? 'No disponible'}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Hora: ${cita.hora ?? 'No disponible'}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Detalles: ${cita.detalles ?? 'Detalles no disponibles'}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(color: Colors.black26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Cliente ID: ${cita.userIdCliente ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "Disponibilidad ID: ${cita.disponibilidadId ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Creado: ${cita.createdAt ?? 'No disponible'}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Actualizado: ${cita.updatedAt ?? 'No disponible'}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
