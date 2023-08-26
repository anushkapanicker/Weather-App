import 'package:flutter/material.dart';

class HourlyForcastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForcastCard(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                temp,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
