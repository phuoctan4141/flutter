#include <iostream>
#include <android/log.h>

#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

using namespace cv;
using namespace std;

// Avoiding name mangling
// Attributes to prevent 'unused' function from being removed and to make it visible to the linker
#define ATTRIBUTES __attribute__((visibility("default"))) __attribute__((used))

#ifdef __cplusplus
extern "C"
{
#endif

    ATTRIBUTES
    const char *version()
    {
        __android_log_print(ANDROID_LOG_VERBOSE, "Native OpenCV:", "Dart ffi is setup");
        return CV_VERSION;
    }

    ATTRIBUTES
    void casCadeDetect(char *imgPath, char *cascadePath, char *resultPath)
    {
        Mat img = imread(imgPath, IMREAD_COLOR);
        Mat gray;
        cvtColor(img, gray, COLOR_BGR2GRAY);
        equalizeHist(gray, gray);

        CascadeClassifier cascade;
        cascade.load(cascadePath);

        vector<Rect> faces;
        cascade.detectMultiScale(gray, faces, 1.1, 2, 0 | CASCADE_SCALE_IMAGE, Size(30, 30));

        for (size_t i = 0; i < faces.size(); i++)
        {
            Point center(faces[i].x + faces[i].width / 2, faces[i].y + faces[i].height / 2);
            ellipse(img, center, Size(faces[i].width / 2, faces[i].height / 2), 0, 0, 360, Scalar(255, 0, 255), 4, 8, 0);
        }

        imwrite(resultPath, img);
    }

    ATTRIBUTES
    int templateMatching(char *imgPath, char *tempPath, char *resultPath)
    {
        int count = 0;
        Mat img = imread(imgPath, IMREAD_COLOR);
        Mat temp = imread(tempPath, IMREAD_COLOR);

        if (temp.rows > img.rows || temp.cols > img.cols)
        {
            __android_log_print(ANDROID_LOG_VERBOSE, "Native OpenCV:", "Template is larger than image");
            return 0;
        }

        Mat result;

        int result_cols = img.cols - temp.cols + 1;
        int result_rows = img.rows - temp.rows + 1;

        result.create(result_rows, result_cols, CV_32FC1);

        matchTemplate(img, temp, result, TM_CCORR_NORMED);
        // normalize(result, result, 0, 1, NORM_MINMAX, -1, Mat());
        threshold(result, result, 0.9, 1., THRESH_TOZERO);

        double minVal, maxVal;

        for (;;)
        {
            Point minLoc, maxLoc, matchLoc;
            minMaxLoc(result, &minVal, &maxVal, &minLoc, &maxLoc, Mat());

            if (maxVal > 0.9)
            {
                matchLoc = maxLoc;
                rectangle(img, matchLoc, Point(matchLoc.x + temp.cols, matchLoc.y + temp.rows), Scalar(0, 255, 0), 2, 8, 0);
                floodFill(result, matchLoc, Scalar(0), 0, Scalar(.1), Scalar(1.));
                count++;
            }
            else
            {
                break;
            }
        }

        imwrite(resultPath, img);
        return count;
    }

#ifdef __cplusplus
}
#endif