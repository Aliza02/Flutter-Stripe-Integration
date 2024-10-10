class NetworkEventResponse<T> {
  final String? message;
  final bool? status;
  final T? response;

  const NetworkEventResponse.failure({this.message, this.status, this.response});
  const NetworkEventResponse.success({this.message, this.status, this.response});
}
