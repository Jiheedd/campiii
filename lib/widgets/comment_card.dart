import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(snap["uid"]).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print("data = ${snapshot.data}");
          return Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  snapshot.data!['photoUrl'],
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: snapshot.data!['username'],
                                style: const TextStyle(fontWeight: FontWeight.bold,)
                            ),
                            TextSpan(
                              text: ' ${snap['text']}',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.yMMMd().format(
                            snap['datePublished'].toDate(),
                          ),
                          style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.favorite,
                  size: 16,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
