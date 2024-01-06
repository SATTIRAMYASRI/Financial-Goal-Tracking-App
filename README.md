# Financial Goal Tracking App

This Flutter application helps users track their financial goals, visualize their progress, and manage contributions towards their goals. It leverages Firebase Firestore for real-time data synchronization and storage.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Firebase Setup](#firebase-setup)
- [Technical Focus](#technical-focus)
- [Running the Application](#running-the-application)
- [Folder Structure](#folder-structure)
- [Screenshots](#screenshots)
- [Video Demonstration](#video-demonstration)

## Introduction

The Financial Goal Tracking app is designed to assist users in managing and monitoring their financial objectives. It provides an intuitive interface to view goal details, track progress, and manage contributions. The app uses Flutter for the front-end and Firebase Firestore for backend data storage.

## Features

### Goal Progress Visualization:

- Design and implement a visual element (e.g., a circular progress bar or a filled chart) that shows the user's current savings as a percentage of the target amount for a specific financial goal (like "Buy a dream house").
- The progress indicator should animate to its current state when the screen loads.

### Goal Details:

- Show detailed information about the goal, including the total amount saved, the target amount, and the expected date to reach the goal.
- Provide insights or suggestions on how to meet the goal faster (e.g., save an additional $X per month), calculated based on the current progress.

### Contribution History:

- Display a list or a summary of recent contributions towards the goal, including dates and amounts.

## Firebase Setup

### Firestore Database Structure:

- **Collection:** `user`
  - **Document:** `userID`
    - **Collection:** `Goals`
      - **Document:** `goalID`
        - **Fields:**
          - `id`: Goal ID
          - `title`: Title of the goal
          - `targetAmount`: Target amount for the goal
          - `savedAmount`: Amount saved for the goal
          - `date`: Expected completion date
          - `contributions`: List of contributions towards the goal

### Firestore Security Rules:

- Rules should be set up to restrict access to authorized users.

## Technical Focus

- Utilized Firebase Firestore for real-time data synchronization.
- Implemented UI state management to reflect changes in data.
- Conducted data-driven calculations to update UI elements dynamically.

## Running the Application

### Flutter Setup:

Ensure Flutter SDK is installed. [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

### Video Demonstration:

watch Vedio Of App.
 [Video Link](https://drive.google.com/file/d/11JxX8TCWy1KW0hiILx-mE-PjY95K3yrd/view?usp=drive_link)


### Clone the Repository:

```bash
git clone https://github.com/SATTIRAMYASRI/Financial-Goal-Tracking-App

## Running the Application

To run the application, follow these steps:

1. **Navigate to the Project Folder:** Open a terminal and go to your project directory.

2. **Execute the Following Commands:**

   ```bash
   flutter pub get
   flutter run


