class Failure {
  final int errorCode;
  final String message;
  final String title;
  const Failure(this.errorCode, this.message, {this.title = ''});

  @override
  String toString() {
    return message;
  }
}
