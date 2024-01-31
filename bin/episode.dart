import 'database/table_availability.dart';
import 'global.dart';
import 'playlist_response.dart';
import 'scrap_api.dart';
import 'scrap_www.dart';
import 'subtitles.dart';
import 'database/table_cover.dart';
import 'database/table_description.dart';
import 'database/table_info.dart';
import 'database/table_link.dart';
import 'database/table_thing.dart';
import 'database/table_title.dart';
import 'validate.dart';

Future collectEpisode(
  String lang,
  PlaylistItem item,
  int idThingCollection,
) async {
  var idEpisode = item.providerId;
  if (!Validate.isEpisode(idEpisode)) {
    log.warning('UNVALID␟$idEpisode');
    return;
  }
  log.info('COLLECT␟$idEpisode');

  final idThing = await Thing.getIdOrInsert(episodeTypeId, idEpisode!);

  await Description(
    idThing: idThing,
    idLang: langtags[lang]!,
    subtitle: item.subtitle,
    description: item.description,
  ).insert();

  await Title(
    idThing: idThing,
    idLang: langtags[lang]!,
    label: item.title,
  ).insert();

  // DO NOT REPEAT for each languages (performances)
  if (lang == 'fr') {
    await Link(idParent: idThingCollection, idChild: idThing).insert();

    var api = await Api.scrap(lang, idEpisode);
    var www = await Www.scrap(lang, idEpisode);

    // Insert availability
    if (api.start != null && api.stop != null) {
      await Availability(
        idThing: idThing,
        start: DateTime.parse(api.start!),
        stop: DateTime.parse(api.stop!),
      ).insert();
    }

    await Info(
      idThing: idThing,
      duration: item.duration?.inSeconds,
      years: www.years,
      actors: www.actors,
      authors: www.authors,
      directors: www.directors,
      countries: www.countries,
      productors: www.productors,
    ).insert();

    var coverUrl = item.images?.first.url;
    if (coverUrl != null) {
      await Cover.collect(
        lang: lang,
        idThing: idThing,
        idArte: idEpisode,
        url: coverUrl,
        text: false,
      );
    }
    await extractSubtitles(idEpisode);
    await collectSubtitles(idEpisode, arteProviderId, idThing);
  }
}
