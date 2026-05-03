import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A4F), // dark blue background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(),
              SizedBox(height: 20),
              BillCard(),
              SizedBox(height: 20),
              StatsRow(),
              SizedBox(height: 20),
              Divider(color: Colors.white24),
              SizedBox(height: 10),
              Text(
                "Bill History",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// header
class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?img=3',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "Hello, @user",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        Icon(Icons.notifications, color: Colors.white),
      ],
    );
  }
}

// main bill card
class BillCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color(0xFF9EC9FF),
            Color(0xFF3A7BFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your estimated bill for April 2026",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            "₱8,756.30",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "15% above your budget",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: Text("View bill breakdown"),
          ),
        ],
      ),
    );
  }
}

// stats row
class StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: StatCard(
          title: "Usage (kWh)",
          value: "610",
          subtitle: "Average 20/kWh a day",
        )),
        SizedBox(width: 12),
        Expanded(child: StatCard(
          title: "This Month",
          value: "₱8,437",
          subtitle: "+3.5% vs last month",
        )),
      ],
    );
  }
}

// reusable stat card widget
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Color(0xFF9EC9FF),
            Color(0xFF3A7BFF),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}