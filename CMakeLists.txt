cmake_minimum_required(VERSION 3.16)

project(Musync VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appMusync
    main.cpp
)

qt_add_qml_module(appMusync
    URI Musync
    QML_FILES
        Main.qml
        barra_tiempo.qml
        QML_FILES barra_tiempo.qml
)

set_target_properties(appMusync PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMusync
    PRIVATE Qt6::Quick Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appMusync
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
