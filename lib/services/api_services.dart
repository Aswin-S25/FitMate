import 'dart:convert';
import 'dart:developer';
import 'package:fitmate/Models/calories_response.dart';
import 'package:fitmate/Models/food_request.dart';
import 'package:fitmate/Models/food_response.dart';
import 'package:fitmate/Models/user_response.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIServices {
  static var client = http.Client();
  static var url = Uri.parse('https://fitmate-api-r2ic.onrender.com/');

  //Fetch food calories API REQUEST
  Future<List<CaloriesResponseModel>> fetchNutritionData(String query) async {
    const apiKey = 'cyJ73QlfbP2hSsENjQcShw==K3HhFEpOYhC2h7WX';
    final url = 'https://api.api-ninjas.com/v1/nutrition?query=$query';

    final response =
        await http.get(Uri.parse(url), headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        return jsonResponse
            .map((json) => CaloriesResponseModel.fromJson(json))
            .toList();
      } else if (jsonResponse is Map<String, dynamic>) {
        if (jsonResponse.containsKey('items')) {
          final items = jsonResponse['items'];
          if (items is List) {
            return items
                .map((json) => CaloriesResponseModel.fromJson(json))
                .toList();
          }
        }
      }
      throw Exception('Unexpected response format');
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load data!');
    }
  }

  //Food ADDING API REQUEST
  Future<bool> addFood(FoodCaloriesRequestModel model, int? userId) async {
    log(model.toJson().toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  
    final url = Uri.parse(
        "https://fitmate-api-r2ic.onrender.com/user/data/food/details/add/$userId");
    final body = jsonEncode(model.toJson());
    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 307) {
      var redirectUrl = response.headers['location'];
      response = await client.post(Uri.parse(redirectUrl!),
          headers: headers, body: body);
    }

    if (response.statusCode == 200) {
      log(response.body);
      return true;
    } else {
      throw Exception(
          'Failed to add product: ${response.body}+ ${response.statusCode}');
      // return false;
    }
  }

  //get added food from user

  Future<FoodResponseModel> fetchFoodData(int? id) async {
    final url = Uri.parse(
        'https://fitmate-api-r2ic.onrender.com/user/data/food/details/read/$id');

    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      // Parse the JSON response into FoodResponseModel
      final foodResponse = FoodResponseModel.fromJson(jsonBody);
      return foodResponse;
    } else {
      throw Exception('Failed to fetch food data');
    }
  }

  Future<bool> RegisterUser(String name, String email, String password) async {
    log(url.toString() + 'user/auth/signup');

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    });
    log(body.toString());
    final response = await http.post(
        Uri.parse('https://fitmate-api-r2ic.onrender.com/user/auth/signup'),
        body: body,
        headers: header);

    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log(response.body);
      return true;
    } else {
      return false;
    }
  }

  //add personal data
  Future<bool> AddPersonalData(String age, String height, String weight, int? id) async {
    log('${url}user/auth/signup');

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      "age": age,
      "height": height,
      "weight": weight,
    });
    log(body.toString());
    final response = await http.post(
        Uri.parse(
            'https://fitmate-api-r2ic.onrender.com/user/data/biometrix/add/${id}'),
        body: body,
        headers: header);

    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<LoginResponse?> login(String email, String password) async {
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      "email": email,
      "password": password,
    });
    log(body.toString());
    final response = await http.post(
        Uri.parse('https://fitmate-api-r2ic.onrender.com/user/auth/signin'),
        body: body,
        headers: header);

    log(response.body);
    log(response.statusCode.toString());

    final jsonResponse = jsonDecode(response.body);
    final jwtToken = jsonResponse['token'] as String;

    final decodedToken = JwtDecoder.decode(jwtToken);
    LoginResponse loginResponse = LoginResponse.fromJson(decodedToken);

    if (response.statusCode == 200) {
      log(response.body);
      return loginResponse;
    } else {
      return null;
    }
  }
}

Future<int> fetch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = int.parse(prefs.getString('id')!);
  return id;
}
