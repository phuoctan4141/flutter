# Backed Salmon

A Backed Salmon Flutter project.
This project only runs on Android.

[BACKEDSALMON-APK](https://drive.google.com/drive/u/0/folders/1nymJ1JWIR8zYNLoukrR4Ym3u407YQtmt)

## Tích hợp native_opencv
 
 ### Tạo plugin native_opencv

```
 flutter create --platforms=android --template=plugin native_opencv
```

### Đưa thư viện native_opencv vào plugin

Tải thư viện tại: [Releases-Opencv](https://opencv.org/releases/)

Giải nén và đưa thư mục (native và libcxx_helper) vào (android/src), vị trí cụ thể: [native_folder](https://github.com/phuoctan4141/flutter/tree/main/bakedsalmon/packages/native_opencv/android/src)

Thêm các dòng sao vào (android/build.gradle), cụ thể tại: [build.gradle](https://github.com/phuoctan4141/flutter/blob/main/bakedsalmon/packages/native_opencv/android/build.gradle)

```
    externalNativeBuild {
            cmake {
                arguments "-DANDROID_STL=c++_shared"
                targets "native_opencv"
            }
        }
    }
```

```
    externalNativeBuild {
        cmake {
            path "libcxx_helper/CMakeLists.txt"
        }
    }
```

```
    externalNativeBuild {
        // Encapsulates your CMake build configurations.
        cmake {
            // Provides a relative path to your CMake build script.
            path "CMakeLists.txt"
        }
    }
```

### Tạo tệp tin CMakeLists.txt

Sử dụng các hướng dẫn sau đây vào CMakeLists

```
set(OPENCV_BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/native")
set(OPENCV_INCLUDE_DIR "${OPENCV_BASE_DIR}/jni/include/")
set(OPENCV_LIB_DIR "${OPENCV_BASE_DIR}/libs/${ANDROID_ABI}")
```

```

include_directories("${OPENCV_INCLUDE_DIR}")
```

```
add_library(lib_opencv SHARED IMPORTED)
set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${OPENCV_LIB_DIR}/libopencv_java4.so)
```

```
add_library(native_opencv SHARED
            src/main/cpp/native_opencv.cpp)
```

```
target_link_libraries(native_opencv
            lib_opencv)
```

Chi tiết hơn tại: [CMakeLists.txt](https://github.com/phuoctan4141/flutter/blob/main/bakedsalmon/packages/native_opencv/android/CMakeLists.txt)

### Tạo tệp tin native_opencv.cpp

Tạo tệp tin native_opencv.cpp tại (android/src/main/cpp/), cụ thể tại: [native_opencv](https://github.com/phuoctan4141/flutter/tree/main/bakedsalmon/packages/native_opencv/android/src/main/cpp)

Viết hàm xử lý template matching:

```cpp
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
```

Cụ thể xem tại: [template_matching](https://github.com/phuoctan4141/flutter/blob/main/bakedsalmon/packages/native_opencv/android/src/main/cpp/native_opencv.cpp)

Viết hàm bingding to native android code:

```dart
typedef _templateMatching_func = Int32 Function(
    Pointer<Utf8> imgPath, Pointer<Utf8> tempPath, Pointer<Utf8> resultPath);
typedef _TemplateMatchingFunc = int Function(
    Pointer<Utf8> imgPath, Pointer<Utf8> tempPath, Pointer<Utf8> resultPath);

final _templateMatching =
    native_lib.lookupFunction<_templateMatching_func, _TemplateMatchingFunc>(
        'templateMatching');

  @override
  Future<int> templateMatching(
      {required String imagePath,
      required String templatePath,
      required String resultPath}) async {
    // set up the arguments to pass to the native library
    final _imagePath = imagePath.toNativeUtf8();
    final _templatePath = templatePath.toNativeUtf8();
    final _resultPath = resultPath.toNativeUtf8();
    int count = 0;

    try {
      // call the native library
      count = _templateMatching(_imagePath, _templatePath, _resultPath);
      print('templateMatching() count: $count');
    } finally {
      // free the memory
      malloc.free(_imagePath);
      malloc.free(_templatePath);
      malloc.free(_resultPath);
    }

    return count;
  }
```

Cụ thể tại: [native_opencv_method_channel.dart](https://github.com/phuoctan4141/flutter/blob/main/bakedsalmon/packages/native_opencv/lib/native_opencv_method_channel.dart)

### Sử dụng template_matching

```dart
  Future<void> _templateMatching() async {
    if (stockFile != null && templateFile != null) {
      var _imageFile = stockFile?.copySync(
          "${stockFile!.path.substring(0, stockFile!.path.lastIndexOf("/"))}/result.jpg");
      try {
        result = await _nativeOpencvPlugin.templateMatching(
          imagePath: stockFile!.path,
          templatePath: templateFile!.path,
          resultPath: _imageFile!.path,
        );
      } finally {
        if (mounted) {
          var _imageByte = _imageFile!.readAsBytesSync();
          setState(() {
            resultFile = _imageByte;
          });
        }
      }
    }
  }
```

Cụ thể tại: [templatePage.dart](https://github.com/phuoctan4141/flutter/blob/main/bakedsalmon/lib/templatePage.dart)


### Sửa lỗi tflite lib

Thay đổi compile thành implementation tại (build.gradle) của thư viện tflite, cụ thể tại: [build.gradle](https://github.com/shaqian/flutter_tflite/blob/master/android/build.gradle)











