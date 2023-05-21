import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:client/constants/constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:client/home.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage();

  Future login({
    required String? email,
    required String? password,
  }) async {
    try {
      isLoading(true);
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
      };
      var response = await http.post(
        Uri.parse(baseURL + '/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      if (response.statusCode == 201) {
        isLoading.value = false;
        token.value = json.decode(response.body)['data']['userToken'];
        box.write('userToken', token.value);
        Get.offAll(() => const MyHomePage(
              title: 'Home Page',
            ));
        Get.snackbar(
          'Success!',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      } else if (response.statusCode == 401) {
        isLoading.value = false;
        Get.snackbar(
          'Error!',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['errors'].toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (err) {
      isLoading.value = false;
      print(err.toString());
    }
  }
}
