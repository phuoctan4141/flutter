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

Giải nén và đưa thư mục (native) vào (android/src)

Vị trí cụ thể: [native_folder](https://github.com/phuoctan4141/flutter/tree/main/bakedsalmon/packages/native_opencv/android/src/native)

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


