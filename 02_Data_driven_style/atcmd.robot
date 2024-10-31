*** Settings ***
Documentation     Data-driven tests for AT command communication with Raspberry Pi Pico
Library           ./AtCommandLibrary.py
Test Template     Send Text Template

*** Variables ***
${WHITESPACE_TEXT}    this    is   a   test
${EXPECTED_WHITESPACE_RESPONSE}    SENT="THIS IS A TEST"

*** Test Cases ***
Connection Test
    [Template]    Send Text Template
    AT    SENT="AT"

Only Letters
    [Template]    Send Text Template
    this is a test    SENT="THIS IS A TEST"

Only Numbers
    [Template]    Send Text Template
    1234567890    SENT="1234567890"

Mixed Letters and Numbers
    [Template]    Send Text Template
    test123test    SENT="TEST123TEST"

Whitespace and Tabs
    [Template]    Send Text Template
    ${WHITESPACE_TEXT}    ${EXPECTED_WHITESPACE_RESPONSE}

Special Characters
    [Template]    Send Text Template
    hello, world!    SENT="HELLOX WORLDX"

Invalid Command
    [Template]    Send Text Template
    SEND+WRONG    SENT="SENDXWRONG"

Unrecognized AT Command
    [Template]    Send Text Template
    AT+UNKNOWN    SENT="ATXUNKNOWN"

*** Keywords ***
Send Text Template
    [Arguments]    ${text}    ${expected_response}
    Send text    ${text}

    Response should be    ${expected_response}