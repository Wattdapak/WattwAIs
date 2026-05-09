import 'package:flutter/material.dart';
import 'package:wattwais/screens/widgets/dashboard/bills_card.dart';
import 'package:wattwais/screens/widgets/dashboard/stat_card.dart';
import 'widgets/dashboard/header_section.dart';
class Dashboard extends StatelessWidget {

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderSection(),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            children: [
              const BillCard(),

              Row(
                children: [

                  Expanded(
                    child: StatCard(
                      title: "This Month", 
                      value: "placeholder", 
                      subtitle: "comparison to last month", 
                      subtitleColor: Colors.greenAccent
                    ),
                  ),

                  Expanded(
                    child: StatCard(
                      title: "Usage kWh", 
                      value: "placeholder", 
                      subtitle: "avg per day", 
                      subtitleColor: Colors.grey
                    ),
                  ),
                ],
              )
            ],
          )
        )
      ],
    );
  }
}