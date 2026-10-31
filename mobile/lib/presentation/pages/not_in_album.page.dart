import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/generated/translations.g.dart';
import 'package:immich_mobile/presentation/widgets/timeline/timeline.widget.dart';
import 'package:immich_mobile/providers/infrastructure/timeline.provider.dart';
import 'package:immich_mobile/providers/user.provider.dart';
import 'package:immich_mobile/widgets/common/mesmerizing_sliver_app_bar.dart';

/// Lists the user's server assets that are not in any album. Selecting assets opens the
/// default bottom sheet, whose album picker adds them to an existing or new album.
@RoutePage()
class NotInAlbumPage extends StatelessWidget {
  const NotInAlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        timelineServiceProvider.overrideWith((ref) {
          final user = ref.watch(currentUserProvider);
          if (user == null) {
            throw Exception('User must be logged in to access assets not in any album');
          }

          final timelineService = ref.watch(timelineFactoryProvider).notInAlbum(user.id);
          ref.onDispose(timelineService.dispose);
          return timelineService;
        }),
      ],
      child: Timeline(appBar: MesmerizingSliverAppBar(title: context.t.not_in_any_album)),
    );
  }
}
