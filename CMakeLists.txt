cmake_minimum_required(VERSION 3.16)

project(Musync VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia Svg)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appMusync
    src/main.cpp
)

set_source_files_properties(moduls/Colors.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appMusync
    URI Musync
    QML_FILES
        src/Main.qml
        moduls/Barra_tiempo.qml
        moduls/Volume.qml
        moduls/Colors.qml
    RESOURCES
        assets/imagenes/play.svg
        assets/imagenes/pause.svg
        assets/imagenes/folder.svg
        assets/imagenes/skip_previus.svg
        assets/imagenes/skip_next.svg
        assets/imagenes/audio/volume_down.svg
        assets/imagenes/audio/volume_mute.svg
        assets/imagenes/audio/volume_off.svg
        assets/imagenes/audio/volume_up.svg
)

set_target_properties(appMusync PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMusync
    PRIVATE Qt6::Quick Qt6::Multimedia Qt6::Svg
)

include(GNUInstallDirs)
install(TARGETS appMusync
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
