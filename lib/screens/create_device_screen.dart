import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_track_app_bar.dart';
import 'package:sensor_track/components/sensor_track_button.dart';
import 'package:sensor_track/components/sensor_track_text_field.dart';
import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/services/authentication_service.dart';
import 'package:sensor_track/services/iota_service.dart';
import 'package:sensor_track/services/notification_service.dart';
import 'package:sensor_track/services/sensor_service.dart';

class SensorTrackCreateDeviceScreen extends StatefulWidget {
  final Sensor sensor;

  const SensorTrackCreateDeviceScreen({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  @override
  _SensorTrackCreateDeviceScreenState createState() => _SensorTrackCreateDeviceScreenState();
}

class _SensorTrackCreateDeviceScreenState extends State<SensorTrackCreateDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _sensorIdController = TextEditingController();
  final TextEditingController _sensorTypeController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  final TextEditingController _priceOfDataStreamController = TextEditingController();

  late List<IotaDataType> _dataFields;

  IotaService get _iotaService => Provider.of<IotaService>(context, listen: false);

  NotificationService get _notificationService => Provider.of<NotificationService>(context, listen: false);

  AuthenticationService get _authenticationService => Provider.of<AuthenticationService>(context, listen: false);

  SensorService get _sensorService => Provider.of<SensorService>(context, listen: false);

  late bool _isSavingSensor;

  @override
  void initState() {
    _isSavingSensor = false;

    _dataFields = _iotaService.allowedDataTypes.values.toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SensorTrackAppBar(
        title: Text("Sensor registrieren"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 24.0,
              ),
              const SizedBox(
                height: 24.0,
              ),
              _sensorIdTextField,
              const SizedBox(
                height: 8.0,
              ),
              _sensorTypeTextField,
              const SizedBox(
                height: 8.0,
              ),
              _companyTextField,
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: _cityTextField,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: _countryTextField,
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: _latTextField,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: _lonTextField,
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              _priceOfDataStreamTextField,
              const SizedBox(
                height: 20.0,
              ),
              // data fields
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Datenfelder:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              ..._allowedDataFieldItems,
              const SizedBox(
                height: 24.0,
              ),
              _registerSensorButton,
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _sensorIdTextField => SensorTrackTextField(
        controller: _sensorIdController,
        hint: "Sensor Id (z.B. Ruuvi B431)",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Id benötigt";
          }
          return null;
        },
      );

  Widget get _sensorTypeTextField => SensorTrackTextField(
        controller: _sensorTypeController,
        hint: "Sensor Typ (z.B. Umweltsensor)",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Typ benötigt";
          }
          return null;
        },
      );

  Widget get _companyTextField => SensorTrackTextField(
        controller: _companyController,
        hint: "Unternehmen (z.B. Breezometer oder Privat)",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Unternehmen benötigt";
          }
          return null;
        },
      );

  Widget get _cityTextField => SensorTrackTextField(
        controller: _cityController,
        hint: "Stadt",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Stadt benötigt";
          }
          return null;
        },
      );

  Widget get _countryTextField => SensorTrackTextField(
        controller: _countryController,
        hint: "Land",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Land benötigt";
          }
          return null;
        },
      );

  Widget get _latTextField => SensorTrackTextField(
        controller: _latController,
        hint: "Latitude",
        keyBoardType: TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Latitude benötigt";
          }
          return null;
        },
      );

  Widget get _lonTextField => SensorTrackTextField(
        controller: _lonController,
        hint: "Longitude",
        keyBoardType: TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Longitude benötigt";
          }
          return null;
        },
      );

  Widget get _priceOfDataStreamTextField => SensorTrackTextField(
        controller: _priceOfDataStreamController,
        hint: "Preis des Datenstreams (z.B. 5000)",
        keyBoardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Preis benötigt";
          }
          return null;
        },
      );

  List<Widget> get _allowedDataFieldItems {
    return _dataFields
        .map((e) => CheckboxListTile(
            title: Text(
              "${e.name} in ${e.unit}",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            value: e.active,
            onChanged: (value) {
              setState(() {
                e.active = !e.active;
              });
            }))
        .toList();
  }

  Widget get _registerSensorButton => SensorTrackButton(
        text: "Sensor registrieren",
        textStyle: const TextStyle(fontSize: 18.0),
        color: Theme.of(context).accentColor,
        loading: _isSavingSensor,
        onPressed: _registerSensor,
      );

  _registerSensor() async {
    if (_formKey.currentState!.validate()) {
      final IotaNewDeviceForm iotaNewDeviceForm = IotaNewDeviceForm(
        company: _companyController.text.trim(),
        type: _sensorTypeController.text.trim(),
        date: DateTime.now(),
        price: int.parse(_priceOfDataStreamController.text.trim()),
        lat: NumberFormat().parse(_latController.text.trim()).toDouble(),
        lon: NumberFormat().parse(_lonController.text.trim()).toDouble(),
        sensorId: _sensorIdController.text.trim(),
        inactive: true,
        owner: _authenticationService.currentUser!.id,
        location: IotaLocation(
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
        ),
        dataTypes: _dataFields.where((element) => element.active).toList(),
      );
      try {
        setState(() {
          _isSavingSensor = true;
        });

        final response = await _iotaService.registerNewDevice(iotaNewDeviceForm);
        final sensor = widget.sensor;

        // save unique secret from iota
        sensor.iotaSk = response.data["sk"];
        sensor.iotaDeviceId = iotaNewDeviceForm.sensorId;

        await _sensorService.addSensor(sensor);
        _sensorService.getRegisteredSensors();

        _moveToSensorScreen();
      } catch (e) {
        print(e);
        _notificationService.showErrorSnackBar(context, "Fehler beim Registrieren");
      } finally {
        setState(() {
          _isSavingSensor = false;
        });
      }
    }
  }

  _moveToSensorScreen() {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
  }
}
