

import 'dart:developer';

import 'package:flutter_application_1/Models/Home_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController {
  Future<String?> getUserAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userAccountID');
  }

  Future<User?> fetchUserByAccountId(String userAccountID) async {
    final response = await http.get(Uri.parse('https://ptechapp-5ab6d15ba23c.herokuapp.com/users'));

    if (response.statusCode == 200) {
      try {
        // Decode the list of users
        List<dynamic> users = json.decode(response.body);

        // Iterate through the list and find the matching userAccountID
        for (var user in users) {
          if (user['userAccountID'] == userAccountID) {
            return User.fromJson(user);
          }
        }

        // If no matching user is found
        log('No user found with the specified account ID.');
        return null;
      } catch (e) {
        throw Exception('Failed to parse user data: $e');
      }
    } else {
      throw Exception('Failed to load user list');
    }
  }
}
