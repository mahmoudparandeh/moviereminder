import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/model/movie.model.dart';
import 'package:moviereminder/network/methods/get.dart';
import 'package:moviereminder/widget/watch.list.widget.dart';

import '../global/global.dart';
import '../helper/colors.dart';
import '../helper/storage/storage.controller.dart';
import '../network/api_builder.dart';
import '../widget/loading.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WatchListState();
  }
}

class WatchListState extends State<WatchListScreen> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  bool isLoadMoreMovies = false;
  List<MovieModel> movies = [];

  getMyWatchList() async {
    Response? response = await ApiBuilder()
        .setRoute('/watchList')
        .setMethod(GetMethod())
        .addHeader('Authorization', StorageController.getAccessToken())
        .call();
    if (response?.statusCode == 200) {
      response?.data["data"]["list"]
          .forEach((item) => {movies.add(MovieModel.fromJSON(item))});
      if (mounted) {
        isLoadMoreMovies = false;
        isLoading = false;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    if (mounted) {
      GlobalState.onChangeWatchList.listen((event) {
        if (event == true) {
          movies.clear();
          setState(() {
            isLoading = true;
          });
          getMyWatchList();
        }
      });
    }
    getMyWatchList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: backgroundMainColor,
            body: Loading(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 52, bottom: 16),
                        width: width,
                        alignment: Alignment.center,
                        child: Text(
                          'My Watch List',
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      ListView.builder(
                        controller: scrollController,
                        itemCount: movies.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, right: 16, left: 16),
                            child: WatchListItem(movie: movies[index]),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: width,
                    height: 48,
                    color: blurBackground,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Back to home",
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isLoading: isLoading,
            )));
  }
}
