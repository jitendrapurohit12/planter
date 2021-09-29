import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const email = 'mimi@handprint.tech';
    const web = 'https://www.handprint.tech';
    return VStack([
      ContactUsUI('Email', email, Icons.email_rounded, () => launch('mailto:$email')),
      ContactUsUI('Web', web, Icons.computer, () async => launch(web)),
    ]).p16();
  }
}

class ContactUsUI extends StatelessWidget {
  final IconData icon;
  final VoidCallback callback;
  final String title, content;

  const ContactUsUI(this.title, this.content, this.icon, this.callback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback,
      leading: Icon(icon),
      title: title.text.make(),
      subtitle: content.text.make(),
    );
  }
}
