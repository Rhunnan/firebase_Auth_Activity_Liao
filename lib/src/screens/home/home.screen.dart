import 'package:flutter/material.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';
  static const String path = "/home";
  static const String name = "Home Screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Center(child: Text("Home")),
        TextButton(
            onPressed: () {
              AuthController.I.logout();
            },
            child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                    child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))))
      ],
    );
  }
}
