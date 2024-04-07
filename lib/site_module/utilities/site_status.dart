enum SiteStatus {
  open,
  closed,
  upcoming,
  completed,
  dropped,
}

SiteStatus? getSiteStatus(String? status) {
  switch (status) {
    case 'open':
      return SiteStatus.open;
    case 'closed':
      return SiteStatus.closed;
    case 'upcoming':
      return SiteStatus.upcoming;
    case 'completed':
      return SiteStatus.completed;
    case 'dropped':
      return SiteStatus.dropped;
    default:
      throw Exception('Invalid site status');
  }
}

// Returns the string value based on the SiteStatus
String getSiteStatusName(SiteStatus? siteOfficeStatus) {
  switch (siteOfficeStatus) {
    case SiteStatus.open:
      return "Open";

    case SiteStatus.closed:
      return "Closed";

    case SiteStatus.completed:
      return "Completed";

    case SiteStatus.upcoming:
      return "Upcoming";
    case SiteStatus.dropped:
      return "Dropped";
    default:
      throw Exception('Invalid leave status');
  }
}
