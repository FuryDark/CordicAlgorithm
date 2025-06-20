import pandas as pd
import matplotlib.pyplot as plt

# Load the CSV file
df = pd.read_csv(r"C:\Users\jasno\Desktop\cordic_output.csv")
df.columns = df.columns.str.strip()
print(df.columns)

# Extract relevant columns
angle = df["Angle (deg)"]
sine = df["Sine"]
cosine = df["Cosine"]

# Optional: sin² + cos²
identity_error = sine**2 + cosine**2 - 1

# Plot sine and cosine
plt.figure(figsize=(10, 6))
plt.plot(angle, sine, label="Sine", color='blue')
plt.plot(angle, cosine, label="Cosine", color='red')
plt.axhline(0, color='gray', linestyle='--', linewidth=0.5)
plt.title("CORDIC Output: Sine and Cosine vs Angle")
plt.xlabel("Angle (degrees)")
plt.ylabel("Amplitude")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()

# Plot sin² + cos² - 1 to check error
plt.figure(figsize=(10, 3))
plt.plot(angle, identity_error, label="(sin² + cos²) - 1", color='purple')
plt.title("Identity Check: sin² + cos² ≈ 1")
plt.xlabel("Angle (degrees)")
plt.ylabel("Error")
plt.grid(True)
plt.tight_layout()
plt.show()