*** Keywords ***
Send Text Template
    [Arguments]    ${text}    ${expected_response}
    Send text    ${text}
    Response should be    ${expected_response}
