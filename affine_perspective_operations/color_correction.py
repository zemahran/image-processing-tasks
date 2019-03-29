import cv2
import numpy as np

img1 = cv2.imread('imagesA1/Q1I1.png')
batman = cv2.imread('imagesA1/Q1I2.jpg')

inc = 5
tmp = 0
for i in range(img1.shape[0]):
    inc = inc - 0.00446
    for j in range(img1.shape[1]):
        for c in range(img1.shape[2]):
            pixel = img1.item(i, j, c)
            tmp = pixel*(1+inc) if pixel*(1+inc) < 255 else 255
            img1.itemset((i, j, c), tmp)

flipped_batman = cv2.flip(batman, 1)
padded_batman = cv2.copyMakeBorder(flipped_batman, 0, 0, 500, 0, cv2.BORDER_CONSTANT,value=0)
resized_batman = cv2.resize(padded_batman, (1121, 788), interpolation=cv2.INTER_AREA)

result = cv2.addWeighted(img1, 0.6, resized_batman, 0.4, 0)

cv2.imshow('Batman', result)
cv2.waitKey(0)
