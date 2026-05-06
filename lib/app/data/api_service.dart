import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nura_app/app/data/api_constants.dart';
import 'package:nura_app/app/data/api_response.dart';
import 'package:nura_app/app/data/model/message_model.dart';

class ApiService {
  static HealthCheck healthCheck = HealthCheck();
  static GetMessage getMessage = GetMessage();
  static ResetMessage resetMessage = ResetMessage();
}

class HealthCheck {
  Future<ApiResponse<Object>> call() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.healthCheckUrl}'),
      headers: {'Authorization': 'Bearer ${ApiConstants.token}'},
    );

    if (response.statusCode == 200) {
      return ApiResponse(
        success: true,
        message: "Health check passed",
        data: json.encode(response.body),
      );
    } else {
      return ApiResponse(
        success: false,
        message:
            "Error: Api call failed with status code ${response.statusCode}",
        data: null,
      );
    }
  }
}

class GetMessage {
  Future<ApiResponse<MessageModel>> call() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getMessageUrl}'),
      headers: {'Authorization': 'Bearer ${ApiConstants.token}'},
    );

    if (response.statusCode == 200) {
      return ApiResponse(
        success: true,
        message: "Received Message",
        data: messageModelFromJson(response.body),
      );
    } else {
      return ApiResponse(
        success: false,
        message:
            "Error: Api call failed with status code ${response.statusCode}",
        data: null,
      );
    }
  }
}

class ResetMessage {
  Future<ApiResponse<Object>> call() async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resetMessageUrl}'),
      headers: {'Authorization': 'Bearer ${ApiConstants.token}'},
    );

    if (response.statusCode == 200) {
      return ApiResponse(
        success: true,
        message: "Message Reset",
        data: json.decode(response.body),
      );
    } else {
      return ApiResponse(
        success: false,
        message:
            "Error: Api call failed with status code ${response.statusCode}",
        data: null,
      );
    }
  }
}
