import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/utils/storage.dart';

class AuthInterceptor implements InterceptorContract {
  bool _isRefreshing = false;
  int _retryCount = 0;
  static const int maxRetries = 3;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    print('🔵 Intercepting request: ${request.url}');

    if (request.url.toString().contains('refresh-tokens') ||
        request.url.toString().contains('login')) {
      return request;
    }

    final token = await StorageService.getToken('accessToken');
    if (token != null) {
      print('🔑 Adding token: ${token.substring(0, 10)}...');
      (request as Request).headers['Authorization'] = 'Bearer $token';
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
        
    if (response.statusCode == 401 &&
        !_isRefreshing &&
        _retryCount < maxRetries) {
      try {
        _isRefreshing = true;
        _retryCount++;

        final refreshToken = await StorageService.getToken('refreshToken');
        if (refreshToken == null) {
          print('❌ No refresh token found');
          return response;
        }

        print('🔄 Refreshing token attempt $_retryCount/$maxRetries');
        final result = await AuthService.refreshTokens(refreshToken);

        if (result.success) {
          print('✅ Token refresh successful');
          final newToken = await StorageService.getToken('accessToken');

          if (newToken != null && response.request != null) {
            final request = response.request! as http.Request;
            final newRequest = http.Request(request.method, request.url)
              ..headers.addAll({
                'Authorization': 'Bearer $newToken',
                'Content-Type': 'application/json',
              })
              ..body = request.body;

            final retryResponse = await http.Client().send(newRequest);
            final finalResponse = await http.Response.fromStream(retryResponse);

            if (finalResponse.statusCode < 400) {
              _retryCount = 0;
              return finalResponse;
            }
          }
        }
      } finally {
        _isRefreshing = false;
      }
    }

    return response;
  }

  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;
}
