*** Settings ***
Resource    ../selenium-resources.robot
Resource    ../form-resources.robot

Suite Setup     Set Field Mapping
Test Setup      Set Config And Test Data     web     $[config:test.data]
Test Teardown   Test Tear Down


*** Test Cases ***
Test Valid User Login 1
    [Tags]            demo    test1
    [Documentation]     for demo purpose
    Navigate To Form        http://automationpractice.com/
    Click Element           link=Sign in

    Input Text              id=email            robertdeocampojr@gmail.com
    Input Text              id=passwd           test1234
    Click Element           id=SubmitLogin
    Verify Text Is Present  Robert de Ocampo


Test Valid User Login 2
    [Tags]      regression      demo    test2
    [Documentation]     for demo purpose - property files
    #Get all data from csv file
    Get First Data From CSV     input   valid

    Navigate To Form        $[config:test.url.dev]
    Click Element           ${LOCATORS.WEB_LOGIN_LINK}
    Input Text              ${LOCATORS.WEB_EMAIL_FIELD}           $[csv:value(input,'USERNAME')]
    Input Text              ${LOCATORS.WEB_PASSWORD_FIELD}        $[csv:value(input,'PASSWORD')]
    Click Element           ${LOCATORS.WEB_LOGIN_BUTTON}
    Verify Text Is Present  $[csv:value(input,'MESSAGE')]


Test All Login Scenarios
    [Tags]       regression      demo    test3
    [Documentation]     for demo purpose - data driven
    #Get all data from csv file
    @{result} =  Get All Data From CSV

    # will show the result of the related word
    :FOR  ${row}  IN  @{result}
    \   El add variable   input   ${row}
    \   Open Frontend Url       $[csv:value(input,'USERNAME')]      $[csv:value(input,'PASSWORD')]  $[csv:value(input,'MESSAGE')]
    \   Delete All Cookies
    \   Capture Screenshot
