import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TaskShimmerPage extends StatelessWidget {
  const TaskShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: 5,
        itemExtent: 200,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: width,
                      height: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: width,
                      height: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
              ));
        });
  }
}
