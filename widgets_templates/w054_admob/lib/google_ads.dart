import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants.dart';

class GoogleAds {
  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;

  /// Loads an interstitial ad.
  void loadInterstitialAd({bool showAfterLoad = false}) {
    InterstitialAd.load(
        // test kodunu girelim
        adUnitId: AdStrings.interstitialAd1,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            interstitialAd = ad;
            if (showAfterLoad) {
              showInterstitialAd();
            }
          },
          // Reklam yüklenmezse gelen hata
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  /// show InterstitialAd
  void showInterstitialAd() {
    if (interstitialAd != null){
      interstitialAd!.show();
    }
  }

  /// Loads a banner ad.
  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdStrings.bannerAd1,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          debugPrint('$ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  /// show banner ad
  SizedBox showBannerAd() {
    return SizedBox(
      width: bannerAd!.size.width.toDouble(),
      height: bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: bannerAd!),
    );
  }
}













