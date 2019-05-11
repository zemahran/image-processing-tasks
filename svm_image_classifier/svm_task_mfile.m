clear;
% Read training images
data = imageDatastore('./svm_data/TrainImages','IncludeSubfolders',true,'LabelSource','foldernames');
%%
% Display label counts
tbl = countEachLabel(data)
%%
% Split and train images
[trainingSet, validationSet] = splitEachLabel(data, 0.7, 'randomize');
bag = bagOfFeatures(trainingSet, 'Verbose', true);
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
%%
% Create confusion matrix
confMatrix = evaluate(categoryClassifier, validationSet)
%%
% Predict on test images
img = imread('./svm_data/TestImages/Test1.jpg');
figure; imshow(img)

car1 = imcrop(img,[132 100 210 155]);
figure; imshow(car1);
predict_class(categoryClassifier, car1)

car2 = imcrop(img,[295 240 200 130]);
figure; imshow(car2);
predict_class(categoryClassifier, car2)

car3 = imcrop(img,[315 145 240 145]);
figure; imshow(car3);
predict_class(categoryClassifier, car3)

other1 = imcrop(img,[5 400 100 100]);
figure; imshow(other1);
predict_class(categoryClassifier, other1)

other2 = imcrop(img,[512 60 100 100]);
figure; imshow(other2);
predict_class(categoryClassifier, other2)
%%
function predict_class(classifier, img)

[labelIdx, ~] = predict(classifier, img);
classifier.Labels(labelIdx)

end