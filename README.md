# skin-segmentation-prediction
A project to predict whether spesific R, G and B pixel values belong to human skin or not

# Table of Contents

* [Introduction](#Introduction)
* [Data Visualization](#Data_Visualization)
* [Data Preparation](#Data_Preparation) 
   * [Missing Values](#Missing_Values)
   * [Distribution of Values](#Distribution_of_Values)
   * [Duplicated Rows](#Duplicated_Rows)
* [Models](#Models) 
   * [Decision Tree Model](#Decision_Tree_Model)
   * [KNN Model](#KNN_Model)
* [CONCLUSION](#CONCLUSION)



A color image consists of 3 different colors: red, green, and blue. All other colors created by intensities of these 3 colors. The dataset contains 3 descriptive features, R, G, and B. The target feature is 0 or 1, indicates that whether the pixel belongs to a human skin or not.

# Data Visualization <a class="anchor" id="Data_Visualization"></a>

The figure above shows how the data clustered. 
![image](https://user-images.githubusercontent.com/50465232/184250516-ca666831-eb3e-47cc-833f-08efbcf75504.png)

By looking these plots, it can be said that skin values (blue) gathered around the upper center. A linear distribution is not likely to be an issue.
![image](https://user-images.githubusercontent.com/50465232/184250566-950f5d78-65e0-4654-a41f-a3420cb346d7.png)
![image](https://user-images.githubusercontent.com/50465232/184250574-116f8f65-fcf4-4380-83a5-215cc6202585.png)
![image](https://user-images.githubusercontent.com/50465232/184250583-768f5868-ca59-4c96-9e92-312e8066f443.png)

The relation between the target feature and each descriptive feature can be found out by using box plots. Density plots for each descriptive feature works the same way as box plots.

![image](https://user-images.githubusercontent.com/50465232/184250634-d085044f-d032-434f-befa-a13fa2bd1eef.png)
![image](https://user-images.githubusercontent.com/50465232/184250643-7573805d-887e-473d-8610-a58c77867fab.png)
![image](https://user-images.githubusercontent.com/50465232/184250649-0444b0b4-c86c-446a-9504-780d3ce21f73.png)

# Data Preparation <a class="anchor" id="Data_Preparation"></a>

As first step, the target feature Skin is converted into factor from integer value. Then it is checked whether dataset contains outlier descriptive feature. We can simply obtain this information by looking at the previous box plots. There is not any outlier, so the process continues checking missing values and duplicated rows. 

2.1 Missing Values <a class="anchor" id="Missing_Values"></a>

Whether the dataset contains any missing values has been investigated. For this operation, “missmap” function from Amelia library has been used.
![image](https://user-images.githubusercontent.com/50465232/184250785-f2acafd9-c201-431c-ae02-731c4fde01fb.png)
The dataset does not contain any missing values.

2.2 Duplicated Rows <a class="anchor" id="Duplicated_Rows"></a>
![image](https://user-images.githubusercontent.com/50465232/184250859-dc3da7bd-ca9b-440a-870f-98102f756bb7.png)

20.8% of rows are 1(skin) whereas 79.2% is 2(nonskin). After removing duplicated rows, there are 51444 observations left.

![image](https://user-images.githubusercontent.com/50465232/184250902-a3fc17bc-75c0-4fd2-930e-93f9730a9662.png)

28.5% of rows are 1 and 71.5% of rows are 2. There is an imbalance in the dataset.

# Models <a class="anchor" id="Models"></a>

3.1 Naive Bayes   <a class="anchor" id="Naive_Bayes "></a>

Naïve Bayes model is based on probability. The highest probability for target feature is accepted.
0.6% of the rows has been selected as train whereas other rows selected as test. 
Since numerical variables are not normally distributed, kernel has been used to increase the success of the model.


In both train and test dataset, Skin and Nonskin ratio is very close. For this reason, undersampling or oversampling methods has not been used since they drop the accuracy, recall and precision ratios. 

To train the model, “naivebayes” library has been used. 


