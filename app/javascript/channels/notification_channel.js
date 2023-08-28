import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    updateBadgeAndDropdown(data.notifications);
  }
});

function updateBadgeAndDropdown(notifications) {
  console.log("Loading Notifications");
  const badge = document.querySelector('.badge');
  const dropdown = document.querySelector('.notifications-dropdown'); // Change to your actual dropdown element

  // Filter notifications that are unread
  const unreadNotifications = notifications.filter(notification => !notification.read);

  console.log(notifications);

  const count = unreadNotifications.length;
  badge.textContent = count;
  badge.style.display = count > 0 ? 'block' : 'none';

  // Clear the previous dropdown content
  dropdown.innerHTML = '';

  // Reverse the order of notifications and populate the dropdown with unread notifications
  unreadNotifications.reverse().forEach(notification => {
    const notificationItem = document.createElement('div');
    notificationItem.classList.add('notification-item');
    notificationItem.textContent = notification.message; // Assuming each notification has a 'message' property

    dropdown.appendChild(notificationItem);
  });
}


