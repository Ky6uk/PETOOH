cmake_minimum_required(VERSION 3.1)

project(pthc)

find_package(LLVM REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})
llvm_map_components_to_libnames(llvm_libs core support)

set(CMAKE_CXX_STANDARD 14)
add_executable(${PROJECT_NAME} "src/main.cpp")
target_link_libraries(${PROJECT_NAME} ${llvm_libs})
