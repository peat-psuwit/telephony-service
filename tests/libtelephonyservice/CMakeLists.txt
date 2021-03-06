set(LIBTELEPHONYSERVICE_DIR ${CMAKE_SOURCE_DIR}/libtelephonyservice)
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${LIBTELEPHONYSERVICE_DIR}
    ${TP_QT5_INCLUDE_DIRS}
    ${CMAKE_SOURCE_DIR}/tests/common
    ${CMAKE_BINARY_DIR}/tests/common
    ${GSETTINGS_QT_INCLUDE_DIRS}
    )

add_executable(GreeterContactsTestServerExe GreeterContactsTestServer.cpp)
target_link_libraries(GreeterContactsTestServerExe Qt5::Core Qt5::DBus)

add_executable(ToneGeneratorMock ToneGeneratorMock.cpp)
target_link_libraries(ToneGeneratorMock Qt5::Core Qt5::DBus)

add_executable(IndicatorMock IndicatorMock.cpp)
target_link_libraries(IndicatorMock Qt5::Core Qt5::DBus)

generate_test(GreeterContactsTest USE_DBUS
              SOURCES GreeterContactsTest.cpp ${LIBTELEPHONYSERVICE_DIR}/greetercontacts.cpp
              LIBRARIES Qt5::Contacts Qt5::Core Qt5::DBus Qt5::Test
              ENVIRONMENT XDG_SESSION_CLASS=greeter XDG_GREETER_DATA_DIR=${CMAKE_BINARY_DIR}/Testing/Temporary
              TASKS --task ${CMAKE_CURRENT_BINARY_DIR}/GreeterContactsTestServerExe --task-name server --ignore-return
              WAIT_FOR org.freedesktop.Accounts)
set_target_properties(GreeterContactsTest PROPERTIES COMPILE_DEFINITIONS "AS_BUSNAME=sessionBus;CMAKE_SOURCE_DIR=\"${CMAKE_SOURCE_DIR}\"")
add_dependencies(GreeterContactsTest GreeterContactsTestServerExe)

generate_test(GreeterContactsThreadTest USE_DBUS
              SOURCES GreeterContactsThreadTest.cpp ${LIBTELEPHONYSERVICE_DIR}/greetercontacts.cpp
              LIBRARIES Qt5::Contacts Qt5::Core Qt5::DBus Qt5::Test
              ENVIRONMENT XDG_SESSION_CLASS=greeter XDG_GREETER_DATA_DIR=${CMAKE_BINARY_DIR}/Testing/Temporary
              TASKS --task ${CMAKE_CURRENT_BINARY_DIR}/GreeterContactsTestServerExe --task-name server --ignore-return
              WAIT_FOR org.freedesktop.Accounts)
set_target_properties(GreeterContactsThreadTest PROPERTIES COMPILE_DEFINITIONS "AS_BUSNAME=sessionBus;CMAKE_SOURCE_DIR=\"${CMAKE_SOURCE_DIR}\"")
add_dependencies(GreeterContactsThreadTest GreeterContactsTestServerExe)

generate_test(ToneGeneratorTest USE_DBUS
              SOURCES ToneGeneratorTest.cpp ${LIBTELEPHONYSERVICE_DIR}/tonegenerator.cpp
              LIBRARIES Qt5::Core Qt5::DBus Qt5::Test
              TASKS --task ${CMAKE_CURRENT_BINARY_DIR}/ToneGeneratorMock --task-name tone-gen --ignore-return
              WAIT_FOR com.Nokia.Telephony.Tones)
add_dependencies(ToneGeneratorTest ToneGeneratorMock)

generate_test(CallNotificationTest USE_DBUS
              SOURCES CallNotificationTest.cpp ${LIBTELEPHONYSERVICE_DIR}/callnotification.cpp
              LIBRARIES Qt5::Core Qt5::DBus Qt5::Test
              TASKS --task ${CMAKE_CURRENT_BINARY_DIR}/IndicatorMock --task-name indicator --ignore-return
              WAIT_FOR com.canonical.TelephonyServiceIndicator)

generate_test(ContactUtilsTest SOURCES ContactUtilsTest.cpp LIBRARIES Qt5::Contacts Qt5::Core Qt5::Test telephonyservice USE_UI)
generate_test(PhoneUtilsTest SOURCES PhoneUtilsTest.cpp LIBRARIES telephonyservice Qt5::Core Qt5::Test USE_UI)
generate_test(ProtocolTest
              SOURCES ProtocolTest.cpp ${LIBTELEPHONYSERVICE_DIR}/protocol.cpp
              LIBRARIES Qt5::Core Qt5::Test
              ENVIRONMENT TELEPHONY_SERVICE_PROTOCOLS_DIR=${CMAKE_CURRENT_SOURCE_DIR}/testProtocols)
generate_test(ProtocolManagerTest
              SOURCES ProtocolManagerTest.cpp
              LIBRARIES Qt5::Core Qt5::Qml Qt5::Test Qt5::DBus Qt5::Contacts telepathy-qt5 telephonyservice
              ENVIRONMENT TELEPHONY_SERVICE_PROTOCOLS_DIR=${CMAKE_CURRENT_SOURCE_DIR}/testProtocols)


generate_telepathy_test(AccountEntryFactoryTest SOURCES AccountEntryFactoryTest.cpp)
generate_telepathy_test(AccountEntryTest SOURCES AccountEntryTest.cpp)
generate_telepathy_test(CallEntryTest SOURCES CallEntryTest.cpp)
generate_telepathy_test(ChatManagerTest SOURCES ChatManagerTest.cpp)
generate_telepathy_test(ChatEntryTest SOURCES ChatEntryTest.cpp)
generate_telepathy_test(OfonoAccountEntryTest SOURCES OfonoAccountEntryTest.cpp)
generate_telepathy_test(TelepathyHelperSetupTest SOURCES TelepathyHelperSetupTest.cpp)
# FIXME: investigate why this test is failing on arm64 / aarch64
if (NOT CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64.*|AARCH64.*")
    generate_telepathy_test(TelepathyHelperTest SOURCES TelepathyHelperTest.cpp)
endif()
generate_telepathy_test(USSDManagerTest SOURCES USSDManagerTest.cpp)
