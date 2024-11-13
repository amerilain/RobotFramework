*** Settings ***
Suite Setup    Suite setup
Suite Teardown    Suite teardown
Test Template    Send text to Pico
Resource    AtCommands.resource

*** Test Cases ***
Send text only    hello world    HELLO WORLD
    [Tags]    text only

Send number only    1234567890    1234567890
    [Tags]    number only

Send Special Characters, number and letter    hello5588, world00!    HELLO5588X WORLD00X
    [Tags]    mixed    
