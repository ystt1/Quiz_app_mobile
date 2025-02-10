

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_cubit.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_state.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/presentation/team/pages/user_detail_modal.dart';

class ScanQrPage extends StatefulWidget {
  final Function(String code)? onSearch;
  const ScanQrPage({super.key, this.onSearch});

  @override
  _ScanQrPageState createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetUserDetailCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('Quét mã QR')),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 5,
                cutOutSize: 220,
              ),
            ),
            if (qrText.isNotEmpty)
              Positioned(
                bottom: 50,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),

                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && scanData.code!.isNotEmpty) {
        setState(() {
          qrText = scanData.code!;
        });
        if (mounted) {
          if(widget.onSearch!=null)
            {

              widget.onSearch!(scanData.code!);


              Navigator.of(context).pop();
              controller.pauseCamera();
              controller.dispose();
            }
          else {
            context.read<GetUserDetailCubit>().onGet(
              qrText,
            );
            context
                .read<GetUserDetailCubit>()
                .stream
                .listen((state) {
              if (state is GetUserDetailSuccess) {
                controller.pauseCamera();
                controller.dispose();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => UserModalPage(userId: qrText),
                  ),

                );
              }
            });
          }
        }
      }
    });
  }
}
