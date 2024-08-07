// https://api.unsplash.com/topics?client_id=78P8ZYw0MBWkDutrW9f3UKvtUlUY9xTTaYwYB0aWhJE
import 'dart:convert';

import 'package:http/http.dart' as http;

const unplashAPI = 'https://api.unsplash.com';

const clientId = '78P8ZYw0MBWkDutrW9f3UKvtUlUY9xTTaYwYB0aWhJE';

class ApiData {
  Future getData() async {
    String request =
        'https://api.unsplash.com/photos/random?client_id=78P8ZYw0MBWkDutrW9f3UKvtUlUY9xTTaYwYB0aWhJE';
    http.Response response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      // List<String> descriptions =

      String descriptions =
          decodedData['alt_description'] ?? 'No description available';
      // for (var topic in decodedData) {
      //   descriptions.add(topic['description'] ?? 'No description available');
      // }
      print(descriptions);
      return descriptions;
    } else {
      print(response.statusCode);
      throw 'Problem with get request';
    }
  }
}
