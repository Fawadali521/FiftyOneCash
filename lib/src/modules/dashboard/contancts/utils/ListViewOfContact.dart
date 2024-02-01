import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/ContactsTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ListViewOfContacts extends StatelessWidget {
  ListViewOfContacts({
    super.key,
    required this.contacts,
    required this.width,
    required this.filter,
  });

  final ScrollController scrollController = ScrollController();
  final List<ContactsDetails> contacts;
  final double width;
  final String filter;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      
      child: ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        addAutomaticKeepAlives: false,
        padding: const EdgeInsets.only(bottom: 60, top: 10),
        itemCount: contacts.length,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 1000),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: ContactsTile(
                contact: contacts[index],
                filter: filter,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
