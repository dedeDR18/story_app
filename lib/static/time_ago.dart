String timeAgo(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 8) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inSeconds >= 1) {
    return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago';
  } else {
    return 'just now';
  }
}