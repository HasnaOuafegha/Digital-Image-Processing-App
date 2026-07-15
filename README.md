# 🖼️ MATLAB Image Processing Application

A complete image processing application developed using **MATLAB App Designer**. The application provides an interactive graphical user interface (GUI) for image analysis, enhancement, edge detection, and segmentation.

## 📖 Overview

This project implements several fundamental image processing techniques through an intuitive MATLAB application. Users can load an image, apply different transformations, visualize histograms, analyze image statistics, detect edges, and perform image segmentation in real time.

The project combines theoretical image processing concepts with practical implementation using MATLAB and App Designer.

---

## ✨ Features

### 📊 Image Analysis

- RGB to Grayscale Conversion
- Histogram Visualization
- Mean Intensity Calculation
- Standard Deviation Calculation
- Minimum Pixel Value
- Maximum Pixel Value

### 🔄 Nonlinear Transformations

- Gamma Correction
- Logarithmic Transformation
- Exponential Transformation

### 🎨 Contrast Enhancement

- Contrast Stretching
- Histogram Equalization

### 🔍 Edge Detection

- Sobel Edge Detection

### 🧩 Image Segmentation

- Otsu Automatic Thresholding
- Manual Thresholding

### 📈 Visualization

- Original Image
- Processed Image
- Original Histogram
- Processed Histogram

---

## 🏗️ Project Structure

```text
MATLAB-Image-Processing-GUI/
│
├── run_app.m
│   └── Application launcher
│
├── TraitementImage.m
│   └── MATLAB App Designer graphical interface
│
├── traitement_complet.m
│   └── Image processing algorithms implementation
│
├── images/
│   ├── fleur.png
│   └── Other sample images
│
├── screenshots/
│   ├── histogram_equalization.png
│   ├── sobel_detection.png
│   └── otsu_segmentation.png
│
└── README.md
```

---

## ⚙️ Implemented Algorithms

### Statistical Analysis

The application computes:

- Mean Intensity
- Standard Deviation
- Minimum Pixel Value
- Maximum Pixel Value

### Gamma Correction

Adjusts image brightness according to a user-defined gamma value.

### Logarithmic Transformation

Enhances dark image regions while compressing bright intensity values.

### Exponential Transformation

Highlights bright regions and modifies image contrast.

### Contrast Stretching

Expands the dynamic range of image intensities to improve visibility.

### Histogram Equalization

Improves overall image contrast by redistributing pixel intensities.

### Sobel Edge Detection

Detects image contours using horizontal and vertical gradient operators.

### Otsu Segmentation

Automatically computes the optimal threshold for image segmentation.

### Manual Thresholding

Allows users to choose a custom threshold value for segmentation.

---

## 🖥️ Graphical User Interface

The application interface is divided into two sections:

### Left Panel

- Load Image Button
- Transformation Selection Menu
- Gamma Parameter Input
- Threshold Parameter Input
- Apply Processing Button
- Statistical Information Display

### Right Panel

- Original Image Display
- Processed Image Display
- Original Histogram
- Result Histogram

### Main Interface

<img width="977" height="394" alt="image" src="https://github.com/user-attachments/assets/b3d9aba6-01c2-4816-babb-54d8a8e0b03b" />


---

## 🚀 Getting Started

### Requirements

- MATLAB R2021a or later
- Image Processing Toolbox (recommended)

### Clone the Repository

```bash
git clone https://github.com/HasnaOuafegha/MATLAB-Image-Processing-GUI.git
```

Open MATLAB and navigate to the project directory.

---

## ▶️ Running the Application

### Option 1: Using the Launcher Script

```matlab
run_app
```

### Option 2: Direct Execution

```matlab
app = TraitementImage();
```

---

## 📸 Screenshots

### Histogram Equalization

<img width="836" height="415" alt="histogram_equalization" src="https://github.com/user-attachments/assets/6b7917fd-aa54-471a-b3fa-75572be677dc" />


### Sobel Edge Detection

<img width="836" height="413" alt="sobel_detection" src="https://github.com/user-attachments/assets/9caeaf78-973c-4579-b806-6dc73546f3aa" />


### Otsu Segmentation

<img width="838" height="410" alt="otsu_segmentation" src="https://github.com/user-attachments/assets/9bb15086-8029-491d-8aa6-4742c8fd11ac" />


---

## 📂 Sample Images

The **images/** folder contains sample images used for testing and demonstrating the implemented image processing algorithms.

Example:

```text
images/
├── fleur.png
└── other test images
```

Users can also load their own images through the graphical interface.

---

## 🎓 Educational Objectives

This project demonstrates practical implementation of:

- Digital Image Processing
- Histogram Analysis
- Image Enhancement Techniques
- Contrast Improvement
- Edge Detection
- Image Segmentation
- MATLAB App Designer Development

---

## 🛠️ Technologies Used

- MATLAB
- MATLAB App Designer
- Image Processing Toolbox

---

## 👩‍💻 Author

**Hasna Ouafegha**

Master's Student in Data Analytics and Artificial Intelligence

Faculty of Sciences Ibn Zohr – Agadir, Morocco

---

## 📄 License

This project is released for educational and academic purposes.

Feel free to use, modify, and improve the project for learning, research, and non-commercial applications.
