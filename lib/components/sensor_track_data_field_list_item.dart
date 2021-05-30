import 'package:flutter/material.dart';
import 'package:sensor_track/components/sensor_track_text_field.dart';
import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';

class SensorTrackDataFieldListItem extends StatefulWidget {
  final IotaDataType dataType;
  final VoidCallback? onRemoveTap;
  final ValueChanged<String>? onFieldIdChanged;
  final ValueChanged<String>? onFieldNameChanged;
  final ValueChanged<String>? onFieldUnitChanged;
  final bool showRemoveButton;

  SensorTrackDataFieldListItem({
    Key? key,
    required this.dataType,
    required this.onRemoveTap,
    this.showRemoveButton = true,
    this.onFieldIdChanged,
    this.onFieldNameChanged,
    this.onFieldUnitChanged,
  }) : super(key: key);

  @override
  _SensorTrackDataFieldListItemState createState() => _SensorTrackDataFieldListItemState();
}

class _SensorTrackDataFieldListItemState extends State<SensorTrackDataFieldListItem> {
  final TextEditingController _fieldIdController = TextEditingController();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _fieldUnitController = TextEditingController();

  @override
  void initState() {
    if (widget.onFieldIdChanged != null) {
      _fieldIdController.addListener(() {
        widget.onFieldIdChanged!(_fieldIdController.text);
      });
    }

    if (widget.onFieldNameChanged != null) {
      _fieldNameController.addListener(() {
        widget.onFieldNameChanged!(_fieldNameController.text);
      });
    }
    if (widget.onFieldUnitChanged != null) {
      _fieldUnitController.addListener(() {
        widget.onFieldUnitChanged!(_fieldUnitController.text);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _fieldIdTextField,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: _fieldNameTextField,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: _fieldUnitTextField,
        ),
        const SizedBox(
          width: 8.0,
        ),
        widget.showRemoveButton
            ? CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: IconButton(
                  onPressed: widget.onRemoveTap,
                  color: Colors.white,
                  icon: Icon(
                    Icons.remove,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget get _fieldIdTextField => SensorTrackTextField(
        controller: _fieldIdController,
        hint: "Id",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Id benötigt";
          }
          return null;
        },
      );

  Widget get _fieldNameTextField => SensorTrackTextField(
        controller: _fieldNameController,
        hint: "Name",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name benötigt";
          }
          return null;
        },
      );

  Widget get _fieldUnitTextField => SensorTrackTextField(
        controller: _fieldUnitController,
        hint: "Einheit",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Einheit benötigt";
          }
          return null;
        },
      );
}
