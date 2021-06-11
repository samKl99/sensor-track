import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NotificationService {
  void showErrorSnackBar(final BuildContext context, final String message) {
    showTopSnackBar(
      context,
      CustomSnackBar.error(message: message),
    );
  }

  void showSuccessSnackBar(final BuildContext context, final String message) {
    showTopSnackBar(
      context,
      CustomSnackBar.success(message: message),
    );
  }

  void _presentDialog(final BuildContext context, final DialogType dialogType, final Widget? body, final VoidCallback? onOkPressed,
      final VoidCallback? onCancelPressed, final String? btnCancelText, final String? btnOkText) {
    AwesomeDialog(
        context: context,
        dialogType: dialogType,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogBackgroundColor: Theme.of(context).primaryColor,
        body: body,
        btnCancelText: btnCancelText,
        btnOkText: btnOkText,
        btnCancelOnPress: onCancelPressed,
        btnOkOnPress: onOkPressed)
      ..show();
  }

  void presentSuccessDialog(final BuildContext context, final Widget body, final VoidCallback? onOkPressed,
      final VoidCallback? onCancelPressed, final String? btnCancelText, final String? btnOkText) {
    _presentDialog(
      context,
      DialogType.SUCCES,
      body,
      onOkPressed,
      onCancelPressed,
      btnCancelText,
      btnOkText,
    );
  }

  void presentErrorDialog(final BuildContext context, final Widget body, final VoidCallback? onOkPressed,
      final VoidCallback? onCancelPressed, final String? btnCancelText, final String? btnOkText) {
    _presentDialog(
      context,
      DialogType.ERROR,
      body,
      onOkPressed,
      onCancelPressed,
      btnCancelText,
      btnOkText,
    );
  }

  void presentWarningDialog(final BuildContext context, final Widget body, final VoidCallback? onOkPressed,
      final VoidCallback? onCancelPressed, final String? btnCancelText, final String? btnOkText) {
    _presentDialog(
      context,
      DialogType.WARNING,
      body,
      onOkPressed,
      onCancelPressed,
      btnCancelText,
      btnOkText,
    );
  }

  void presentInfoDialog(final BuildContext context, final Widget body, final VoidCallback? onOkPressed,
      final VoidCallback? onCancelPressed, final String? btnCancelText, final String? btnOkText) {
    _presentDialog(
      context,
      DialogType.INFO,
      body,
      onOkPressed,
      onCancelPressed,
      btnCancelText,
      btnOkText,
    );
  }

  void presentQuestionDialog(final BuildContext context, final Widget body, final VoidCallback? onOkPressed,
      final VoidCallback? onCancelPressed, final String? btnCancelText, final String? btnOkText) {
    _presentDialog(
      context,
      DialogType.QUESTION,
      body,
      onOkPressed,
      onCancelPressed,
      btnCancelText,
      btnOkText,
    );
  }
}
