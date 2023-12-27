import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool isCurrentUser;
  const MessageBubble(
      {super.key,
      required this.msgText,
      required this.msgSender,
      required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                msgSender,
                style: TextStyle(
                    fontSize: 13, color: theme.colorScheme.primaryContainer),
              ),
            ),
            Material(
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(50),
                topLeft: isCurrentUser
                    ? const Radius.circular(50)
                    : const Radius.circular(0),
                bottomRight: const Radius.circular(50),
                topRight: isCurrentUser
                    ? const Radius.circular(0)
                    : const Radius.circular(50),
              ),
              color: isCurrentUser ? Colors.blue : Colors.white,
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  msgText,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.blue,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
