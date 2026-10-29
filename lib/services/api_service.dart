import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  
  ApiService({this.baseUrl = 'https://api.example.com'});
  
  Future<Map<String, dynamic>> updateStatus({
    required String studentId,
    required String action,
    required String updatedBy,
  }) async {
    final uri = Uri.parse('/api/internship/status-update');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student_id': studentId,
        'action': action,
        'updated_by': updatedBy,
      }),
    );
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    throw ApiException('Failed to update status: ');
  }
  
  Future<bool> sendEmail({required String to, required String subject, required String body}) async {
    final uri = Uri.parse('/api/email/send');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'to': to, 'subject': subject, 'body': body}),
    );
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
