class RecentChat {
  String name;
  String number;
  String lastMessage;
  String dateTime;
  bool isRead;
  int numberOfNewMessages;
  String id;

  RecentChat(
      {required this.name,
      required this.number,
      required this.lastMessage,
      required this.dateTime,
      required this.isRead,
      required this.numberOfNewMessages,
      required this.id});
}
