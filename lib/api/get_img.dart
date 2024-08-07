import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const getImage = 'https://api.getimg.ai/v1/stable-diffusion-xl/image-to-image';
const token =
    'key-44nA4zl8R3VYgQ1ZAtrD5Nh6SMz2sB57PY8F2z7a8GPiF7QNO9fi4y9TMJ2anrS6cjadbcgvT7Exek1AKLLAdzp6V8usiEAC';

class ApiImageData {
  Future<void> postImgData(File? imageFile, String prompt) async {
    if (imageFile == null) return;
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    print("base64Image $base64Image");
    final response = await http.post(Uri.parse(getImage),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': prompt,
          'image': base64Image,
          'num_images': 1,
          'steps': 50,
          'guidance_scale': 7,
          "response_format": "url"
        }));
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      print(response.body);
    } else {
      print('Failed to upload image: ${response.body}');
    }
  }
}
