class VidModel {
  const VidModel({required this.path, required this.length});

  final String path;
  final Duration length;
}

const List<VidModel> videoData = [
  VidModel(path: 'lib/assets/clip_1.mp4', length: Duration(seconds: 12)),
  VidModel(path: 'lib/assets/clip_2.mp4', length: Duration(seconds: 9)),
  VidModel(path: 'lib/assets/clip_3.mp4', length: Duration(seconds: 13)),
];
