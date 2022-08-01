enum Status { success, error, loading, timeout, internetError }

/// Class ini akan dipanggil di setiap pemanggilan API,
///
/// property/fieldnya berdasarkan response dari API
class NetworkResponses {
  final Status status;
  final String? message;
  final Map<String, dynamic>? data;

  NetworkResponses(
    this.status,
    this.message,
    this.data,
  );

  /// Method untuk nanganin setiap status success
  static NetworkResponses success(data) {
    return NetworkResponses(Status.success, null, data);
  }

  /// Method untuk nanganin setiap status error
  static NetworkResponses error({data, String? message}) {
    return NetworkResponses(Status.error, message, null);
  }

  /// Method untuk nanganin setiap status internetError
  static NetworkResponses internetError() {
    return NetworkResponses(Status.error, null, null);
  }
}
