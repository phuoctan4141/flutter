cmake_minimum_required(VERSION 3.4.1)
project(native_opencv)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(BUILD_SHARED_LIBS ON)

set(OPENCV_BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/native")
set(OPENCV_INCLUDE_DIR "${OPENCV_BASE_DIR}/jni/include/")
set(OPENCV_LIB_DIR "${OPENCV_BASE_DIR}/libs/${ANDROID_ABI}")
set(OPENCV_STATIC_LIB_DIR "${OPENCV_BASE_DIR}/staticlibs/${ANDROID_ABI}")
set(OPENCV_3RDPARTY_LIB_DIR "${OPENCV_BASE_DIR}/3rdparty/libs/${ANDROID_ABI}")

include_directories("${OPENCV_INCLUDE_DIR}")

file(GLOB_RECURSE STATIC_LIBS "${OPENCV_STATIC_LIB_DIR}/*.a")
file(GLOB_RECURSE 3RDPARTY_LIBS "${OPENCV_3RDPARTY_LIB_DIR}/*.a")

add_library(lib_opencv SHARED IMPORTED)
set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${OPENCV_LIB_DIR}/libopencv_java4.so)

find_library(log-lib log)

# https://stackoverflow.com/questions/41554511/how-to-add-cpufeatures-to-android-jni-cmake-gradle-build
include(AndroidNdkModules)
android_ndk_import_module_cpufeatures()

# https://stackoverflow.com/questions/39917056/undefined-references-in-static-opencv-libraries
# https://stackoverflow.com/questions/5395309/how-do-i-force-cmake-to-include-pthread-option-during-compilation
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)

add_library(native_opencv SHARED
            src/main/cpp/native_opencv.cpp)
target_link_libraries(native_opencv
            ${log-lib}
            cpufeatures
            Threads::Threads
            lib_opencv
            # https://stackoverflow.com/questions/43603178/undefined-reference-to-symbol-gzclose-with-cmake-and-opencv
            # https://stackoverflow.com/questions/9700414/compilation-problems-with-zlib
            -lz)