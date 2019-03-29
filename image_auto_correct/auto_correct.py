import cv2
import numpy as np
import statistics
from matplotlib import pyplot as plt

""" PLEASE CHANGE THE IMAGE PATH """

img = cv2.imread('imagesA2/4.jpg')
img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)

def measure_noise(img, kernel_size, variance_threshold):

    """ measure the amount of noise in an image """

    if not(img.shape[0]%kernel_size == 0 and img.shape[1]%kernel_size == 0):
        return "This window size is not possible for your image dimensions."

    np_variance = np.zeros((img.shape[0]//kernel_size, img.shape[1]//kernel_size), np.uint64)

    tmp_sum = 0
    mean = 0
    variance = 0

    for i in range(0, img.shape[0], kernel_size):
        for j in range(0, img.shape[1], kernel_size):

                tmp_sum = 0
                mean = 0
                variance = 0
                for ii in range(i, i+kernel_size):
                    for jj in range(j, j+kernel_size):
                        tmp_sum += img.item(ii, jj)
                mean = tmp_sum/(kernel_size**2)

                tmp_sum = 0
                for ii in range(i, i+kernel_size):
                    for jj in range(j, j+kernel_size):
                        tmp_sum += (img.item(ii, jj) - mean)**2
                variance = tmp_sum/(kernel_size**2)

                np_variance.itemset((i//kernel_size, j//kernel_size), variance)

    noise = 0
    for i in range(np_variance.shape[0]):
        for j in range(np_variance.shape[1]):
            if np_variance.item(i,j) > variance_threshold:
                noise+=1

    print(str(round((noise/(np_variance.shape[0]*np_variance.shape[1]))*100, 2)) + '% of the image is noisy.')
    return round((noise/(np_variance.shape[0]*np_variance.shape[1]))*100, 2)

def correct_noise(img, kernel_size):
    kernel = []
    for i in range(1, img.shape[0]-1):
        for j in range(1, img.shape[1]-1):
            kernel = []
            for ii in range(i-(kernel_size//2), i+(kernel_size//2)+1):
                for jj in range(j-(kernel_size//2), j+(kernel_size//2)+1):
                    kernel.append(img.item(ii, jj))
            img.itemset((i, j), statistics.median(kernel))

    print('noise corrected.')
    return img

def measure_blurriness(img, kernel_size, threshold):
    grad_x = cv2.Sobel(img,cv2.CV_64F,1,0,ksize=kernel_size)
    grad_y = cv2.Sobel(img,cv2.CV_64F,0,1,ksize=kernel_size)
    sobel_x = cv2.convertScaleAbs(grad_x)
    sobel_y = cv2.convertScaleAbs(grad_y)
    sobel = cv2.addWeighted(sobel_x, 0.5, sobel_y, 0.5, 0)

    print(str(round(((threshold)/sobel.var())*100, 2)) + '% of the image is blurry.')
    return round(((threshold)/sobel.var())*100, 2)

def correct_blurriness(img, kernel_size, k):
    kernel = []
    sharped = 0
    tmp = 0
    for i in range(1, img.shape[0]-1):
        for j in range(1, img.shape[1]-1):
            kernel = []
            for ii in range(i-(kernel_size//2), i+(kernel_size//2)+1):
                for jj in range(j-(kernel_size//2), j+(kernel_size//2)+1):
                    kernel.append(img.item(ii, jj))
            tmp = img.item(i, j)
            sharped = sum(kernel)/len(kernel)
            if tmp-sharped >= 0:
                sharped = tmp-sharped
            else:
                sharped = 0
            sharped = tmp + (k*sharped)
            img.itemset((i, j), sharped)

    kernel = np.array([[0,-1,0], [-1,5,-1], [0,-1,0]])
    img2 = cv2.filter2D(img, -1, kernel)

    print('blurriness corrected.')
    return img2

def measure_color_collapsing(img):
    max = 128
    min = 128
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            if (img.item(i,j) < min):
                min = img.item(i,j)
            if (img.item(i,j) > max):
                max = img.item(i,j)

    print('color collapsing in the image: ' + str(round(100 - ((max-min)/255*100), 2)) + '%.')
    return round(((max-min)/255)*100, 2)

def correct_color_collapsing(img):
    max = 128
    min = 128
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            if (img.item(i,j) < min):
                min = img.item(i,j)
            if (img.item(i,j) > max):
                max = img.item(i,j)
    if ((max - min) /255 * 100 < 70.0):
        for i in range(img.shape[0]):
            for j in range(img.shape[1]):
                img.itemset((i,j), (img.item(i,j) - min) * 255/(max - min))

    print('color collapsing corrected.')
    return img

def auto_correct(img):
    noise = measure_noise(img, 5, 1200)
    if noise > 50.0:
        img = correct_noise(img, 3)

    blur = measure_blurriness(img, 3, 50)
    if blur > 40.0:
        img = correct_blurriness(img, 3, 0.7)

    collapsing = measure_color_collapsing(img)
    if collapsing > 40.0:
        img = correct_color_collapsing(img)

    return img

corrected_image = auto_correct(img)
cv2.imshow('Corrected Image', corrected_image); cv2.waitKey(5000)

# measure noise
# print(measure_noise(img, 5, 1200))
# correct noise
# cv2.imshow('Corrected Image', correct_noise(img, 3)); cv2.waitKey(5000)
# correct noise, then re-measure
# print('old image:', measure_noise(img, 5, 1200), '\nnew image:', measure_noise(correct_noise(img, 3), 5, 1200))

# measure blurriness
# print(measure_blurriness(img, 3, 250))
# correct blurriness
# cv2.imshow('Corrected Image', correct_blurriness(img, 3, 0.5)); cv2.waitKey(5000)
# correct blurriness, then re-measure
# print('old image:', measure_blurriness(img, 3, 250), '\nnew image:', measure_blurriness(correct_blurriness(img, 3, 0.7), 3, 250))

# measure color collapsing
# print(measure_color_collapsing(img))
# correct color correct_color_collapsing
# cv2.imshow('Corrected Image', correct_color_collapsing(img)); cv2.waitKey(5000)
# correct color collapsing, then re-measure
# print('old image:', measure_color_collapsing(img), '\nnew image:', measure_color_collapsing(correct_color_collapsing(img)))
