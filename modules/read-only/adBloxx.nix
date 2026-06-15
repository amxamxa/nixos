{ config, pkgs, ... }:

{
  networking.extraHosts = ''
  # Spotify & Ad-Block entries
  0.0.0.0 audio-ads.spotify.com
  0.0.0.0 adclick.g.doubleclick.net
  0.0.0.0 pubads.g.doubleclick.net
  0.0.0.0 spclient.wg.spotify.com
  0.0.0.0 heads-ec.spotify.com
  0.0.0.0 ads-fa.spotify.com
  0.0.0.0 adeventtracker.spotify.com
  0.0.0.0 pagead46.l.doubleclick.net
  0.0.0.0 securepubads.g.doubleclick.net
  0.0.0.0 googleads.g.doubleclick.net
  0.0.0.0 www.googletagservices.com
  0.0.0.0 www.googleadservices.com
  0.0.0.0 tpc.googlesyndication.com
  0.0.0.0 pagead2.googlesyndication.com
  0.0.0.0 stats.g.doubleclick.net
  0.0.0.0 ads.g.doubleclick.net
  0.0.0.0 googlesyndication.com
  0.0.0.0 s0.2mdn.net
  0.0.0.0 static.doubleclick.net
  0.0.0.0 crashlytics.com
  0.0.0.0 metrics.spotify.com
  0.0.0.0 log.spotify.com
  0.0.0.0 google-analytics.com
  0.0.0.0 ssl.google-analytics.com
  0.0.0.0 analytics.google.com
  0.0.0.0 ads.yahoo.com
  0.0.0.0 ads-twitter.com
  0.0.0.0 ads.linkedin.com
  0.0.0.0 ads.facebook.com
  0.0.0.0 secure.adnxs.com
  0.0.0.0 ib.adnxs.com
  0.0.0.0 adservice.google.com
  0.0.0.0 adservice.google.co
'';
 
}
