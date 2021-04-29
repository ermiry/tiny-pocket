class HttpException implements Exception {
  final String message;
  Code code;
  HttpException(this.message, {this.code});

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }

}

enum Code {
    Transaction,
    Place,
    Category,
    Network,
    Device
  }