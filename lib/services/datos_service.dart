import 'package:appeventos/constant.dart';
import 'package:appeventos/models/api_response.dart';
import 'package:appeventos/models/recomendacion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/cita.dart';
import '../models/comunicados.dart';
import '../models/diagnostico.dart';

Future<ApiResponse> getBitacoras() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    //String token = await getToken();
    final response = await http.get(Uri.parse(ComunicadosURLOdoo), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      // 'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)
            .map((p) => Comunicados.fromJsonComunicados(p))
            .toList();

        print('Respuesta recibida: ${response.body}');
        // we get list of posts, so we need to map each item to post model
        apiResponse.data as List<dynamic>;

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getCitas(int? id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    //String token = await getToken();
    final response = await http.get(Uri.parse('$clienteidcitas/$id'), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      // 'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        print('Respuesta recibida: ${response.body}');
        apiResponse.data = jsonDecode(response.body)['citas']
            .map((p) => Cita.fromJsonCitas(p))
            .toList();

        // we get list of posts, so we need to map each item to post model
        apiResponse.data as List<dynamic>;

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getDiagnosticos(int? id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    //String token = await getToken();
    final response =
        await http.get(Uri.parse('$clienteiddiagnosticos/$id'), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      // 'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        print('Respuesta recibida: ${response.body}');
        apiResponse.data = jsonDecode(response.body)['diagnosticos']
            .map((p) => Diagnostico.fromJsonDiagnosticos(p))
            .toList();

        // we get list of posts, so we need to map each item to post model
        apiResponse.data as List<dynamic>;

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getRecomendacion(int? id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    //String token = await getToken();
    final response =
        await http.get(Uri.parse('$clienteidrecomendacion/$id'), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      // 'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        print('Respuesta recibida: ${response.body}');
        apiResponse.data = jsonDecode(response.body)['recomendaciones']
            .map((p) => Recomendacion.fromJsonRecomendaciones(p))
            .toList();

        // we get list of posts, so we need to map each item to post model
        apiResponse.data as List<dynamic>;

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getRecommendations(
    List<Map<String, dynamic>> studentData) async {
  ApiResponse apiResponse = ApiResponse();
  const apiKey = '';
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  String prompt = "Estos son los datos de el estudiante:\n";
  studentData.forEach((record) {
    prompt +=
        "Estudiante: ${record['student']}, Materia: ${record['materia']}, Nota: ${record['nota']}, Gestión: ${record['gestion']}\n";
  });
  prompt +=
      "Proporciona una descripción de todas las materias están mal solo nombrala , no describas la materia , solo nombre de la materia y la nota y luego cómo pueden mejorar.";

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {
          'role': 'system',
          'content':
              'Eres un asistente que ayuda a analizar el rendimiento de los estudiantes y al final da recomendaciones de libros que podria leer para cada materia y como padre como deberia apoyarlo.'
        },
        {
          'role': 'user',
          'content': prompt,
        }
      ],
      'max_tokens': 300,
    }),
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var choices = jsonResponse['choices'];
    if (choices != null && choices.isNotEmpty) {
      var message = choices[0]['message']['content'];
      print('Respuesta del modelo: $message');
      String respuestaEnUTF16 = utf8.decode(message.runes.toList());
      print('Respuesta del modelo respuestaEnUTF16: $respuestaEnUTF16');
      apiResponse.data = respuestaEnUTF16;
      // Aquí puedes manejar el mensaje según tus necesidades
    } else {
      print('No se encontraron respuestas en la respuesta de la API.');
    }
  } else {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
