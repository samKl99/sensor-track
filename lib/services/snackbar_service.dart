import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarService {
  static void showErrorSnackBar(final BuildContext context, final String message) {
    showTopSnackBar(
      context,
      CustomSnackBar.error(message: message),
    );
  }

  static void showSuccessSnackBar(final BuildContext context, final String message) {
    showTopSnackBar(
      context,
      CustomSnackBar.success(message: message),
    );
  }
}
