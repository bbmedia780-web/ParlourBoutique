
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final dynamic error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.error,
  });

  /// Creates a successful response
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int? statusCode,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  /// Creates an error response
  factory ApiResponse.error({
    required String message,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }

  /// Check if the response is successful
  bool get isSuccess => success;

  /// Check if the response is an error
  bool get isError => !success;

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
  }
}

