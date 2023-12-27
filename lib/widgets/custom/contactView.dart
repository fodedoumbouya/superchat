import 'package:flutter/material.dart';
import 'package:superchat/model/users.dart';

class ContactView extends StatelessWidget {
  final UsersModel user;
  final String lastMessage;
  final void Function() onTap;
  const ContactView(
      {required this.user,
      required this.lastMessage,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      tileColor: theme.primaryColor,
      onTap: onTap,
      leading: const CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/17093612?v=4'),
      ),
      title: Text(
        user.displayName ?? '',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        lastMessage,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
