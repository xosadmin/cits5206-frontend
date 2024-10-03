import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PodcastIndexApiService {
  final String _baseUrl = 'https://api.podcastindex.org/api/1.0';
  final String? _apiKey;
  final String? _apiSecret;

  PodcastIndexApiService()
      : _apiKey = dotenv.env['API_KEY'],
        _apiSecret = dotenv.env['API_SECRET'] {
    // Ensure API key and secret are not null
    if (_apiKey == null || _apiSecret == null) {
      throw Exception("API Key or Secret is not set!");
    }
  }

  Future<Map<String, dynamic>> _makeApiRequest(String endpoint, Map<String, String> queryParams) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final authHash = _generateAuthHash(timestamp);

    final response = await http.get(
      uri.replace(queryParameters: queryParams),
      headers: {
        'X-Auth-Date': timestamp,
        'X-Auth-Key': _apiKey!,
        'Authorization': authHash,
        'User-Agent': 'YourAppName/1.0',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('API request failed: ${response.statusCode}');
    }
  }

  String _generateAuthHash(String timestamp) {
    final authString = _apiKey! + _apiSecret! + timestamp;
    return sha1.convert(utf8.encode(authString)).toString();
  }

  // Search
  Future<Map<String, dynamic>> searchByTerm(String q, {int? max, String? val, bool? clean}) async {
    return _makeApiRequest('/search/byterm', {'q': q, if (max != null) 'max': max.toString(), if (val != null) 'val': val, if (clean != null) 'clean': clean.toString()});
  }

  Future<Map<String, dynamic>> searchByTitle(String q, {int? max, bool? clean}) async {
    return _makeApiRequest('/search/bytitle', {'q': q, if (max != null) 'max': max.toString(), if (clean != null) 'clean': clean.toString()});
  }

  Future<Map<String, dynamic>> searchByPerson(String q, {int? max, bool? clean}) async {
    return _makeApiRequest('/search/byperson', {'q': q, if (max != null) 'max': max.toString(), if (clean != null) 'clean': clean.toString()});
  }

  // Podcasts
  Future<Map<String, dynamic>> podcastsByFeedId(int id) async {
    return _makeApiRequest('/podcasts/byfeedid', {'id': id.toString()});
  }

  Future<Map<String, dynamic>> podcastsByFeedUrl(String url) async {
    return _makeApiRequest('/podcasts/byfeedurl', {'url': url});
  }

  Future<Map<String, dynamic>> podcastsByItunesId(int id) async {
    return _makeApiRequest('/podcasts/byitunesid', {'id': id.toString()});
  }

  Future<Map<String, dynamic>> podcastsByGuid(String guid) async {
    return _makeApiRequest('/podcasts/byguid', {'guid': guid});
  }

  Future<Map<String, dynamic>> podcastsByTag(String tag) async {
    return _makeApiRequest('/podcasts/bytag', {'tag': tag});
  }

  Future<Map<String, dynamic>> podcastsByMedium(String medium, {int? max, String? cat}) async {
    return _makeApiRequest('/podcasts/bymedium', {'medium': medium, if (max != null) 'max': max.toString(), if (cat != null) 'cat': cat});
  }

  Future<Map<String, dynamic>> podcastsTrending({int? max, String? lang, String? cat, String? notcat}) async {
    return _makeApiRequest('/podcasts/trending', {
      if (max != null) 'max': max.toString(),
      if (lang != null) 'lang': lang,
      if (cat != null) 'cat': cat,
      if (notcat != null) 'notcat': notcat,
    });
  }

  Future<Map<String, dynamic>> podcastsDeadFeed(int id, {String? url}) async {
    return _makeApiRequest('/podcasts/deadfeed', {'id': id.toString(), if (url != null) 'url': url});
  }

  // Episodes
  Future<Map<String, dynamic>> episodesByFeedId(int id, {int? max, int? since, String? fulltext}) async {
    return _makeApiRequest('/episodes/byfeedid', {
      'id': id.toString(),
      if (max != null) 'max': max.toString(),
      if (since != null) 'since': since.toString(),
      if (fulltext != null) 'fulltext': fulltext,
    });
  }

  Future<Map<String, dynamic>> episodesByFeedUrl(String url, {int? max, int? since, String? fulltext}) async {
    return _makeApiRequest('/episodes/byfeedurl', {
      'url': url,
      if (max != null) 'max': max.toString(),
      if (since != null) 'since': since.toString(),
      if (fulltext != null) 'fulltext': fulltext,
    });
  }

  Future<Map<String, dynamic>> episodesByItunesId(int id, {int? max, int? since, String? fulltext}) async {
    return _makeApiRequest('/episodes/byitunesid', {
      'id': id.toString(),
      if (max != null) 'max': max.toString(),
      if (since != null) 'since': since.toString(),
      if (fulltext != null) 'fulltext': fulltext,
    });
  }

  Future<Map<String, dynamic>> episodesByGuid(String guid, {String? feedid, String? feedurl}) async {
    return _makeApiRequest('/episodes/byguid', {'guid': guid, if (feedid != null) 'feedid': feedid, if (feedurl != null) 'feedurl': feedurl});
  }

  Future<Map<String, dynamic>> episodesByPerson(String person, {int? max, String? fulltext}) async {
    return _makeApiRequest('/episodes/byperson', {'person': person, if (max != null) 'max': max.toString(), if (fulltext != null) 'fulltext': fulltext});
  }

  Future<Map<String, dynamic>> episodesRandom({int? max, String? lang, String? cat}) async {
    return _makeApiRequest('/episodes/random', {if (max != null) 'max': max.toString(), if (lang != null) 'lang': lang, if (cat != null) 'cat': cat});
  }

  Future<Map<String, dynamic>> episodesLive({int? max}) async {
    return _makeApiRequest('/episodes/live', {if (max != null) 'max': max.toString()});
  }

  // Recent
  Future<Map<String, dynamic>> recentFeeds({int? max, String? lang, String? cat, String? notcat}) async {
    return _makeApiRequest('/recent/feeds', {
      if (max != null) 'max': max.toString(),
      if (lang != null) 'lang': lang,
      if (cat != null) 'cat': cat,
      if (notcat != null) 'notcat': notcat,
    });
  }

  Future<Map<String, dynamic>> recentEpisodes({int? max, String? lang, String? cat, String? notcat, bool? excludeString}) async {
    return _makeApiRequest('/recent/episodes', {
      if (max != null) 'max': max.toString(),
      if (lang != null) 'lang': lang,
      if (cat != null) 'cat': cat,
      if (notcat != null) 'notcat': notcat,
      if (excludeString != null) 'excludeString': excludeString.toString(),
    });
  }

  Future<Map<String, dynamic>> recentNewFeeds({int? max, String? lang, String? cat, String? notcat}) async {
    return _makeApiRequest('/recent/newfeeds', {
      if (max != null) 'max': max.toString(),
      if (lang != null) 'lang': lang,
      if (cat != null) 'cat': cat,
      if (notcat != null) 'notcat': notcat,
    });
  }

  Future<Map<String, dynamic>> recentSoundbites({int? max}) async {
    return _makeApiRequest('/recent/soundbites', {if (max != null) 'max': max.toString()});
  }

  // Value
  Future<Map<String, dynamic>> valueBlockGet(int feedId, {String? url}) async {
    return _makeApiRequest('/value/byfeedid', {'id': feedId.toString(), if (url != null) 'url': url});
  }

  Future<Map<String, dynamic>> valueBlockGetByFeedUrl(String url) async {
    return _makeApiRequest('/value/byfeedurl', {'url': url});
  }

  // Categories
  Future<Map<String, dynamic>> categoriesList() async {
    return _makeApiRequest('/categories/list', {});
  }

  // Hub
  Future<Map<String, dynamic>> hubPubNotify(String id, String url) async {
    return _makeApiRequest('/hub/pubnotify', {'id': id, 'url': url});
  }

  // Stats
  Future<Map<String, dynamic>> statsCurrentStats() async {
    return _makeApiRequest('/stats/current', {});
  }

  // Add any new endpoints here as they become available
}