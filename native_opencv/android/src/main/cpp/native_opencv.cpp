#include <opencv2/opencv.hpp>
#include <android/log.h>
using namespace cv;
using namespace std;

// Avoiding name mangling
extern "C"
{
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    const char *
    version()
    {
        __android_log_print(ANDROID_LOG_VERBOSE, "Native OpenCV", "Dart ffi is setup");
        return CV_VERSION;
    }

    __attribute__((visibility("default"))) __attribute__((used)) void resize(char *pathIn, char *pathOut, int width, int height)
    {
        Mat src = imread(pathIn);
        Mat dst;
        cv::resize(src, dst, Size(width, height));
        imwrite(pathOut, dst);
    }

    __attribute__((visibility("default"))) __attribute__((used)) void rectangle(char *pathIn, char *pathOut, int x, int y, int width, int height, int c0 = 0, int c1 = 0, int c2 = 255, int thickness = 1, int lineType = 8, int shift = 0)
    {
        Mat src = imread(pathIn);
        Mat dst;
        cv::rectangle(src, Point(x, y), Point(x + width, y + height), Scalar(c0, c1, c2), thickness, lineType, shift);
        imwrite(pathOut, src);
    }

    __attribute__((visibility("default"))) __attribute__((used)) void faceDetection(char *pathIn, char *pathOut, char *pathCascade)
    {
        Mat src = imread(pathIn);
        Mat dst;
        cvtColor(src, dst, COLOR_BGR2GRAY);
        equalizeHist(dst, dst);
        CascadeClassifier face_cascade;
        face_cascade.load(pathCascade);
        vector<Rect> faces;
        face_cascade.detectMultiScale(dst, faces, 1.1, 2, 0 | CASCADE_SCALE_IMAGE, Size(30, 30));
        for (size_t i = 0; i < faces.size(); i++)
        {
            Point center(faces[i].x + faces[i].width / 2, faces[i].y + faces[i].height / 2);
            ellipse(src, center, Size(faces[i].width / 2, faces[i].height / 2), 0, 0, 360, Scalar(255, 0, 255), 4, 8, 0);
        }
        imwrite(pathOut, src);
    }

    __attribute__((visibility("default"))) __attribute__((used)) int templateMatching(char *pathIn, char *pathOut, char *pathTemplate, int method = TM_CCORR_NORMED, double threshold = 0.9)
    {
        Mat src = imread(pathIn);
        Mat templ = imread(pathTemplate);
        Mat img_display;
        Mat result;

        if (templ.rows > src.rows || templ.cols > src.cols)
        {
            std::cout << ("Mat template must be smaller than matInput");
            return 0;
        }

        src.copyTo(img_display);

        int result_cols = src.cols - templ.cols + 1;
        int result_rows = src.rows - templ.rows + 1;
        result.create(result_rows, result_cols, CV_32FC1);

        matchTemplate(src, templ, result, method);
        cv::threshold(result, result, threshold, 1, cv::THRESH_TOZERO);

        int count = 0;
        double minVal;
        double maxVal;

        while (true)
        {
            Point minLoc;
            Point maxLoc;

            cv::minMaxLoc(result, &minVal, &maxVal, &minLoc, &maxLoc);
            if (maxVal > threshold)
            {
                cv::rectangle(img_display, maxLoc, Point(maxLoc.x + templ.cols, maxLoc.y + templ.rows), Scalar(0, 255, 0), 2, 8, 0);
                cv::floodFill(result, maxLoc, cv::Scalar(0), 0, cv::Scalar(.1), cv::Scalar(1.));
                count++;
            }
            else
            {
                break;
            }
        }

        imwrite(pathOut, img_display);
        return count;
    }
}
