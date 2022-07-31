enum Status { success, error, loading, timeout, internetError }

// Class ini akan dipanggil di setiap pemanggilan API, property/fieldnya berdasarkan response dari API
class NetworkResponses {
  final Status status;
  final String? message;
  final Map<String, dynamic>? data;

  NetworkResponses(
    this.status,
    this.message,
    this.data,
  );

  // Buat method untuk nanganin setiap enum
  static NetworkResponses success(data) {
    return NetworkResponses(Status.success, null, data);
  }

  static NetworkResponses error({data, String? message}) {
    return NetworkResponses(Status.error, message, null);
  }

  static NetworkResponses internetError() {
    return NetworkResponses(Status.error, null, null);
  }
}
