import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final Map<String, dynamic> team;
  final VoidCallback onJoinPressed;

  const TeamCard({
    required this.team,
    required this.onJoinPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                team['avatar'],
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Owner: ${team['owner']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text('${team['members']} members'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onJoinPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: team['joined'] ? Colors.green : Colors.blue,
              ),
              child: Text(team['joined'] ? 'Access' : 'Join'),
            ),
          ],
        ),
      ),
    );
  }
}