import 'package:flutter/material.dart';
import 'package:google_keep_notes_clone/services/login_info.dart';
import 'package:google_keep_notes_clone/screens/login_screen.dart';
import 'package:google_keep_notes_clone/screens/search_screen.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';

class SearchBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> drawerKey;

  const SearchBar({
    super.key,
    required this.drawerKey, // Accept the passed drawerKey
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool isStaggered = true;
  late String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 55,
          width: MediaQuery.of(context).size.width / 3,
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
                        widget.drawerKey.currentState?.openDrawer();
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
                        onPressed: () {
                          setState(() {
                            isStaggered = !isStaggered;
                          });
                        },
                        child: const Icon(
                          Icons.grid_view,
                          color: white,
                        )),
                    const SizedBox(
                      width: 9,
                    ),
                    GestureDetector(
                      onTap: () {
                        // SignOut();
                        LocalDataSaver.saveLoginData(false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: CircleAvatar(
                        onBackgroundImageError: (Object, StackTrace) {},
                        radius: 16,
                        backgroundImage: NetworkImage(imageUrl.toString()),
                      ),
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
