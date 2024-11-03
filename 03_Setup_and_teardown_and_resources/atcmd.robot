*** Settings ***
Documentation     Data-driven tests for AT command communication with Raspberry Pi Pico
Resource          AtCommandLibrary.resource
Library           AtCommandLibrary.py    /dev/tty.usbmodem1101

Suite Setup       Initialize Device
Suite Teardown    Restore Device State
Test Template     Send Text Template

*** Test Cases ***              Input               Expected Response
Connection Test                 AT                  AT
Only Letters                    this is a test      THIS IS A TEST
Only Numbers                    1234567890          1234567890
Mixed Letters and Numbers       test123test         TEST123TEST
Whitespace and Tabs             this${SPACE}is${SPACE}a${SPACE}test    THIS IS A TEST
Special Characters              hello, world!       HELLOX WORLDX