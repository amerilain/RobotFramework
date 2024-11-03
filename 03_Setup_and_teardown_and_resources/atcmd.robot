*** Settings ***
Documentation     Data-driven tests for AT command communication with Raspberry Pi Pico
Resource          AtCommandLibrary.resource
Library           AtCommandLibrary.py    /dev/tty.usbmodem1101

Suite Setup       Initialize Device
Suite Teardown    Restore Device State

*** Test Cases ***
Connection Test
    [Template]    Send Text Template
    AT            OK

Only Letters
    [Template]    Send Text Template
    this is a test    THIS IS A TEST

Only Numbers
    [Template]    Send Text Template
    1234567890        1234567890

Mixed Letters and Numbers
    [Template]    Send Text Template
    test123test       TEST123TEST

Whitespace and Tabs
    [Template]    Send Text Template
    this${SPACE}is${SPACE}a${SPACE}test    THIS IS A TEST

Special Characters
    [Template]    Send Text Template
    hello, world!     HELLOX WORLDX