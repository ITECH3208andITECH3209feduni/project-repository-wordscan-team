# Test Cases for Book-Scanner App

This document contains a list of potential test cases for verifying the functionality of the Book-Scanner app.

## Test Case 1: Image Selection from Gallery
- **Test Description**: Verify that the user can select an image from the gallery.
- **Preconditions**: The app is running, and the device has images in the gallery.
- **Test Steps**:
  1. Tap the **Pick Image** button.
  2. Select an image from the gallery.
- **Expected Result**: The image is displayed in the app's image section.

---

## Test Case 2: Image Capture from Camera
- **Test Description**: Verify that the user can capture an image using the camera.
- **Preconditions**: The app is running, and the device has a working camera.
- **Test Steps**:
  1. Tap the **Capture Image** button.
  2. Capture an image using the device's camera.
- **Expected Result**: The captured image is displayed in the app's image section.

---

## Test Case 3: Text Recognition from Image
- **Test Description**: Verify that the app correctly scans and extracts text from the selected image.
- **Preconditions**: The app is running, and the user has selected an image with readable text.
- **Test Steps**:
  1. Select an image with text.
  2. Wait for the text recognition to complete.
- **Expected Result**: The extracted text is displayed in the scanned text section.

---

## Test Case 4: Highlighting Words from Predefined Lists
- **Test Description**: Verify that words from predefined word lists are correctly highlighted in the scanned text.
- **Preconditions**: The app has scanned text, and at least one word list is selected.
- **Test Steps**:
  1. Select a word list (e.g., "Words 1-100").
  2. View the scanned text.
- **Expected Result**: Words from the selected list are highlighted in the specified color.

---

## Test Case 5: Add Custom Word List
- **Test Description**: Verify that the user can add a custom word list and the words are highlighted in the scanned text.
- **Preconditions**: The app is running, and the user has scanned text.
- **Test Steps**:
  1. Tap the **Add Custom Word List** button.
  2. Enter custom words.
  3. Save the custom word list.
  4. View the scanned text.
- **Expected Result**: Words from the custom word list are highlighted in the specified color.

---

## Test Case 6: Handle Empty Custom Word List
- **Test Description**: Verify that the app handles an empty custom word list without errors.
- **Preconditions**: The app is running, and the user has no words in the custom word list.
- **Test Steps**:
  1. Tap the **Add Custom Word List** button.
  2. Leave the text field empty and save.
  3. Select the custom word list.
  4. View the scanned text.
- **Expected Result**: No words are highlighted, and the app does not crash.

---

## Test Case 7: Export Statistics to CSV
- **Test Description**: Verify that the app correctly exports statistics to a CSV file.
- **Preconditions**: The app has scanned text and selected word lists.
- **Test Steps**:
  1. Select word lists.
  2. Tap the **View Statistics of Scanned Text** button.
  3. Tap the **Export as CSV** button.
- **Expected Result**: The CSV file is generated and shared with the correct data for each word list.

---

## Test Case 8: Missing Word Lists
- **Test Description**: Verify that the app shows an error dialog when no word lists are selected, but the user tries to view statistics.
- **Preconditions**: The app is running with scanned text, but no word lists are selected.
- **Test Steps**:
  1. Try to view statistics without selecting any word lists.
- **Expected Result**: An error dialog is displayed asking the user to select at least one word list.

---

## Test Case 9: Text Highlighting for Overlapping Words in Lists
- **Test Description**: Verify that words appearing in multiple word lists are highlighted correctly (e.g., green).
- **Preconditions**: The app has scanned text, and multiple word lists are selected with overlapping words.
- **Test Steps**:
  1. Select multiple word lists (e.g., "Words 1-100" and "Words 101-200").
  2. View the scanned text.
- **Expected Result**: Words that appear in more than one list are highlighted in green.

---

## Test Case 10: Performance with Large Custom Word List
- **Test Description**: Verify that the app performs efficiently with a large custom word list.
- **Preconditions**: The app is running, and the user has a large custom word list.
- **Test Steps**:
  1. Add a custom word list with 500+ words.
  2. View the scanned text.
- **Expected Result**: The app remains responsive, and words from the custom word list are correctly highlighted.

---

## Test Case 11: Text Normalization (Lowercase and Punctuation Handling)
- **Test Description**: Verify that the app normalizes text properly by ignoring case and punctuation.
- **Preconditions**: The app has scanned text that includes capitalized and punctuated words.
- **Test Steps**:
  1. Select word lists.
  2. View the scanned text.
- **Expected Result**: Words are correctly highlighted regardless of their case or punctuation.

---

## Test Case 12: Error Handling for Invalid Image Format
- **Test Description**: Verify that the app handles unsupported image formats gracefully.
- **Preconditions**: The app is running, and the user attempts to select an unsupported image file format.
- **Test Steps**:
  1. Try to select an unsupported image format (e.g., TIFF).
- **Expected Result**: The app shows an error message and does not crash.

---

## Test Case 13: Word Count in Statistics
- **Test Description**: Verify that the word count statistics are accurate for selected word lists.
- **Preconditions**: The app has scanned text and selected word lists.
- **Test Steps**:
  1. Select word lists.
  2. View the statistics of scanned text.
- **Expected Result**: The word counts in the statistics are accurate and match the scanned text.

---

## Test Case 14: Share CSV File
- **Test Description**: Verify that the app successfully shares the CSV file with other applications.
- **Preconditions**: The app has exported the statistics as a CSV file.
- **Test Steps**:
  1. Tap the **Export as CSV** button.
  2. Choose an app to share the CSV file (e.g., email, Google Drive).
- **Expected Result**: The CSV file is shared with the selected app without issues.
