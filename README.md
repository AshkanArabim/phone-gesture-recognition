# Scripts used for "Phone-based CSI Hand Gesture Recognition with Lightweight Image-Classification Model"

These are all the scripts we (Ashkan Arabi and Michael Straus) wrote and used during our Summer 2023 research experience (REU) at Temple University. 

**This repo can help you if:** 
1. You are working on a project that involves detecting gestures using Wi-Fi CSI.
2. You plan to use something close to Convolutional Neural Networks for the classification task.
3. You don't mind dirty and unroganized code.

The code has its quirks that can be hard for outsiders to understand. If you have any questions, feel free to email any of us (below). 

## File Structure
### Ipynb files
The `ipynb` scripts are meant to be run on Google Colab connected to Google Drive. The `ipynb` files themselves can be placed anywhere on the drive, but all dependencies should be located in a symbolic directory called `REU`. 

`REU` has several important subdirectories:
1. `csi_data_all`: stores all dataset folders
    1. `csi_data_xx`: contains a folder for each of the gestures used in data collection
        1. `gesture`
            1. `gesture_xxx.pcap`: raw `pcap` files extracted from the smartphone. These are turned into numpy arrays using the `csiread` Python package. Take a look at our scripts, or "csiread"'s GitHub repo.
    2. `csi_numpy`: (generated automatically by `custom_model.ipynb`): contains one `.npy` file for any dataset accessed by model training scripts. These files are generated because it takes forever to load many small files from Google Drive. All contents use preprocessing v3.
    4. `csi_numpy_unchopped`: (also generated) contains data that is not trimmed to 20 packets (hence, has 50 packets per sample).
    5. `csi_numpy_vX`: (generated) same as above, but data is preprocessed using vX method. (X is a number starting from 4)
    6. `csi_numpy_vX_unchopped`: You see the pattern...
2. `paper_charts`: stores model outputs and confusion matrices after running the `test_impact_factors.ipynb` script. Additionally, it'll contain bar charts for comparing different scenarios after running `generate_barcharts.ipynb`.
3. The rest isn't wired to any script. They just contain other scripts / files that we used. Feel free to move anything you don't like.

### Bash scripts
For the Bash scripts, they are intended to either run on a linux machine (or VM), or on a rooted android smartphone.

## Datasets
Most of the data we used for testing our models can be found [here](https://www.kaggle.com/datasets/ashkanarabi/nexus-5-csi-hand-gestures).

## Final Words
We would be very surprised if anyone starts using these scripts and gets them to work on their own. If anything is wrong **please reach out!** 

## Live Script
In order to run the live script, follow instructions in the "Polished Nexus5 Setup Tips" document.

Feel free to contact Ashkan (ashkan.arabim@gmail.com) or Michael (mjstraus2304@gmail.com) with any questions.
