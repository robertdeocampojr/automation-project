*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections


*** Variables ***
${POLL_MILLIS}      500
${TIMEOUT_MILLIS}    20000
${FIELD_LOCATOR_MAPPING_LOCATION}     classpath:data/FieldMapping.csv


*** Keywords ***
Set Field Mapping
    [Documentation]     Set FieldMapping - Fields Name, Field Identifier and and Field Type
    Parse CSV Resource      ${FIELD_LOCATOR_MAPPING_LOCATION}
    Set First CSV Row As Headers
    Create CSV Criteria
    @{result}=  Get CSV List Result

    &{LOCATORS}=    Create Dictionary    key=value

    :FOR  ${row}  IN  @{result}
    \   El add variable     input           ${row}
    \   ${key} =            EL Evaluate     $[csv:value(input,'FieldName')]
    \   ${locator} =        EL Evaluate     $[csv:value(input,'FieldLocator')]
    \   Set TO Dictionary   ${LOCATORS}     ${key}=${locator}

    Set Global Variable     ${LOCATORS}    ${LOCATORS}

Test Tear Down
    Delete All Cookies
    Capture Screenshot

Navigate To Form    [Arguments]    ${url}
    [Documentation]     Go/Navigate to a given url
    Navigate To             ${url}
	Maximize Window

Wait For Element     [Arguments]    ${locator}
    [Documentation]     Polls every 500 or half a second and will fail when timeout is reached (10000 millis or 10 secs).
    Wait Till Element Found     ${locator}    ${POLL_MILLIS}    ${TIMEOUT_MILLIS}

Wait For Visible     [Arguments]    ${locator}
    [Documentation]     Polls every 500 or half a second and will fail when timeout is reached (10000 millis or 10 secs).
    Wait Till Element Visible     ${locator}    ${POLL_MILLIS}    ${TIMEOUT_MILLIS}

Wait Element Contains Text     [Arguments]    ${locator}    ${message}
    [Documentation]     Polls every 500 or half a second and will fail when timeout is reached (10000 millis or 10 secs).
    Wait Till Element Contains Text     ${locator}    ${message}    ${POLL_MILLIS}    ${TIMEOUT_MILLIS}

Evaluate Data     [Arguments]    ${data}
    [Documentation]     Check the data if its jspringbot or robot variable. Evaluate afterward
    ${dataStartWith}=   Get Substring   ${data}      0  2
    ${data} =    Run Keyword If  '${dataStartWith}' == '\$['     EL Evaluate   ${data}   ELSE     SetVariable    ${data}
    [return]    ${data}

Set Config Data    [Arguments]    ${form}
    [Documentation]     Set the config property to use by passing the form to test
    Select Config Domain    ${form}
    Parse CSV Resource  $[config:test.data]
    Set First CSV Row As Headers

Set Config And Test Data    [Arguments]    ${form}   ${testData}
    [Documentation]     Set the config property and test data to use by passing the form to test
    Select Config Domain    ${form}
    Parse CSV Resource  ${testData}
    Set First CSV Row As Headers

Element Text Should Not Be Empty     [Arguments]    ${locator}
    [Documentation]     Verify element text should not be empty or null
    ${value} =  Get Text     ${locator}
    Should Not Be Empty     ${value}

Element Should Be Present     [Arguments]    ${locator}
    [Documentation]     Searches the page for the given element. Returns true if a match is found and false if none.
    ${isPresent} =  Is Element Present      ${locator}
    Should Be True   ${isPresent}

Element Should Not Be Present     [Arguments]    ${locator}
    [Documentation]     Searches the page for the given element. Returns true if a match is found and false if none.
    ${isPresent} =  Is Element Present      ${locator}
    Should Be False   ${isPresent}      Element is present!

Get First Data From CSV     [Arguments]    ${variable}   ${tag}
    [Documentation]     Get First row data from csv file
    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     ${tag}
    ${result}=  First CSV Result
    El add variable   ${variable}   ${result}

Get All Data From CSV By Tag    [Arguments]     ${tag}
    [Documentation]     Get all row data from csv file
    #Get data from csv file
    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     ${tag}

    ${result} =  Get CSV List Result
    [return]    ${result}

Get All Data From CSV
    [Documentation]     Get all row data from csv file
    #Get data from csv file
    Create CSV Criteria

    ${result} =  Get CSV List Result
    [return]    ${result}

Get All List Values     [Arguments]     ${locator}
    [Documentation]     Fetch all data from a list such as autosuggest
    ${locator} =   Evaluate Data   ${locator}
    ${count} =   Get Matching XPath Count    ${locator}
    ${list} =   Create List

    EL Should Be True   $[${count} > 0]
    :FOR    ${index}    IN RANGE   ${count}
    \   ${ctr} =    EL Evaluate   $[${index} + 1]
    \   ${value} =  Get Text      ${locator}[${ctr}]
    \   Append To List  ${list}     ${value}
    [return]    ${list}

Should Be False     [Arguments]    ${boolean}   ${message}
    [Documentation]     to validate if the condition is false
    ${boolean}=     Convert To String   ${boolean}
    Should Be Equal     False   ${boolean}      ${message}

Element Text Should Not Be Null     [Arguments]    ${locator}
    [Documentation]    check that an element text have value
    ${value} =      Get Text    ${locator}
    Should Not Be Empty       ${value}

Alert Should Not Be Present
    [Documentation]    verify that there's no alert message displayed
    ${isAlertPresent} =     Is Alert Present
    ${isAlertPresent} =     Convert To Boolean  ${isAlertPresent}
    Should Be False         ${isAlertPresent}   Alert Message is displayed!

Element Text Should Contain     [Arguments]    ${locator}   ${value}
    [Documentation]    verify that there's no alert message displayed
    ${value}=    Evaluate Data   ${value}
    ${actualText}=     Get Text    ${locator}
    EL Should Be True   $[contains('${actualText}', '${value}')]

Scroll Down
    [Documentation]    scroll down the page by 200
    Execute Javascript      window.scrollTo(0,200)

Scroll Up
    [Documentation]    scroll down the page by -200
    Execute Javascript      window.scrollTo(0,-200)

Verify String Contain   [Arguments]   ${string1}     ${string2}
    [Documentation]    if a string contains var - case not sensitive
    ${string1}=     Convert To Lowercase        ${string1}
    ${string2}=     Convert To Lowercase        ${string2}
    Should Contain   ${string1}    ${string2}

Verify Text Is Present   [Arguments]   ${data}
    [Documentation]    Verify if the given text is present in the page source
    ${data}=            Evaluate Data   ${data}
    ${pageSource}=      Get Source

    #iterate if each text is present
    @{items} =          Split String    ${data}  ;
    :FOR  ${text}  IN  @{items}
    \   ${isTextPresentInPageSource}=   Is Text Present In Page Source      ${pageSource}   ${text}
    \   Should Be True                  ${isTextPresentInPageSource}