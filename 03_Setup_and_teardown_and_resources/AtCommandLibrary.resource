*** Keywords ***
Initialize Device
    [Documentation]    Sets up the device connection and disables echo.
    Set Echo    OFF
    ${response}=    Send Text    AT
    Run Keyword If    '${response}' == 'SENT="AT"' or '${response}' == 'OK'    Log    Initialization successful with response: ${response}
    Run Keyword If    '${response}' != 'SENT="AT"' and '${response}' != 'OK'    Fail    Unexpected response during initialization: ${response}

Restore Device State
    [Documentation]    Restores the device echo setting to ON.
    Set Echo    ON

Send Text Template
    [Arguments]    ${text}    ${expected_response}
    ${response}=    Send Text    ${text}
    Run Keyword If    '${response}'.startswith('SENT=')    Set Test Variable    ${expected_response}    ${response}
    Should Be Equal    ${response}    ${expected_response}