import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/common/widgets/search_sort.dart';
import 'package:quiz_app/common/widgets/team_card.dart';
import 'package:quiz_app/presentation/team/pages/team_detail_page.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? qrCodeResult;

  List<Map<String, dynamic>> teams = [
    {
      'name': 'Flutter Devs',
      'owner': 'John Doe',
      'members': 120,
      'avatar': 'https://via.placeholder.com/150',
      'joined': true,
    },
    {
      'name': 'React Native Team',
      'owner': 'Jane Smith',
      'members': 95,
      'avatar': 'https://via.placeholder.com/150',
      'joined': false,
    },
    {
      'name': 'Backend Gurus',
      'owner': 'Alice Johnson',
      'members': 80,
      'avatar': 'https://via.placeholder.com/150',
      'joined': false,
    },
  ];

  String searchQuery = '';

  void _addNewTeam() {
    setState(() {
      teams.add({
        'name': 'New Team',
        'owner': 'New Owner',
        'members': 0,
        'avatar': 'https://via.placeholder.com/150',
        'joined': false,
      });
    });
  }

  // Hàm quét QR code trực tiếp bằng camera
  void _scanQRCode() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scan QR Code'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    qrCodeResult = scanData.code;
                  });
                  controller.dispose(); // Dừng quét sau khi nhận được kết quả
                  Navigator.pop(context); // Đóng dialog
                });
              },
            ),
          ),
        );
      },
    ).then((_) {
      if (qrCodeResult != null) {
        print('QR Code Result: $qrCodeResult');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code: $qrCodeResult')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTeams = teams
        .where((team) =>
        team['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: _scanQRCode,
            tooltip: 'Scan QR Code',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchSort(
              onSearch: (state) {
                print('Search and Sort State: ${state.name}, ${state.sortField}, ${state.direction}');
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredTeams.length,
              separatorBuilder: (context, index) =>
              const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDetailPage(),
                      ),
                    );
                  },
                  child: TeamCard(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTeam,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        tooltip: 'Add New Team',
      ),
    );
  }
}
