# An End-to-End Active Learning Framework for Limited Labelled Hyperspectral Image Classification

Authors: Ali Can Karaca, Gokhan BilginPublished in: International Journal of Remote SensingDOI: 10.1080/01431161.2025.2467294

📌 Overview

This repository contains the implementation of our paper:

An end-to-end active learning framework for limited labelled hyperspectral image classification

Hyperspectral image (HSI) classification is challenging due to high dimensionality, spectral variability, and limited labeled samples. Our proposed framework integrates:

Dimensionality Reduction (DR) to handle high-dimensional data,

Domain Transform Filter (DtF) to enhance feature extraction,

Probabilistic Spatial-Aware Collaborative Representation (PSACR) Classifier for improved classification,

MMU+CLSW Clustering-Based Active Learning Sampling Strategy to select informative samples effectively.

Experimental results on Indian Pines, Pavia University, and Salinas datasets show that our approach achieves superior classification accuracy with minimal labeled data.

📂 Repository Structure

├── data/                 # Dataset folder \n
├── functions/            # Function codes of the proposed method \n
├── main_E2EAL.m          # Main script to run demo in MATLAB (Tested on MATLAB 2023) \n
├── README.md             # This file \n

🔗 Citation

If you find this repository useful, please cite our paper:

@article{E2E_ActiveLearning,
  author = {Ali Can Karaca and Gokhan Bilgin},
  title = {An end-to-end active learning framework for limited labelled hyperspectral image classification},
  journal = {International Journal of Remote Sensing},
  volume = {0},
  number = {0},
  pages = {1--28},
  year = {2025},
  publisher = {Taylor \& Francis},
  doi = {10.1080/01431161.2025.2467294},
  URL = {https://doi.org/10.1080/01431161.2025.2467294}
}

📬 Contact

For any questions or discussions, please feel free to open an issue or contact us via email.

⭐ If you find this work useful, please give the repository a star!
