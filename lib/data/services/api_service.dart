import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';
import '../models/forecast_model.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        queryParameters: {
          'appid': ApiConstants.apiKey,
          'units': 'metric',
        },
      ),
    );
  }

  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        ApiConstants.currentWeather,
        queryParameters: {
          'lat': lat,
          'lon': lon,
        },
      );

      print('Weather API Response: ${response.data}');
      print('Temperature: ${response.data['main']['temp']}°C');
      print('Location: ${response.data['name']}');
      print('Condition: ${response.data['weather'][0]['main']}');

      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ForecastModel> getForecast(double lat, double lon) async {
    try {
      final response = await _dio.get(
        ApiConstants.forecast,
        queryParameters: {
          'lat': lat,
          'lon': lon,
        },
      );

      return ForecastModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<LocationModel>> searchLocation(String query) async {
    try {
      final response = await _dio.get(
        ApiConstants.geocoding,
        queryParameters: {
          'q': query,
          'limit': 5,
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => LocationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Invalid API key.';
        } else if (statusCode == 404) {
          return 'Location not found.';
        } else if (statusCode == 429) {
          return 'Too many requests. Please try again later.';
        }
        return 'Server error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
