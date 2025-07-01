# Early-Skin-Cancer-Detection
A SQL-based project analyzing patient information, environmental conditions and lesion characteristics to uncover key patterns linked to various types of skin cancer. The insights derived aim to support early detection and enable faster, more informed medical interventions.

## Problem Statement
Skin cancer detection is often delayed due to misdiagnosis and limited understanding of contributing factors such as patients demographics, environemntal risk factors, and lesion characteristics. Early detection will enable quicker and effective treatment and increase survival rates.

## Project Objectives
- Join clinical and lesion data for effective analysis.
- Identify environmental and demographic risk factors that correlate with specific skin lesions.
- Analyze lesion characteristics to find patterns that indicate cancerous vs benign lesions.
- Enhance dermatological research by providing a well structured dataset for studying disease patterns and training AI models.

## Methods
- Tables containing patients information and lesion characteristics were imported into the SQL environment.
- Data check was done to ensure data quality before diving into the analysis.
- Queries were written to answer preliminary questions about the datset.
- The six lesion types from the datset were categorized into benign (non-cancerous) and malignant (cancerous) lesion types.
- All analysis was done based on the above 2 categories.

![image](https://github.com/user-attachments/assets/f519df5d-ffb5-43a2-8afa-31277f9be69d)

## Entity Relationship Diagram
This shows the relationship between the tables used for the analysis.

![image](https://github.com/user-attachments/assets/705379bb-4a18-41c1-85fa-0f7a178eeea7)

## Results and Insights
Some of the major results and insights will be presented below.
- Age is a major risk factor. Malignancy increase with age as older patients had a higher percentage of malignant lesions. Age-based screening intensity should be done with priority given to older people.
![image](https://github.com/user-attachments/assets/dc387478-e01b-435a-a3a1-47cf3084fe3c)

- Even though smokers and drinkers are minority, they show alarmingly high malignancy rates with 95% drinkers and 97% smokers having malignant lesions. Ptients who both drink and smoke had a 100% malignancy rate.
- 
![image](https://github.com/user-attachments/assets/9a74b5ea-3783-4219-8272-71056ed063b8)

- Malignant lesions were larger in size (using a diameter of 5.89mm). Patients with large lesions should be priotorized for screening as a large lesion diameter could be indicative of a cancerous lesion. Based on gender, females were also observed to have a higher proportion of large lesions compared to males.
- 
![image](https://github.com/user-attachments/assets/8611a43b-df7b-445a-b261-96a8af64ab8a)

- Evaluation of a symptom score table using the lesion symptoms such as itching, bleeding etc. showed a higher malignancy rate as the number of symptoms increased.  However, not having any symptom doesn't rule out the chances of having skin cancer as 71% of cases with zero(0) symptos weer malignant.
This symptom scoring table supports objective triage by quantifying symptom severity, while also highlighting that asymptomatic lesions can still be malignant

![image](https://github.com/user-attachments/assets/bfa6c5b0-54fe-44ba-b23e-cec1220da1fe)

- Patients with family history of general cancer had a 92% chance of developing malignant skin lesions while patients with previous skin cancer history had a 93% malignancy rate. patients with both factors showed a malignancy rate of 95%. This shows a strong correlation and both factors should be considered as strong predictors of malignancy.
- 
![image](https://github.com/user-attachments/assets/0d4d43b4-e90e-4a7f-a3fd-36ff78f9adb5)

- Analysis of the fitzpatrick sacle showed that lighter skin tones had a higher percentage of malignant lesions. This supports research based studies indicating that ligher skin types lack the melanin protection that helps absorb harmful UV radiation from exposure to sunlight.
- 
![image](https://github.com/user-attachments/assets/c4edb193-25d1-4165-9a1f-9bc6e01c6b4e)
![image](https://github.com/user-attachments/assets/1e88fdb4-ded8-4b3f-b7aa-52665b88b3c9)

- Finally, the top 10 profile patients with combination of risk factors most likely to have malignant lesions was produced.
- 
![image](https://github.com/user-attachments/assets/6753f042-615a-4db1-ac0a-4640f66f6d78)

## CONCLUSION
This project demonstrates the power of SQL-driven data analysis in uncovering critical patterns that support early skin cancer detection. By integrating patient demographics, lifestyle factors, lesion characteristics and skin type data, I was able to identify high risk groups and predictive markers of malignancy. These insights not only validate known clinical patterns but also contribute to data-driven strategies that can assist in triage, diagnosis, and targeted public health interventions. 

## FUTURE WORK
- Using python and machine learning to produce a predictive model using features like age, lesion sizes and symptoms, skintype and lifestyle factors to predict skin cancer.






