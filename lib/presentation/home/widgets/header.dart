import 'package:flutter/material.dart';
import 'package:quiz_app/presentation/search/pages/search_page.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Good Morning, Tuấn',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/img/user-avatar.png'),
              radius: 20,
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
