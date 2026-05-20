import pandas as pd

df1 = pd.read_csv('abs_data_1.csv', delimiter="\t")
df2 = pd.read_csv('abs_data_2.csv')

keys = {
        'Wavelength': "wavelength_nm", 
        'Chlorophyll-a': "chlorophyll-a", 
        'Chlorophyll-b': "chlorophyll-b", 
        'Fucoxanthin': "fucoxanthin",
        'Prasinoxanthin': "prasinoxanthin",
        }

new_data = {}

for key in keys.keys():
    if key in df1.columns:
        new_data[keys[key]] = df1[key]
    elif key in df2.columns:
        new_data[keys[key]] = df2[key]
    else:
        print(f"Key {key} not found in either dataset.")

new_df = pd.DataFrame(new_data)

for column in new_df.keys():
    if column not in ['wavelength_nm']:
        new_df[column] = new_df[column].clip(lower=0)


new_df.to_csv('curated_abs_dataset.csv', index=False)

# Full combined
full_df = pd.merge(df1, df2, on='Wavelength', how='outer')
full_df.to_csv('full_combined_abs_dataset.csv', index=False)






