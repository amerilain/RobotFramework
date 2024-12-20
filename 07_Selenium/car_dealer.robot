*** Settings ***
Documentation       Car dealer website test
Library             SeleniumLibrary
Library             Dialogs
Library             Process

Test Setup          Start Container
Test Teardown       Stop Container

*** Variables ***
${LOGIN URL}      http://localhost:3000
${BROWSER}        Chrome

*** Test Cases ***
Add Multiple Cars Test
    [Documentation]    This test case adds three cars to the car dealer website.
    #Set Selenium Speed   0.1
    Open Car Dealer Website
    Wait Until Element Is Visible    locator=link=Add a car    timeout=10s
    Capture Page Screenshot    screenshots/before_cars_added.png
    Add New Car    Toyota    Corolla    50000    2018    ABC-123
    Add New Car    Honda    Civic    30000    2020    DEF-456
    Add New Car    Ford    Focus    20000    2021    GHI-789
    Capture Page Screenshot    screenshots/after_cars_added.png
    Close Application

*** Keywords ***
Open Car Dealer Website
    [Documentation]    Opens the car dealer website in the specified browser.
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Maximize Browser Window

Add New Car
    [Arguments]    ${make}    ${model}    ${mileage}    ${year}    ${plate}
    [Documentation]    Fills out and submits the car form.
    Wait Until Element Is Visible    locator=link=Add a car    timeout=10s
    Click Link    Add a car
    Input Text    id=make-input    ${make}
    Input Text    id=model-input   ${model}
    Input Text    id=mileage-input  ${mileage}
    Input Text    id=year-input     ${year}
    Input Text    id=plate-input    ${plate}
    Click Button    Add a new car

Close Application
    Close Browser

Start Container
    Log     Starting container
    Run Process     docker-compose     up     --detach
    Sleep    5s

Stop Container
    #Pause Execution
    Close Browser
    Run Process     docker-compose     down