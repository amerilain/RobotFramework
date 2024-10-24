*** Settings ***
Library    OperatingSystem
Library    Collections
Library    String
Library    Dialogs
Library    FakerLibrary    locale=fi_FI

*** Variables ***
${ADDRESS_FILE}    address.txt

*** Keywords ***
Get Random Names
    [Arguments]    ${number_of_names}
    ${names}    Create List
    FOR    ${i}    IN RANGE    ${number_of_names}
        ${name}    FakerLibrary.Name
        Append To List    ${names}    ${name}
    END
    RETURN    ${names}

Remove Existing Address File
    [Arguments]    ${file_name}
    ${file_exists}    Run Keyword And Return Status    File Should Exist    ${file_name}
    IF    ${file_exists}
        ${file_content}    Get File    ${file_name}
        ${lines}    Split String    ${file_content}    \n
        ${first_line}    Set Variable    ${lines[0]}
        Log    Removing file for person: ${first_line}
        Remove File    ${file_name}
    END

Create New Address File
    ${names}    Get Random Names    5
    ${name}    Get Selection From User    Select a name    @{names}
    ${street_address}    FakerLibrary.Street Address
    ${postcode_city}    FakerLibrary.City
    Write Address To File    ${name}    ${street_address}    ${postcode_city}

Write Address To File
    [Arguments]    ${name}    ${street_address}    ${postcode_city}
    Append To File    ${ADDRESS_FILE}    ${name}\n
    Append To File    ${ADDRESS_FILE}    ${street_address}\n
    Append To File    ${ADDRESS_FILE}    ${postcode_city}\n

Check Address File Content
    ${content}    Get File    ${ADDRESS_FILE}
    Should Contain    ${content}    \n
    ${lines}    Get Length    ${content.splitlines()}
    Should Be Equal As Numbers    ${lines}    3

*** Test Cases ***
Remove Existing Address File Test
    Remove Existing Address File    ${ADDRESS_FILE}

Create New Address File Test
    Create New Address File

Check Address File Content Test
    Check Address File Content