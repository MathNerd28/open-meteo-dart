import '../api.dart';
import '../enums/climate.dart';
import '../options.dart';
import '../response.dart';

/// Explore Climate Change on a Local Level with High-Resolution Climate Data
///
/// https://open-meteo.com/en/docs/climate-api/
class ClimateApi extends BaseApi {
  final Set<ClimateModel> models;
  final TemperatureUnit temperatureUnit;
  final WindspeedUnit windspeedUnit;
  final PrecipitationUnit precipitationUnit;
  final CellSelection cellSelection;
  final bool disableBiasCorrection;

  ClimateApi({
    super.apiUrl = 'https://climate-api.open-meteo.com/v1/climate',
    super.apiKey,
    required this.models,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windspeedUnit = WindspeedUnit.kmh,
    this.precipitationUnit = PrecipitationUnit.mm,
    this.cellSelection = CellSelection.land,
    this.disableBiasCorrection = false,
  });

  ClimateApi copyWith({
    String? apiUrl,
    String? apiKey,
    Set<ClimateModel>? models,
    TemperatureUnit? temperatureUnit,
    WindspeedUnit? windspeedUnit,
    PrecipitationUnit? precipitationUnit,
    CellSelection? cellSelection,
    bool? disableBiasCorrection,
  }) =>
      ClimateApi(
        apiUrl: apiUrl ?? this.apiUrl,
        apiKey: apiKey ?? this.apiKey,
        models: models ?? this.models,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
        windspeedUnit: windspeedUnit ?? this.windspeedUnit,
        precipitationUnit: precipitationUnit ?? this.precipitationUnit,
        cellSelection: cellSelection ?? this.cellSelection,
        disableBiasCorrection:
            disableBiasCorrection ?? this.disableBiasCorrection,
      );

  Future<Map<String, dynamic>> requestJson({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required Set<ClimateDaily> daily,
  }) =>
      apiRequestJson(
        this,
        _queryParamMap(
          latitude: latitude,
          longitude: longitude,
          startDate: startDate,
          endDate: endDate,
          daily: daily,
        ),
      );

  Future<ApiResponse<ClimateApi>> request({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required Set<ClimateDaily> daily,
  }) =>
      apiRequestFlatBuffer(
        this,
        _queryParamMap(
          latitude: latitude,
          longitude: longitude,
          startDate: startDate,
          endDate: endDate,
          daily: daily,
        ),
      ).then(
        (data) => ApiResponse.fromFlatBuffer(
          data,
          dailyHashes: ClimateDaily.hashes,
        ),
      );

  Map<String, dynamic> _queryParamMap({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required Set<ClimateDaily> daily,
  }) =>
      {
        'models': models,
        'latitude': latitude,
        'longitude': longitude,
        'daily': daily,
        'temperature_unit':
            nullIfEqual(temperatureUnit, TemperatureUnit.celsius),
        'windspeed_unit': nullIfEqual(windspeedUnit, WindspeedUnit.kmh),
        'precipitation_unit':
            nullIfEqual(precipitationUnit, PrecipitationUnit.mm),
        'cell_selection': nullIfEqual(cellSelection, CellSelection.land),
        'disable_bias_correction': nullIfEqual(disableBiasCorrection, false),
        'start_date': formatDate(startDate),
        'end_date': formatDate(endDate),
        'timeformat': 'unixtime',
        'timezone': 'auto',
      };
}
