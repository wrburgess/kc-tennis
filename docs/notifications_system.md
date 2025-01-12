# Notification System

## Description

## Models

* NotificationSubscription
* NotificationTopic
* NotificationLog


### NotificationSubscription

* references: user
* references: notification_topic
* method: database, email, sms

### NotificationTopic

* name
* resource
* action
* description
