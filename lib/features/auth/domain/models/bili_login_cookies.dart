/// Cookies required to authenticate Bilibili API requests.
class BiliLoginCookies {
  const BiliLoginCookies({
    required this.sessdata,
    required this.biliJct,
    this.dedeUserId,
  });

  final String sessdata;
  final String biliJct;
  final String? dedeUserId;

  static BiliLoginCookies? fromCookieMap(Map<String, String> cookies) {
    final sessdata = cookies['SESSDATA']?.trim();
    final biliJct = cookies['bili_jct']?.trim();
    final dedeUserId = cookies['DedeUserID']?.trim();

    if (sessdata == null ||
        sessdata.isEmpty ||
        biliJct == null ||
        biliJct.isEmpty) {
      return null;
    }

    return BiliLoginCookies(
      sessdata: sessdata,
      biliJct: biliJct,
      dedeUserId: dedeUserId?.isNotEmpty == true ? dedeUserId : null,
    );
  }
}
