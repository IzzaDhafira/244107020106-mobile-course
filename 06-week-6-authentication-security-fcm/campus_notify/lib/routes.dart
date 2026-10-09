class Routes {
  static const String login = '/login';
  static const String home = '/';
  static const String announcementDetail = '/pengumuman/:id';

  static String announcementDetailPath(String id) => '/pengumuman/$id';
}

String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route'] ?? '/';
  return route.startsWith('/') ? route : '/$route';
}