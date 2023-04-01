class SocketError {
  final String? errorMessage;

  SocketError({this.errorMessage});

  @override
  String toString() {
    return 'Socket Error: $errorMessage';
  }
}
