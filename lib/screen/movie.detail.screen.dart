import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviereminder/helper/ads/banner.ads.dart';
import 'package:moviereminder/helper/colors.dart';
import 'package:moviereminder/helper/navigator.dart';
import 'package:moviereminder/helper/storage/storage.controller.dart';
import 'package:moviereminder/model/reminder.mode.dart';
import 'package:moviereminder/network/api_builder.dart';
import 'package:moviereminder/network/methods/get.dart';
import 'package:moviereminder/network/methods/post.dart';
import 'package:moviereminder/network/middleware/formData.middleware.dart';
import 'package:moviereminder/screen/video.screen.dart';
import 'package:moviereminder/widget/artist.dart';
import 'package:moviereminder/widget/glassmorphism.dart';
import 'package:moviereminder/widget/loading.dart';
import 'package:moviereminder/widget/reminder.widget.dart';

import '../helper/ads/ads.dart';
import '../helper/toast.dart';
import '../model/movie.model.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MovieDetailState();
  }
}

class MovieDetailState extends State<MovieDetailScreen> {
  bool isLoading = true;
  MovieModel movie = MovieModel();
  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  bool isInterstitialAdReady = false;
  bool isBannerAdReady = false;

  void initBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }

  void initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {

            },
          );
          isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  getMovie() async {
    Response? response = await ApiBuilder()
        .setRoute("/movie/" + widget.movieId.toString())
        .setMethod(GetMethod())
        .call();
    if (response?.statusCode == 200) {
      movie = MovieModel.fromJsonComplex(response?.data["data"]);
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    initBannerAd();
    initInterstitialAd();
    getMovie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(child: Scaffold(
        backgroundColor: backgroundMainColor,
        body: Stack(
          children: [
            Loading(isLoading: isLoading && !isBannerAdReady && !isInterstitialAdReady, isFullWidth: true, child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: movie.bigImage,
                            fit: BoxFit.cover,
                            width: width,
                            height: 300,
                            placeholder: (buildContext, url) =>
                            const Center(child: CircularProgressIndicator(),),
                          ),
                          Positioned(
                            child: Glassmorphism(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/imdb.png',
                                        width: 35,
                                      ),
                                      Text(movie.imdbScore,
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                fontSize: 14,
                                                foreground: Paint()
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeWidth = 1
                                                  ..color = primaryColor,
                                              )))
                                    ],
                                  ),
                                ),
                                borderRadius: 8,
                                border: 1,
                                width: 70,
                                height: 24),
                            top: 12,
                            right: 12,
                          ),
                          Positioned(
                            right: 12,
                            bottom: 12,
                            child: InkWell(
                              child: Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    border: Border.all(color: primaryColor, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: const Icon(Icons.favorite, color: primaryColor,),
                              ),
                              enableFeedback: true,
                              onTap: () async{
                                if(StorageController.isAuthenticate()) {
                                  Response? response = await ApiBuilder()
                                      .setRoute('/watchList')
                                      .setMethod(PostMethod())
                                      .addHeader('Authorization', StorageController.getAccessToken())
                                      .addBody('MovieId', widget.movieId.toString())
                                      .addMiddleware(FormDataMiddleware())
                                      .call();
                                  if(response?.statusCode == 200) {
                                    Toast.success(response?.data['message']);
                                    Future.delayed(const Duration(milliseconds: 2000), () => {
                                      interstitialAd.show()
                                    });
                                  }
                                } else {
                                  Toast.error('Please login to use this feature');
                                }
                              },
                            ),
                          ),
                          Positioned(
                            right: 70,
                            bottom: 12,
                            child: InkWell(
                              child: Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    border: Border.all(color: primaryColor, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: const Icon(Icons.add_alert, color: primaryColor,),
                              ),
                              enableFeedback: true,
                              onTap: () {
                                showModalBottomSheet<void>(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: ReminderWidget(isEdit: false, movie: movie, reminder: ReminderModel(),),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      Padding(padding: const EdgeInsets.only(
                          right: 16, left: 16, top: 16),
                        child: Text(movie.title, textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),),),
                      Container(height: 30, margin: const EdgeInsets.only(top: 12, right: 16, left: 16), child: ListView.builder(
                          itemCount: movie.genres.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (buildContext, index) {
                            return Padding(padding: const EdgeInsets.only(right: 8), child: Glassmorphism(
                              width: width / 3,
                              border: 1,
                              height: 30,
                              borderRadius: 10,
                              child: Padding(padding: const EdgeInsets.all(4),
                                child: Text(movie.genres[index].title,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: primaryColor, fontSize: 16),),),
                              ),
                            ),);
                          }),),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        width: width,
                        height: 1,
                        color: const Color(0xFF3C3C3C),
                      ),
                      if(isBannerAdReady)
                        BannerAds(bannerAd: bannerAd),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(movie.description, textAlign: TextAlign.justify, style: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white, fontSize: 16)),),),
                      Padding(padding: const EdgeInsets.only(top: 12, bottom: 0, right: 16, left: 16), child: Text("Casts:", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor, fontSize: 18)),)),
                      Container(height: 120, margin: const EdgeInsets.only(top: 12, right: 16, left: 16), child: ListView.builder(
                          itemCount: movie.casts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (buildContext, index) {
                            return Padding(padding: const EdgeInsets.only(right: 12), child: Artist(artist: movie.casts[index],),);
                          }),),
                      Visibility(child: Padding(padding: const EdgeInsets.only(top: 12, bottom: 0, right: 16, left: 16), child: Text("Trailers:", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor, fontSize: 18)),)),visible: movie.trailers.isNotEmpty,),
                      Container(height: 120, margin: const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 16), child: ListView.builder(
                          itemCount: movie.trailers.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (buildContext, index) {
                            return Padding(padding: const EdgeInsets.only(right: 12), child: Glassmorphism(
                              width: width/2,
                              height: 150,
                              borderRadius: 12,
                              border: 1,
                              child: InkWell(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CachedNetworkImage(imageUrl: movie.trailers[index].cover, fit: BoxFit.fill, width: width/2, height: 150,),
                                    const Icon(Icons.play_arrow_outlined, color: Colors.white, size: 48,)
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(context, SlideBottomRoute(page: VideoScreen(videoUrl: movie.trailers[index].link,)));
                                },
                              ),
                            ),);
                          }),),
                    ],
                  ),
                ),
                IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: backBlurBackground,
                        borderRadius: BorderRadius.circular(50)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 0, sigmaX: 0),
                      child: const Icon(Icons.arrow_back, color: Colors.white,
                      ),
                    )))
              ],
            ),),
          ],
        )
    ));
  }
}