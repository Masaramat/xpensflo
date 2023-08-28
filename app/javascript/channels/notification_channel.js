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

// ...

function updateBadgeAndDropdown(notifications) {
  console.log("Loading Notifications");
  const badge = document.querySelector('.badge');
  const dropdown = document.querySelector('.notifications-dropdown'); // Change to your actual dropdown element

  // Filter notifications that are unread
  const unreadNotifications = notifications.filter(notification => !notification.read);

  const recentNotifications = unreadNotifications.reverse().slice(0, 5);


  const count = unreadNotifications.length;
  badge.textContent = count;
  badge.style.display = count > 0 ? 'block' : 'none';

  // Clear the previous dropdown content
  dropdown.innerHTML = '';

  // Display desktop notifications
  if (Notification.permission === 'granted') {
    const desktopNotification = new Notification('New Notification', {
      body: notifications[0].message,
      icon: '/notification_icon.png' // Replace with the path to your notification icon
    });

    // Add optional click event to navigate to a link when the notification is clicked
    desktopNotification.onclick = () => {
      const notification_url = '/requests/';
      // Open a URL in the source tab
      window.open(notification_url, '_self');
    
      // Close the notification
      desktopNotification.close();
    };
  }

  // Reverse the order of notifications and populate the dropdown with unread notifications
  recentNotifications.forEach(notification => {
    const notificationItem = document.createElement('div');
    // Create a link element
    const linkElement = document.createElement('a');
    linkElement.classList.add('dropdown-item');
    linkElement.href = '/requests/' + notification.request_id; // Replace with the actual URL

    // Create a container element for the icon and text
    const containerElement = document.createElement('div');
    containerElement.classList.add('notification-item-container');

    // Create an image element for the icon
    const iconElement = document.createElement('img');
    iconElement.classList.add('icon-image'); // You can add additional classes if needed
    iconElement.src = '/request_icon.png';

    // Create a span element for the notification message
    const messageElement = document.createElement('span');
    messageElement.textContent = notification.message;

    // Append the icon and text elements to the container
    containerElement.appendChild(iconElement);
    containerElement.appendChild(messageElement);

    // Append the container to the link element
    linkElement.appendChild(containerElement);

    // Append the link element to the dropdown
    dropdown.appendChild(linkElement);
    // Assuming each notification has a 'message' property  

    
  });
}

// Request permission for desktop notifications
if (Notification.permission !== 'granted') {
  Notification.requestPermission();
}



