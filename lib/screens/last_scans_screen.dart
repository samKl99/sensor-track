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
                loadingSnapshot.data) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
              return GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  snapshot.data.length,
                  (index) => ScanCardItem(snapshot.data[index]),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else {
              return Center(
                child: Text(
                  "Keine letzten Scans verfügbar",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        );
      },
    );
  }
}
