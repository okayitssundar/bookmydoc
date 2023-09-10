class Doctor{
  String userName;
  String uid;
  int age;
  String role="Doctor";
  List specialisedAt;
  String hospitalName;
  String avatar="https://previews.123rf.com/images/indomercy/indomercy1501/indomercy150100019/35500150-doctor-cartoon-illustration.jpg";
  bool webcamEnabled=false;
  bool gpsEnabled=false;
  bool flipDetectionEnabled=false;
  bool shakeDetectionEnabled=false;
  bool rfidEnabled=false;
  bool isDoctorAvailable=false;
  Doctor({
    required this.uid,
    required this.userName,
    required this.age,
    required this.specialisedAt,
    required this.webcamEnabled,
    required this.gpsEnabled,
    required this.avatar,
    required this.hospitalName,
    required this.flipDetectionEnabled,
    required this.shakeDetectionEnabled,
    required this.rfidEnabled,
    required this.isDoctorAvailable,
});
}

class AppointmentBooking {
  String bookingId;
  String doctorId;
  String patientId;
  DateTime appointmentTime;
  bool confirmed;

  AppointmentBooking({
    required this.bookingId,
    required this.doctorId,
    required this.patientId,
    required this.appointmentTime,
    this.confirmed = false,
  });
}

class Patient {
  String uid;
  String userName;
  String? avatar;
  int age;
  List<AppointmentBooking>? appointments=[];
  // Add any other patient-specific details here

  Patient({
    required this.uid,
    required this.userName,
    required this.age,
    this.appointments,
    this.avatar,
    // Initialize other fields here
  });
}
