class RequestPayload {
  final String requestId;
  final String status;

  RequestPayload({required this.requestId, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'status': this.status,
    };
  }

}