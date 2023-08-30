import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class CepAPI {
  static Future<Map> getCep(String cep) async {
    String url = 'https://viacep.com.br/ws/$cep/json/';
    http.Response response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }
}
