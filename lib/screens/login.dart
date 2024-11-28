import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'package:appeventos/provider/album_provider.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _loginUser() async {
    String? token = await _firebaseMessaging.getToken();
    ref.read(albumRepositoryProvider).tokenNotificacion = token;

    ApiResponse response = await login(
      txtEmail.text,
      txtPassword.text,
      ref.read(albumRepositoryProvider).tokenNotificacion!,
    );

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setString('name', user.name ?? '');
    await pref.setString('email', user.email ?? '');
    await pref.setString('role', user.role ?? '');
    ref.read(albumRepositoryProvider).userCurrent = user;

    context.push('/homebar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: formkey,
            child: ListView(
              shrinkWrap: true,
              children: [
                // Logo con bordes redondeados
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        'https://clinicadetextos.com/wp-content/uploads/2016/09/clinica-de-textos.jpg',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenido a Clínica del Higado',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                // Campo de Email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: txtEmail,
                  validator: (val) =>
                      val!.isEmpty ? 'Dirección de correo inválida' : null,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de Contraseña
                TextFormField(
                  controller: txtPassword,
                  obscureText: true,
                  validator: (val) => val!.length < 3
                      ? 'Debe tener al menos 6 caracteres'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                ),
                const SizedBox(height: 30),
                // Botón de Login
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                              _loginUser();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                const SizedBox(height: 20),
                // Enlace de Registro
                TextButton(
                  onPressed: () async {
                    const url = 'http://54.144.9.226/register';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'No se pudo abrir el enlace: $url';
                    }
                  },
                  child: Text(
                    '¿No tienes una cuenta? Regístrate',
                    style: TextStyle(color: Colors.blueAccent),
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
