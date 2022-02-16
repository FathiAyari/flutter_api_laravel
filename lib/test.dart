import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;

class Api extends StatefulWidget {
  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  String lastname = "";
  TextEditingController nameController = TextEditingController();
  callApi() async {
    var url = Uri.parse("http://10.0.2.2:8000/api/test");
    Map body = {"name": nameController.text};
    var response = await http.post(url, body: body);
    var result = jsonDecode(response.body);

    if (result.length == 0) {
      Get.snackbar(
        "Desolé",
        "Nom introuvable ",
        icon: Icon(Icons.person, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Bienvenue",
        "Le prénom de ${nameController.text} est ${result[0]['lastname']}",
        icon: Icon(Icons.person, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      label: const Text(
                        "entrer le nom",
                        style:
                            TextStyle(fontSize: 20, color: Colors.blueAccent),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " champ obligatoire";
                    } else
                      return null;
                  },
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    callApi();
                  }
                },
                child: Text("Chercher ")),
          ],
        ),
      ),
    );
  }
}
