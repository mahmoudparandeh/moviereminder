import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../widget/glassmorphism.dart';

class BannerAds extends StatelessWidget{
  final BannerAd bannerAd;
  const BannerAds({Key? key, required this.bannerAd}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(width: width, height: bannerAd.size.height.toDouble(), alignment: Alignment.center,margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), child: Glassmorphism(child: AdWidget(ad: bannerAd),
        borderRadius: 12,
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        border: 2),);
  }

}