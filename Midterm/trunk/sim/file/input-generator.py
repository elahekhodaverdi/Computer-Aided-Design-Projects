import random
import numpy as np

import matplotlib.pyplot as plt
from PIL import Image

def calc_filter(img, filter, i, j):
    s = 0
    for i1 in range(4):
        for j1 in range(4):
            s += img[i+i1][j+j1] * filter[i1][j1]
    return s

def convert_to_hex_string(n):
    digits = "0123456789abcdef"
    s = ""
    for i in range(2):
        s = digits[n % 16] + s
        n //= 16
    return s

def gen_random_filter():
    filter = [[0 for i in range(4)] for j in range(4)]
    for i in range(4):
        for j in range(4):
            filter[i][j] = random.randint(-10, 10)
    return filter


image = Image.open("cat.jpg")

image = image.resize((16, 16))
image = image.convert("L")
img = np.array(image).tolist()
#print(img)

#image.show()

INPUT_FILE = "input.dat"
OUTPUT_FILE = "desired-output.dat"
input_file = open(INPUT_FILE, "w")

x = 4
y = 0
z = 68
print(convert_to_hex_string(x), file=input_file)
print(convert_to_hex_string(y), file=input_file)
print(convert_to_hex_string(z), file=input_file)

# img = [[0 for i in range(16)] for j in range(16)]
# for i in range(16):
#     for j in range(16):
#         img[i][j] = random.randint(1, 10)

s = 0
for i in range(64):
    for j in range(4):
        print(convert_to_hex_string(img[s // 16][s % 16]), end=" ", file=input_file)
        s += 1
    print(file=input_file)
        
    
identity = [[0, 0, 0, 0],
 [0, 1, 0, 0],
 [0, 0, 1, 0],
 [0, 0, 0, 0]]

emboss = [[-2, -1, 0, 0],
 [-1, 1, 1, 0],
 [0, 1, 1, 1],
 [0, 0, 1, 2]]

edge = [[0, 1, 0, 0],
 [1, -4, 1, 0],
 [0, 1, 0, 0],
 [0, 0, 0, 0]]



filter = edge
    
for i in range(4):
    for j in range(4):
        print(convert_to_hex_string(filter[i][j]), end=" ", file=input_file)
    print(file=input_file)

input_file.close()

output_file = open(OUTPUT_FILE, "w")

filtered_img = [[0 for i in range(13)] for j in range(13)]

for i in range(13):
    for j in range(13):
        filtered_img[i][j] = calc_filter(img, filter, i, j)

s = 0
for i in range(42):
    for j in range(4):
        print(convert_to_hex_string(filtered_img[s // 13][s % 13]), end=" ", file=output_file)
        s += 1
    print(file=output_file)

print(convert_to_hex_string(filtered_img[12][12]), file=output_file)

fig, axs = plt.subplots(1, 2)

axs[0].imshow(img, cmap='gray')
axs[0].axis('off')
axs[0].set_title('original')

axs[1].imshow(filtered_img, cmap='gray')
axs[1].axis('off')
axs[1].set_title('filtered')

plt.tight_layout()

plt.show()
