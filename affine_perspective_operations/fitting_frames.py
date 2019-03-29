import cv2
import numpy as np

sherlock = cv2.imread('imagesA1/Q2I1.jpg')
wall = cv2.imread('imagesA1/Q2I2.jpg')
pic = cv2.imread('imagesA1/Q2I3.jpg')

# fitting sherlock on the wall

resized_sherlock = cv2.resize(sherlock, (91, 140), interpolation=cv2.INTER_AREA)
wall[377:517, 1218:1309] = resized_sherlock  # 140 * 91

# fitting sherlock in the pic

rows = pic.shape[0]
cols = pic.shape[1]
blank_img = np.zeros((rows, cols, 3), np.uint8)

padded_sherlock = cv2.copyMakeBorder(sherlock, 40, 40, 40, 40, cv2.BORDER_CONSTANT,value=0)
resized_sherlock2 = cv2.resize(padded_sherlock, (410, 500), interpolation=cv2.INTER_AREA) # 500 * 410
sherlock_rows = resized_sherlock2.shape[0]
sherlock_cols = resized_sherlock2.shape[1]
affine_matrix = cv2.getRotationMatrix2D((int(sherlock_cols/2), int(sherlock_rows/2)), -6, 1)
rotated_sherlock = cv2.warpAffine(resized_sherlock2, affine_matrix, (sherlock_cols, sherlock_rows))

blank_img[80:580, 310:720] = rotated_sherlock

for i in range(pic.shape[0]):
    for j in range(pic.shape[1]):
        for c in range(pic.shape[2]):
            orgpx = pic.item(i, j, c)
            modpx = blank_img.item(i, j, c)
            pxval = modpx if modpx > 0 else orgpx
            pic.itemset((i, j, c), pxval)

cv2.imshow('Sherlock on The Wall', wall)
cv2.imshow('Sherlock in The Picture', pic)
cv2.waitKey(10000)
