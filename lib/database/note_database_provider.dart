
final String tableNote = "note";
final String columnId = "id";
final String columnMessage = "message";
final String columnCreatedOn = "createdOn";
final String columnUpdatedOn = "updatedOn";
final String columnNotification = "notification";
final String columnNotificationTime = "notificationTime";

class Note {
  int id;
  String message;
  DateTime createdOn, updatedOn, notificationTime;
  bool notification;

  Map toMap() {
    Map map = {columnMessage: message, columnCreatedOn: createdOn, columnUpdatedOn: updatedOn, columnNotificationTime: notificationTime
                , columnNotification: notification == true ? 1 : 0};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Note() {
    this.message = "This is a Sample Note.";
    this.createdOn = new DateTime.now();
    this.updatedOn = new DateTime.now();
    this.notificationTime = new DateTime.now();
    this.notification = false;
  }

  Note.fromMap(Map map) {
    id = map[columnId];
    message = map[columnMessage];
    createdOn = map[columnCreatedOn];
    updatedOn = map[columnUpdatedOn];
    notificationTime = map[columnNotificationTime];
    notification = map[columnNotification] == 1;
  }
}
