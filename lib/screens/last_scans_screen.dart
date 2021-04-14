import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/scan_card_item.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';
import 'package:sensor_track/services/scan_service.dart';

class LastScansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanService = Provider.of<ScanService>(context, listen: false)..getLastScans();
    return StreamBuilder<bool>(
      stream: scanService.scansLoading,
      builder: (context, loadingSnapshot) {
        return StreamBuilder<List<Scan>>(
          stream: scanService.scans,
          builder: (context, snapshot) {
            if (loadingSnapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.waiting ||
                loadingSnapshot.data != null && loadingSnapshot.data!) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  snapshot.data!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ScanCardItem(
                      scan: snapshot.data![index],
                      onTap: () async {
                        await _onDeleteScan(context, snapshot.data![index]);
                      },
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: const Text("Es ist ein Fehler aufgetreten"),
              );
            } else {
              return const Center(
                child: const Text(
                  "Keine letzten Scans verfügbar",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _onDeleteScan(final BuildContext context, final Scan scan) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogBackgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            "Scan löschen",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text("Möchtest du diesen Scan wirklich löschen?"),
          const SizedBox(
            height: 12.0,
          ),
        ],
      ),
      btnCancelText: "Abbrechen",
      btnOkText: "Löschen",
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        final scanService = Provider.of<ScanService>(context, listen: false);
        await scanService.deleteScan(scan);
        scanService.getLastScans();
      },
    )..show();
  }
}
