class MapelList {
  int? status;
  String? message;
  List<MapelData>? data;

  MapelList({this.status, this.message, this.data});

  MapelList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MapelData>[];
      json['data'].forEach((v) {
        data!.add(MapelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MapelData {
  String? courseId;
  String? majorName;
  String? courseCategory;
  String? courseName;
  String? urlCover;
  int? jumlahMateri;
  int? jumlahDone;
  int? progress;

  MapelData(
      {this.courseId,
      this.majorName,
      this.courseCategory,
      this.courseName,
      this.urlCover,
      this.jumlahMateri,
      this.jumlahDone,
      this.progress});

  MapelData.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    majorName = json['major_name'];
    courseCategory = json['course_category'];
    courseName = json['course_name'];
    urlCover = json['url_cover'];
    jumlahMateri = json['jumlah_materi'];
    jumlahDone = json['jumlah_done'];
    progress = json['progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course_id'] = courseId;
    data['major_name'] = majorName;
    data['course_category'] = courseCategory;
    data['course_name'] = courseName;
    data['url_cover'] = urlCover;
    data['jumlah_materi'] = jumlahMateri;
    data['jumlah_done'] = jumlahDone;
    data['progress'] = progress;
    return data;
  }
}
