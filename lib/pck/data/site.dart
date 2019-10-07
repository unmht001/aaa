class Site {
  String siteName;
  String siteBaseUrl;
  String siteUID;
  String menuUrl;
  String menuSoupTag;
  String menuPattan;
  String siteCharset;
  String contentSoupTap;
  String contentPatten;
  Site.fromMap(Map mp) {
    this.siteName = mp["siteName"];
    this.siteBaseUrl = mp["siteBaseUrl"];
    this.siteUID = mp["siteUID"];
    this.menuUrl = mp["menuUrl"];
    this.menuSoupTag = mp["menuSoupTag"];
    this.menuPattan = mp["menuPattan"];
    this.siteCharset = mp["siteCharset"];
    this.contentSoupTap = mp["contentSoupTap"];
    this.contentPatten = mp["contentPatten"];
  }
  toMap() => {
        "siteName": this.siteName,
        "siteUID": this.siteUID,
        "siteBaseUrl": this.siteBaseUrl,
        "menuUrl": this.menuUrl,
        "menuSoupTag": this.menuSoupTag,
        "menuPattan": this.menuPattan,
        "siteCharset": this.siteCharset,
        "contentSoupTap": this.contentSoupTap,
        "contentPatten": this.contentPatten,
        "bookBaseUrls": this.bookBaseUrls
      };
  toString() => toMap.toString();

  Map<String, String> bookBaseUrls = {};
}
