*** Keywords ***
Send Text Template
    [Arguments]    ${text}    ${expected_response}
    Send text    ${text}
    Response should be    ${expected_response}

Set Echo
    [Arguments]    ${status}
    Set echo    ${status}
    # Only check echo status if `status` is explicitly 'ON' or 'OFF'
    Run Keyword If    '${status}' == 'ON' or '${status}' == 'OFF'    Check echo status    ${status}