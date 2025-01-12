#
# Tell the Linux build to look in a few additional places for libs
#

LinuxBuild {
	LIBS += \
		-L/usr/lib

    linux-g++-64 {
        LIBS += \
            -L/usr/local/lib64 \
            -L/usr/lib64
	}
}

#
# Add in a few missing headers to windows
#

WindowsBuild {
    INCLUDEPATH += libs/lib/msinttypes
}

#
# QUpgrade
#

exists(qupgrade) {
    message(Including support for QUpgrade)

    DEFINES += QUPGRADE_SUPPORT

    INCLUDEPATH += qupgrade/src/apps/qupgrade

    FORMS += \
        qupgrade/src/apps/qupgrade/dialog_bare.ui \
        qupgrade/src/apps/qupgrade/boardwidget.ui

    HEADERS += \
        qupgrade/src/apps/qupgrade/qgcfirmwareupgradeworker.h \
        qupgrade/src/apps/qupgrade/uploader.h \
        qupgrade/src/apps/qupgrade/dialog_bare.h \
        qupgrade/src/apps/qupgrade/boardwidget.h

    SOURCES += \
        qupgrade/src/apps/qupgrade/qgcfirmwareupgradeworker.cpp \
        qupgrade/src/apps/qupgrade/uploader.cpp \
        qupgrade/src/apps/qupgrade/dialog_bare.cpp \
        qupgrade/src/apps/qupgrade/boardwidget.cpp

    RESOURCES += \
        qupgrade/qupgrade.qrc

    LinuxBuild:CONFIG += qesp_linux_udev

    include(qupgrade/libs/qextserialport/src/qextserialport.pri)
} else {
    message(Skipping support for QUpgrade)
}

#
# MAVLink
#

MAVLINK_CONF = ""
MAVLINKPATH = $$BASEDIR/libs/mavlink/include/mavlink/v1.0
DEFINES += MAVLINK_NO_DATA

# If the user config file exists, it will be included.
# if the variable MAVLINK_CONF contains the name of an
# additional project, QGroundControl includes the support
# of custom MAVLink messages of this project. It will also
# create a QGC_USE_{AUTOPILOT_NAME}_MESSAGES macro for use
# within the actual code.
exists(user_config.pri) {
    include(user_config.pri)
    message("----- USING CUSTOM USER QGROUNDCONTROL CONFIG FROM user_config.pri -----")
    message("Adding support for additional MAVLink messages for: " $$MAVLINK_CONF)
    message("------------------------------------------------------------------------")
} else {
    MAVLINK_CONF += ardupilotmega
}
INCLUDEPATH += $$MAVLINKPATH
isEmpty(MAVLINK_CONF) {
    INCLUDEPATH += $$MAVLINKPATH/common
message("Using mavlink common")
} else {
    INCLUDEPATH += $$MAVLINKPATH/$$MAVLINK_CONF
message("Using mavlink " + $$MAVLINK_CONF)
    DEFINES += $$sprintf('QGC_USE_%1_MESSAGES', $$upper($$MAVLINK_CONF))
}

#
# MAVLink generator (deprecated)
#

DEPENDPATH += \
    src/apps/mavlinkgen

INCLUDEPATH += \
    src/apps/mavlinkgen \
    src/apps/mavlinkgen/ui \
    src/apps/mavlinkgen/generator

#include(src/apps/mavlinkgen/mavlinkgen.pri)

#
# OpenSceneGraph
#

#Remove OSG support, as it's only valid for Qt4, not Qt5
#MacBuild {
#    # GLUT and OpenSceneGraph are part of standard install on Mac
#	CONFIG += OSGDependency

#    INCLUDEPATH += \
#        $$BASEDIR/libs/lib/mac64/include

#	LIBS += \
#        -L$$BASEDIR/libs/lib/mac64/lib \
#        -losgWidget
#}

#Remove OSG support, as it's only valid for Qt4, not Qt5
#LinuxBuild {
#	exists(/usr/include/osg) | exists(/usr/local/include/osg) {
#        CONFIG += OSGDependency
#        exists(/usr/include/osg/osgQt) | exists(/usr/include/osgQt) | exists(/usr/local/include/osg/osgQt) | exists(/usr/local/include/osgQt) {
#            message("Including support for Linux OpenSceneGraph Qt")
#            LIBS += -losgQt
#            DEFINES += QGC_OSG_QT_ENABLED
#        } else {
#            message("Skipping support for Linux OpenSceneGraph Qt")
#        }
#	}
#}

WindowsBuild {
	exists($$BASEDIR/libs/lib/osg123) {
        CONFIG += OSGDependency

		INCLUDEPATH += \
            $$BASEDIR/libs/lib/osgEarth/win32/include \
			$$BASEDIR/libs/lib/osgEarth_3rdparty/win32/OpenSceneGraph-2.8.2/include

		LIBS += -L$$BASEDIR/libs/lib/osgEarth_3rdparty/win32/OpenSceneGraph-2.8.2/lib
	}
}

OSGDependency {
    message("Including support for OpenSceneGraph")

	DEFINES += QGC_OSG_ENABLED

    LIBS += \
        -losg \
        -losgViewer \
        -losgGA \
        -losgDB \
        -losgText \
        -lOpenThreads

    HEADERS += \
        src/ui/map3D/gpl.h \
        src/ui/map3D/CameraParams.h \
        src/ui/map3D/ViewParamWidget.h \
        src/ui/map3D/SystemContainer.h \
        src/ui/map3D/SystemViewParams.h \
        src/ui/map3D/GlobalViewParams.h \
        src/ui/map3D/SystemGroupNode.h \
        src/ui/map3D/Q3DWidget.h \
        src/ui/map3D/GCManipulator.h \
        src/ui/map3D/ImageWindowGeode.h \
        src/ui/map3D/PixhawkCheetahNode.h \
        src/ui/map3D/Pixhawk3DWidget.h \
        src/ui/map3D/Q3DWidgetFactory.h \
        src/ui/map3D/WebImageCache.h \
        src/ui/map3D/WebImage.h \
        src/ui/map3D/TextureCache.h \
        src/ui/map3D/Texture.h \
        src/ui/map3D/Imagery.h \
        src/ui/map3D/HUDScaleGeode.h \
        src/ui/map3D/WaypointGroupNode.h \
        src/ui/map3D/TerrainParamDialog.h \
        src/ui/map3D/ImageryParamDialog.h

    SOURCES += \
        src/ui/map3D/gpl.cc \
        src/ui/map3D/CameraParams.cc \
        src/ui/map3D/ViewParamWidget.cc \
        src/ui/map3D/SystemContainer.cc \
        src/ui/map3D/SystemViewParams.cc \
        src/ui/map3D/GlobalViewParams.cc \
        src/ui/map3D/SystemGroupNode.cc \
        src/ui/map3D/Q3DWidget.cc \
        src/ui/map3D/ImageWindowGeode.cc \
        src/ui/map3D/GCManipulator.cc \
        src/ui/map3D/PixhawkCheetahNode.cc \
        src/ui/map3D/Pixhawk3DWidget.cc \
        src/ui/map3D/Q3DWidgetFactory.cc \
        src/ui/map3D/WebImageCache.cc \
        src/ui/map3D/WebImage.cc \
        src/ui/map3D/TextureCache.cc \
        src/ui/map3D/Texture.cc \
        src/ui/map3D/Imagery.cc \
        src/ui/map3D/HUDScaleGeode.cc \
        src/ui/map3D/WaypointGroupNode.cc \
        src/ui/map3D/TerrainParamDialog.cc \
        src/ui/map3D/ImageryParamDialog.cc
} else {
    message("Skipping support for OpenSceneGraph")
}

#
# Google Earth
#

MacBuild | WindowsBuild : contains(GOOGLEEARTH, enable) { #fix this to make sense ;)
    message(Including support for Google Earth)

    HEADERS += src/ui/map3D/QGCGoogleEarthView.h
    SOURCES += src/ui/map3D/QGCGoogleEarthView.cc
    WindowsBuild {
        CONFIG += qaxcontainer
    }
} else {
    message(Skipping support for Google Earth)
}

#
# Protcol Buffers for PixHawk
#

LinuxBuild : contains(MAVLINK_CONF, pixhawk) {
    exists(/usr/local/include/google/protobuf) | exists(/usr/include/google/protobuf) {
        message("Including support for Protocol Buffers")

        DEFINES += QGC_PROTOBUF_ENABLED

        LIBS += \
            -lprotobuf \
            -lprotobuf-lite \
            -lprotoc

        HEADERS += \
            libs/mavlink/include/mavlink/v1.0/pixhawk/pixhawk.pb.h \
            src/ui/map3D/ObstacleGroupNode.h \
            src/ui/map3D/GLOverlayGeode.h

        SOURCES += \
            libs/mavlink/share/mavlink/src/v1.0/pixhawk/pixhawk.pb.cc \
            src/ui/map3D/ObstacleGroupNode.cc \
            src/ui/map3D/GLOverlayGeode.cc
    } else {
        message("Skipping support for Protocol Buffers")
    }
} else {
    message("Skipping support for Protocol Buffers")
}

#
# libfreenect Kinect support
#

MacBuild | LinuxBuild {
    exists(/opt/local/include/libfreenect) | exists(/usr/local/include/libfreenect) {
        message("Including support for libfreenect")

        #INCLUDEPATH += /usr/include/libusb-1.0
        DEFINES += QGC_LIBFREENECT_ENABLED
        LIBS += -lfreenect
        HEADERS += src/input/Freenect.h
        SOURCES += src/input/Freenect.cc
    } else {
        message("Skipping support for libfreenect")
    }
} else {
    message("Skipping support for libfreenect")
}

#
# AGLLIB math library
#
include(libs/alglib/alglib.pri)
DEFINES += NOMINMAX
#
# OPMapControl library (from OpenPilot)
#

#include(libs/utils/utils_external.pri)
include(libs/opmapcontrol/opmapcontrol_external.pri)

DEPENDPATH += \
    libs/utils \
    libs/utils/src \
    libs/opmapcontrol \
    libs/opmapcontrol/src \
    libs/opmapcontrol/src/mapwidget

INCLUDEPATH += \
    libs/utils \
    libs \
    libs/opmapcontrol

WindowsBuild {
    # Used to enumerate serial ports by QSerialPort
	LIBS += -lsetupapi
}

#
# Zip Access Tool (http://quazip.sourceforge.net)
#
include (libs/thirdParty/quazip/quazip.pri)

#
# XBee wireless
#

WindowsBuild {
    #message(Including support for XBee)

    #DEFINES += XBEELINK

    #INCLUDEPATH += libs/thirdParty/libxbee

    #HEADERS += \
    #    src/comm/XbeeLinkInterface.h \
    #    src/comm/XbeeLink.h \
    #    src/comm/HexSpinBox.h \
    #    src/ui/XbeeConfigurationWindow.h \
    #    src/comm/CallConv.h

    #SOURCES += \
    #    src/comm/XbeeLink.cpp \
    #    src/comm/HexSpinBox.cpp \
    #    src/ui/XbeeConfigurationWindow.cpp

    #WindowsBuild {
    #    LIBS += -llibs/thirdParty/libxbee/lib/libxbee
    #}

    #LinuxBuild {
    #    LIBS += -lxbee
    #}
} else:WindowsCrossBuild {
    #LIBS += -llibs/thirdParty/libxbee/lib/libxbee
    message(Skipping support for XBee)
} else {
    message(Skipping support for XBee)
}

#
# [OPTIONAL] Magellan 3DxWare library. Provides support for 3DConnexion's 3D mice.
#
contains(DEFINES, DISABLE_3DMOUSE) {
    message("Skipping support for Magellan 3DxWare (manual override from command line)")
    DEFINES -= DISABLE_3DMOUSE
# Otherwise the user can still disable this feature in the user_config.pri file.
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, DISABLE_3DMOUSE) {
    message("Skipping support for 3DConnexion mice (manual override from user_config.pri)")
} else:LinuxBuild {
    exists(/usr/local/lib/libxdrvlib.so) {
        message("Including support for Magellan 3DxWare")

        DEFINES += MOUSE_ENABLED_LINUX
        DEFINES += ParameterCheck
        # Hack: Has to be defined for magellan usage

        INCLUDEPATH *= /usr/local/include
        HEADERS += src/input/Mouse6dofInput.h
        SOURCES += src/input/Mouse6dofInput.cpp
        LIBS += -L/usr/local/lib/ -lxdrvlib
    } else {
        warning("Skipping support for Magellan 3DxWare (missing libraries, see README)")
    }
} else:WindowsBuild {
    message("Including support for Magellan 3DxWare")

    DEFINES += MOUSE_ENABLED_WIN

    INCLUDEPATH += libs/thirdParty/3DMouse/win

    HEADERS += \
        libs/thirdParty/3DMouse/win/I3dMouseParams.h \
        libs/thirdParty/3DMouse/win/MouseParameters.h \
        libs/thirdParty/3DMouse/win/Mouse3DInput.h \
        src/input/Mouse6dofInput.h

    SOURCES += \
        libs/thirdParty/3DMouse/win/MouseParameters.cpp \
        libs/thirdParty/3DMouse/win/Mouse3DInput.cpp \
        src/input/Mouse6dofInput.cpp
} else {
    message("Skipping support for Magellan 3DxWare (unsupported platform)")
}

#
# Opal RT-LAB Library
#

WindowsBuild : win32 : exists(src/lib/opalrt/OpalApi.h) : exists(C:/OPAL-RT/RT-LAB7.2.4/Common/bin) {
    message("Including support for Opal-RT")

    DEFINES += OPAL_RT

    INCLUDEPATH +=
        src/lib/opalrt
        libs/lib/opal/include \

    FORMS += src/ui/OpalLinkSettings.ui

    HEADERS += \
        src/comm/OpalRT.h \
        src/comm/OpalLink.h \
        src/comm/Parameter.h \
        src/comm/QGCParamID.h \
        src/comm/ParameterList.h \
        src/ui/OpalLinkConfigurationWindow.h

    SOURCES += \
        src/comm/OpalRT.cc \
        src/comm/OpalLink.cc \
        src/comm/Parameter.cc \
        src/comm/QGCParamID.cc \
        src/comm/ParameterList.cc \
        src/ui/OpalLinkConfigurationWindow.cc

    LIBS += \
        -LC:/OPAL-RT/RT-LAB7.2.4/Common/bin \
        -lOpalApi
} else {
    message("Skipping support for Opal-RT")
}

#
# SDL
#

MacBuild {
    INCLUDEPATH += \
        $$BASEDIR/libs/lib/Frameworks/SDL2.framework/Headers

    LIBS += \
        -F$$BASEDIR/libs/lib/Frameworks \
        -framework SDL2
}

LinuxBuild {
	LIBS += \
            -lSDL2
}

WindowsBuild{
    INCLUDEPATH += \
        $$BASEDIR/libs/lib/sdl/msvc/include \

    contains(QT_ARCH, i386) {
        LIBS += \
            -L$$BASEDIR/libs/lib/sdl/msvc/lib/x86 \
            -lSDL2main \
            -lSDL2
    }else {
        LIBS += \
            -L$$BASEDIR/libs/lib/sdl/msvc/lib/x64 \
            -lSDL2main \
            -lSDL2
    }
}

WindowsCrossBuild {
    INCLUDEPATH += \
        $$BASEDIR/libs/lib/sdl/include \

    LIBS += \
        -L$$BASEDIR/libs/lib/sdl/win32 \
        -lSDL2
}

#
# Festival Lite speech synthesis engine
#

LinuxBuild {
	LIBS += \
		-lflite_cmu_us_kal16 \
		-lflite_usenglish \
		-lflite_cmulex \
		-lflite
}

