import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviereminder/helper/colors.dart';
import 'package:moviereminder/helper/faker/genres.faker.dart';
import 'package:moviereminder/helper/navigator.dart';
import 'package:moviereminder/helper/toast.dart';
import 'package:moviereminder/model/movie.model.dart';
import 'package:moviereminder/network/api_builder.dart';
import 'package:moviereminder/network/methods/get.dart';
import 'package:moviereminder/screen/search.screen.dart';
import 'package:moviereminder/widget/bottombar.widget.dart';
import 'package:moviereminder/widget/genre.dart';
import 'package:moviereminder/widget/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moviereminder/widget/loading.dart';
import 'package:moviereminder/widget/movie.dart';
import 'package:moviereminder/widget/top10.dart';
import '../helper/ads/ads.dart';
import '../helper/ads/banner.ads.dart';
import '../model/genre.model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{
  TextEditingController searchController = TextEditingController();
  List<GenreModel> genres = getGenres();
  List<MovieModel> top10 = [];
  List<MovieModel> movies = [];
  List<MovieModel> series = [];
  List<MovieModel> animes = [];
  bool isLoading = true;
  late BannerAd bannerAd1;
  late BannerAd bannerAd2;
  late BannerAd bannerAd3;
  bool isBannerAdReady1 = false;
  bool isBannerAdReady2 = false;
  bool isBannerAdReady3 = false;
  void initBannerAd() {
    bannerAd1 = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady1 = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady1 = false;
          ad.dispose();
        },
      ),
    );
    bannerAd1.load();
    bannerAd2 = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady2 = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady2 = false;
          ad.dispose();
        },
      ),
    );
    bannerAd2.load();
    bannerAd3 = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady3 = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady3 = false;
          ad.dispose();
        },

      ),
    );
    bannerAd3.load();
    setState(() {});
  }
  @override
  void initState() {
    initBannerAd();
    getMovies();
    super.initState();
  }

  getMovies() async {
    Response? response = await ApiBuilder()
        .setRoute("/mainPage")
        .setMethod(GetMethod())
        .call();
    if (response?.statusCode == 200) {
      response?.data["data"]["top10"]["list"]
          .forEach((item) => {top10.add(MovieModel.fromJSON(item))});
      response?.data["data"]["movies"]["list"]
          .forEach((item) => {movies.add(MovieModel.fromJSON(item))});
      response?.data["data"]["series"]["list"]
          .forEach((item) => {series.add(MovieModel.fromJSON(item))});
      response?.data["data"]["animes"]["list"]
          .forEach((item) => {animes.add(MovieModel.fromJSON(item))});
      response?.data["data"]["genres"]["list"]
          .forEach((item) {
            int index = genres.indexWhere((element) => element.title == item['slug']);
            if(index >= 0) {
              genres[index].id = item['id'];
            }
      });
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundMainColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 45), child: SingleChildScrollView(
            child: Loading(isLoading: isLoading, isFullWidth: true, child: Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Glassmorphism(
                    child: Row(
                      children: [
                        SizedBox(
                          width: width - 32,
                          child: TextField(
                            maxLines: 1,
                            style: const TextStyle(color: primaryColor),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: primaryColor, width: 1.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  color: primaryColor,
                                  onPressed: () {
                                    if(searchController.value.text.isNotEmpty) {
                                      Navigator.push(context, SlideBottomRoute(page: SearchScreen(searchType: "", titleSearch: searchController.value.text,)));
                                    } else {
                                      Toast.error("please fill search input");
                                    }
                                  },
                                )),
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
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: Text("TOP 10",
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor))),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 0, bottom: 0),
                  child: CarouselSlider(
                      items: top10.map((movie) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Top10(movie: movie);
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 175,
                        viewportFraction: 0.9,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: Text("Genres",
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor))),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: genres.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Genre(genre: genres[index]),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Movies",
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor))),
                      InkWell(
                        child: Text("see all",
                            style: GoogleFonts.petitFormalScript(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor))),
                        onTap: () {
                          Navigator.push(context, SlideBottomRoute(page: const SearchScreen(searchType: 'movie',)));
                        },
                        enableFeedback: true,
                      )
                    ],),
                ),
                SizedBox(
                  height: width/2+100,
                  child: ListView.builder(
                      itemCount: movies.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Movie(movie: movies[index]),
                        );
                      }),
                ),
                if(isBannerAdReady1)
                  BannerAds(bannerAd: bannerAd1),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 0, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Series",
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor))),
                      InkWell(
                        child: Text("see all",
                            style: GoogleFonts.petitFormalScript(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor))),
                        onTap: () {
                          Navigator.push(context, SlideBottomRoute(page: const SearchScreen(searchType: 'series',)));
                        },
                        enableFeedback: true,
                      )
                    ],),
                ),
                SizedBox(
                  height: width/2+100,
                  child: ListView.builder(
                      itemCount: series.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Movie(movie: series[index]),
                        );
                      }),
                ),
                if(isBannerAdReady2)
                  BannerAds(bannerAd: bannerAd2),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 0, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Animation",
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor))),
                      InkWell(
                        child: Text("see all",
                            style: GoogleFonts.petitFormalScript(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor))),
                        onTap: () {
                          Navigator.push(context, SlideBottomRoute(page: const SearchScreen(searchType: 'anime',)));
                        },
                        enableFeedback: true,
                      )
                    ],),
                ),
                SizedBox(
                  height: width/2+100,
                  child: ListView.builder(
                      itemCount: animes.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Movie(movie: animes[index]),
                        );
                      }),
                ),
                if(isBannerAdReady3)
                  BannerAds(bannerAd: bannerAd3),
              ],
            ),),),
          ),),
          const Positioned(child: BottomBarWidget(), bottom: 10,)
        ],
      ),
    );
  }
}
