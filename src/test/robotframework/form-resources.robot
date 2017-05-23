*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections

*** Variables ***
${POLL_MILLIS}      500
${TIMEOUT_MILLIS}    10000
${MAX_RESULT_DISPLAY}    250


*** Keywords ***
Open Frontend Url     [Arguments]    ${username}      ${password}   ${text}
    Navigate To Form            $[config:test.url.dev]
    Click Element               ${LOCATORS.WEB_LOGIN_LINK}
    Input Text                  ${LOCATORS.WEB_EMAIL_FIELD}           ${username}
    Input Text                  ${LOCATORS.WEB_PASSWORD_FIELD}        ${password}
    Click Element               ${LOCATORS.WEB_LOGIN_BUTTON}
    Verify Text Is Present      ${text}