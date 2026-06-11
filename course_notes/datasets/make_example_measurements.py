import pandas as pd
import numpy as np

N_measurements = 12

x = np.arange(1, N_measurements + 1)
m1 = np.arange(1, N_measurements + 1)
m2 = np.arange(N_measurements + 1, 2 * N_measurements + 1)
m3 = np.arange(2 * N_measurements + 1, 3 * N_measurements + 1)

df = pd.DataFrame(data={
    "conc": x,
    "m1": m1,
    "m2": m2,
    "m3": m3,
})


df.to_excel("example_measurements.xlsx", index=False)

print(df)

# print(df.mean(axis=1))