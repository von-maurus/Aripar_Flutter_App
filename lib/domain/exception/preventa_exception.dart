class PreSaleException implements Exception {
  PreSaleException(this.errorMessages);

  dynamic errorMessages;

  dynamic getMessage() {
    return errorMessages;
  }
}
