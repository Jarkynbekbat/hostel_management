import 'package:flutter/material.dart';

class InfoBloc extends StatelessWidget {
  final int count;
  final String subtitle;
  final String goTo;

  const InfoBloc({
    @required this.count,
    @required this.subtitle,
    @required this.goTo,
  });

  @override
  Widget build(BuildContext context) {
    const countTextStyle = const TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    var subtitleTextStyle = TextStyle(
      fontSize: 15.0,
      color: Colors.white.withOpacity(0.8),
    );

    return Padding(
      padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 9.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.blue,
          child: ListTile(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count', style: countTextStyle),
                Text(subtitle, style: subtitleTextStyle),
              ],
            ),
            trailing: InkWell(
              onTap: () => Navigator.of(context).pushNamed(goTo),
              child: CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
      ),
    );
  }
}