import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviereminder/helper/ads/banner.ads.dart';
import 'package:moviereminder/helper/faker/genres.faker.dart';
import 'package:moviereminder/model/movie.model.dart';
import 'package:moviereminder/network/api_builder.dart';
import 'package:moviereminder/network/methods/get.dart';
import 'package:moviereminder/network/middleware/formData.middleware.dart';
import 'package:moviereminder/widget/loading.dart';
import 'package:moviereminder/widget/nothing.dart';

import '../helper/ads/ads.dart';
import '../helper/colors.dart';
import '../model/genre.model.dart';
import '../widget/glassmorphism.dart';
import '../widget/top10.dart';

class SearchScreen extends StatefulWidget {
  final String? titleSearch;
  final int? genreSearch;
  final String searchType;

  const SearchScreen({Key? key, this.titleSearch, this.genreSearch, required this.searchType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  late ScrollController scrollController;
  int? selectedGenre;
  int? selectedScore;
  String? selectedType;
  int page = 1;
  int totalPage = 1;
  List<MovieModel> movies = [];
  List<GenreModel> genres = [];
  bool isLoadMoreMovies = false;
  bool isLoading = true;
  Map<int, BannerAd> adRepository = {};

  BannerAd generateBannerAd() {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          // setState(() {
          // });
        },
        onAdFailedToLoad: (ad, err) {
          // setState(() {
          // });
          ad.dispose();
        },
      ),
    )..load();
  }

  getGenreDropDownItems(data, width) {
    List<DropdownMenuItem<int>> items = [];
    data.forEach((element) {
      items.add(DropdownMenuItem<int>(
        value: element.id,
        child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              element.title,
              style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 14, color: primaryColor)),
            )),
      ));
    });
    return items;
  }

  getRateDropDownItems(data, width) {
    List<DropdownMenuItem<int>> items = [];
    data.forEach((element) {
      items.add(DropdownMenuItem<int>(
        value: element.score,
        child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              element.title,
              style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 14, color: primaryColor)),
            )),
      ));
    });
    return items;
  }

  getTypeDropDownItems(data, width) {
    List<DropdownMenuItem<String>> items = [];
    data.forEach((element) {
      items.add(DropdownMenuItem<String>(
        value: element,
        child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              element,
              style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 14, color: primaryColor)),
            )),
      ));
    });
    return items;
  }

  getMovies() async {
    Response? response = await ApiBuilder()
        .setRoute('/movie')
        .addQuery("Search", searchController.text)
        .addQuery("Rate", selectedScore ?? '')
        .addQuery("GenreId", selectedGenre ?? '')
        .addQuery("Type", selectedType ?? '')
        .addQuery("page", page)
        .setMethod(GetMethod())
        .addMiddleware(FormDataMiddleware())
        .call();
    if (response?.statusCode == 200) {
      response?.data["data"]["list"].forEach((item) => {movies.add(MovieModel.fromJSON(item))});
      isLoadMoreMovies = false;
      isLoading = false;
      setState(() {});
    }
  }

  getGenres() async {
    Response? response = await ApiBuilder()
        .setRoute('/genre')
        .addQuery('pageSize', '-1')
        .setMethod(GetMethod())
        .addMiddleware(FormDataMiddleware())
        .call();
    if (response?.statusCode == 200) {
      response?.data["data"]["list"].forEach((item) => {genres.add(GenreModel.fromJSON(item))});
      getMovies();
    }
  }

  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.maxScrollExtent - scrollController.position.pixels < 10) {
          page++;
          isLoadMoreMovies = true;
          setState(() {});
          getMovies();
        }
      });
    if (widget.genreSearch != null) {
      selectedGenre = widget.genreSearch;
    }
    if (widget.titleSearch != null) {
      searchController.text = widget.titleSearch!;
    }
    if (widget.searchType.isNotEmpty) {
      selectedType = widget.searchType;
    }
    getGenres();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
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
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 16),
                          child: Glassmorphism(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                                  child: Text(
                                    'search title:',
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Glassmorphism(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: width - 64,
                                          child: TextField(
                                            maxLines: 1,
                                            style: const TextStyle(color: primaryColor),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(16.0),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: primaryColor, width: 1.0),
                                              ),
                                            ),
                                            controller: searchController,
                                          ),
                                        )
                                      ],
                                    ),
                                    width: width,
                                    height: 48,
                                    border: 1,
                                    borderRadius: 10,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  child: Text(
                                    'genre:',
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Glassmorphism(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: selectedGenre,
                                          dropdownColor: backgroundMainColor,
                                          isExpanded: true,
                                          hint: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Text(
                                              'choose genre...',
                                              style:
                                                  GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor)),
                                            ),
                                          ),
                                          items: getGenreDropDownItems(genres, width - 88),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedGenre = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      width: width,
                                      height: 48,
                                      border: 1,
                                      borderRadius: 10,
                                    )),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16, right: 16),
                                          child: Text(
                                            'score:',
                                            style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            child: Glassmorphism(
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<int>(
                                                  value: selectedScore,
                                                  dropdownColor: backgroundMainColor,
                                                  isExpanded: true,
                                                  hint: Padding(
                                                    padding: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      'choose score...',
                                                      style: GoogleFonts.openSans(
                                                          textStyle: const TextStyle(color: primaryColor)),
                                                    ),
                                                  ),
                                                  items: getRateDropDownItems(getScores(), width - 88),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedScore = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              width: width / 2 - 50,
                                              height: 48,
                                              border: 1,
                                              borderRadius: 10,
                                            )),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16, right: 16),
                                          child: Text(
                                            'type:',
                                            style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            child: Glassmorphism(
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: selectedType,
                                                  dropdownColor: backgroundMainColor,
                                                  isExpanded: true,
                                                  hint: Padding(
                                                    padding: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      'choose type...',
                                                      style: GoogleFonts.openSans(
                                                          textStyle: const TextStyle(color: primaryColor)),
                                                    ),
                                                  ),
                                                  items: getTypeDropDownItems(getTypes(), width - 88),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedType = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              width: width / 2 - 50,
                                              height: 48,
                                              border: 1,
                                              borderRadius: 10,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                                    child: InkWell(
                                      child: Container(
                                        width: width,
                                        height: 36,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: primaryColor, borderRadius: BorderRadius.all(Radius.circular(12))),
                                        child: Text(
                                          "Search",
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                                        ),
                                      ),
                                      enableFeedback: true,
                                      onTap: () {
                                        isLoading = true;
                                        movies = [];
                                        setState(() {});
                                        getMovies();
                                      },
                                    )),
                              ],
                            ),
                            width: width,
                            height: 305,
                            border: 1,
                            borderRadius: 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: movies.isEmpty
                              ? const Nothing()
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: movies.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index % 5 == 0) {
                                      if (!adRepository.containsKey(index)) {
                                        adRepository[index] = generateBannerAd();
                                      }
                                      return Column(
                                        children: [
                                          BannerAds(bannerAd: adRepository[index]!),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: Top10(movie: movies[index]),
                                          )
                                        ],
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Top10(movie: movies[index]),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Visibility(
                            child: const CircularProgressIndicator(),
                            visible: isLoadMoreMovies,
                          ),
                        )
                      ],
                    ),
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
                              style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    child: Positioned(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(color: blurBackground, borderRadius: BorderRadius.circular(50)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: IconButton(
                              onPressed: () {
                                if (scrollController.hasClients) {
                                  scrollController.animateTo(0,
                                      duration: const Duration(seconds: 1), curve: Curves.linear);
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      bottom: 65,
                      right: 5,
                    ),
                    visible: scrollController.hasClients && scrollController.offset >= 400,
                  ),
                ],
              ),
              isLoading: isLoading,
            )));
  }
}
