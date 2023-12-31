import 'global.dart';
import 'table_cover.dart';
import 'table_description.dart';
import 'table_info.dart';
import 'table_title.dart';

Future<Cover?> extractCover(
    {required Map<String, dynamic> scrap, required bool withText}) async {
  try {
    String url = scrap['cover_high'];
    url = url.replaceAll('?type=TEXT&watermark=true', '');

    return Cover.download(
      lang: scrap['lang'],
      idThing: scrap['id_thing'],
      url: Uri.parse(url),
      withText: withText,
    );
  } catch (e) {
    log.severe('${scrap['id_thing']}␟extract_cover␟${e.toString()}');
    return null;
  }
}

Title extractTitle({required Map<String, dynamic> scrap}) {
  return Title(
    idThing: scrap['id_thing'],
    idLang: scrap['id_lang'],
    label: scrap['title'],
  );
}

Description extractDescription({required Map<String, dynamic> scrap}) {
  return Description(
    idThing: scrap['id_thing'],
    idLang: scrap['id_lang'],
    subtitle: scrap['subtitle'],
    description: scrap['description'],
    fullDescription: scrap['full_description'],
  );
}

Info extractInfo({required Map<String, dynamic> scrap}) {
  return Info(
    idThing: scrap['id_thing'],
    duration: scrap['duration'],
    years: scrap['years'],
    actors: scrap['actors'],
    authors: scrap['authors'],
    directors: scrap['directors'],
    countries: scrap['countries'],
    productors: scrap['productors'],
  );
}
