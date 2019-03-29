import cv2
import numpy as np

sherlock = cv2.imread('imagesA1/Q2I1.jpg')
frame = cv2.imread('imagesA1/Q3I1.jpg')
rows,cols,ch = sherlock.shape

resized_sherlock = cv2.resize(sherlock, (500, 410), interpolation=cv2.INTER_AREA)

pts1 = np.float32([[0,0], [500,0], [0,410], [500,410]])
pts2 = np.float32([[160,30], [470,67], [157,390], [465,355]])

affine_matrix = cv2.getPerspectiveTransform(pts1, pts2)

perspective = cv2.warpPerspective(resized_sherlock, affine_matrix, (frame.shape[1], frame.shape[0]))

for i in range(frame.shape[0]):
    for j in range(frame.shape[1]):
        for c in range(frame.shape[2]):
            orgpx = frame.item(i, j, c)
            modpx = perspective.item(i, j, c)
            pxval = modpx if modpx > 0 else orgpx
            frame.itemset((i, j, c), pxval)

cv2.imshow('Sherlock in The Frame', frame)
cv2.waitKey(5000)
