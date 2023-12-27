class LastMessages {
  final String id;
  final String message;
  LastMessages({
    required this.id,
    required this.message,
  });

  LastMessages copyWith({
    String? id,
    String? message,
  }) {
    return LastMessages(
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }

  @override
  String toString() => 'LastMessages(id: $id, message: $message)';
}
