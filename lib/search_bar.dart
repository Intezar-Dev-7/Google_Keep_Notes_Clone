import 'package:flutter/material.dart';
import 'package:google_keep_notes_clone/screens/search_screen.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';

class SearchBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;

  const SearchBar({
    super.key,
    required this.drawerKey, // Accept the passed drawerKey
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width,
          height: 55,
          decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        drawerKey.currentState?.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: white,
                      )),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchScreen()));
                    },
                    child: const SizedBox(
                        height: 55,
                        width: 190,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Search Your Notes",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )
                            ])),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                            overlayColor: WidgetStateColor.resolveWith(
                                (states) => white.withOpacity(0.1)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ))),
                        onPressed: () {},
                        child: const Icon(
                          Icons.grid_view,
                          color: white,
                        )),
                    const SizedBox(
                      width: 9,
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
