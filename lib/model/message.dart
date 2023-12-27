class Message {
  final String? from;
  final String? to;
  final String? content;
  final dynamic timestamp; // You might want to adjust the type for timestamp

  Message({this.from, this.to, this.content, this.timestamp});

  Message.fromJson(Map<String, dynamic> json)
      : from = json['from'],
        to = json['to'],
        content = json['content'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'content': content,
        'timestamp': timestamp,
      };

  @override
  String toString() {
    return 'Message{from: $from, to: $to, content: $content, timestamp: $timestamp}';
  }
}

class Conversation {
  final String user1Id;
  final String user2Id;
  Conversation({required this.user1Id, required this.user2Id});
}
