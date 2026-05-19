import "package:flutter/material.dart";

import "package:wattwais/models/bill_entry.dart";
import "package:wattwais/utils/bill_utils.dart";

//card widget that displays a single month's bill entry.
//input for bill amount and kWh usage.
class BillCard extends StatelessWidget {
  const BillCard({ super.key, required this.entry});

  //billEntry model with controllers and monthId.
  final BillEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //month header (e.g., "May 2026")
            Text(
              formatMonth(entry.monthId),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                //bill amount input field
                Expanded (
                  child: TextFormField(
                    controller: entry.billController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Bill Amount',
                      hintText: '3250',
                      prefixText: '₱ ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // kWh usage input field (optional)
                Expanded(
                  child: TextFormField(
                    controller: entry.kwhController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'kWh Used (Optional)',
                      hintText: '285',
                      suffixText: 'kWh',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
