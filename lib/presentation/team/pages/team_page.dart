import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/common/widgets/add_team_modal.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/search_sort.dart';
import 'package:quiz_app/common/widgets/team_card.dart';
import 'package:quiz_app/domain/team/usecase/get_list_team_usecase.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_cubit.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_state.dart';
import 'package:quiz_app/presentation/team/pages/team_detail_page.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? qrCodeResult;

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
                  controller.dispose();
                  Navigator.pop(context);
                });
              },
            ),
          ),
        );
      },
    ).then((_) {
      if (qrCodeResult != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code: $qrCodeResult')),
        );
      }
    });
  }

  void onRefresh(BuildContext context) {
    context.read<GetTeamCubit>().onGet(usecase: GetListTeamUseCase());
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocProvider(
        create: (BuildContext context) =>
            GetTeamCubit()..onGet(usecase: GetListTeamUseCase()),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SearchSort(
                onSearch: (state) {
                  print(
                      'Search and Sort State: ${state.name}, ${state.sortField}, ${state.direction}');
                },
              ),
            ),
            BlocBuilder<GetTeamCubit, GetTeamState>(
                builder: (BuildContext context, GetTeamState teams) {
              if (teams is GetTeamLoading) {
                return GetLoading();
              }
              if (teams is GetTeamFailure) {
                return GetFailure(name: teams.error);
              }
              if (teams is GetTeamSuccess) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: teams.teams.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return TeamCard(
                        team: teams.teams[index],
                        onRefresh: () {
                          onRefresh(context);
                        },
                      );
                    },
                  ),
                );
              }
              ;
              return GetSomethingWrong();
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              builder: (innerContext) {
                return AddTeamModal();
              });
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        tooltip: 'Add New Team',
      ),
    );
  }
}
