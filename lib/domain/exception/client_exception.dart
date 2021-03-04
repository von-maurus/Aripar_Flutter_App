class ClientException implements Exception {
  ClientException(this.errorMessages);

  dynamic errorMessages;

  dynamic getMessage() {
    return errorMessages;
  }
}
