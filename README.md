# Time Progress Tracker

A Flutter Application to create Timers with a percentage indicator.
The Idea for this Application came to me while, I was doing my civil service.
It is a really simple app at this state. You can enter Time Progresses, which are made up of
a name, a start date, and a end date.
Then you can see a list of all currently active and a list of all currently inactive progresses,
including their current percentages.

## Current State of the repo.

Now the repo is mostly cleaned up.

My own model classes are located in lib/models.
The logic for converting the models to json format and saving them is in lib/persistence.
All redux logic, including store connector widgets are in lib/redux.
The Flutter UI widgets are located in lib/ui.
Other stuff is in lib/utils or directly in lib.

- [Google Play](https://play.google.com/store/apps/details?id=com.fahrecker.time_progress_calculator)


## Original Readme

### Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
