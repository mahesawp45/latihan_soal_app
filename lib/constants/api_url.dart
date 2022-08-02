/// Base Url
class ApiUrl {
  static String baseURL = 'https://ekskul.id/api/';
  static String apiKEY = '18be70c0-4e4d-44ff-a475-50c51ece99a0';
}

/// Endpoint User
class ApiUserUrl {
  static String users = "users";
  static String userRegistration = "users/registrasi";
  static String userUpdateProfile = "users/update";
}

/// Latihan Soal
class ApiLatihanSoal {
  static String latihanMapel = "exercise/data_course";
  static String latihanPaketSoal = "exercise/data_exercise";
  static String latihanKerjakanSoal = "/exercise/kerjakan";
  static String latihanSubmitJawaban = "/exercise/input_jawaban";
  static String latihanSkor = "/exercise/score_result";
}

class ApiBanner {
  static String banner = "event/list";
}
