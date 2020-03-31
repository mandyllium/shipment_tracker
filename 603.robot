*** Settings ***
Documentation    Suite description
Library     Selenium2Library
Library     MYSQlWrapper.py
Library     String

*** Variables ***
${shipment_id}         default_circuit_id
${tmp_status}
${status_string}
${current_remarks}      '-'

*** Keywords ***
Get String
    [Arguments]  ${ROWS}
    : FOR    ${COUNTER}    IN RANGE    1    10
    \  ${catenate} =   Get Text    xpath=//div[@id='contentarea_responsive']//div[4]//tr[${ROWS}]//td[${COUNTER}]
    \  ${tmp_status} =  Catenate   ${tmp_status}    ${catenate}
    \  ${tmp_status} =   Catenate   ${tmp_status}    \t
    [Return]  ${tmp_status}

Get Current Remarks
    [Arguments]  ${ROWS}
    : FOR    ${COUNTER}    IN RANGE    1    10
    \  ${catenate} =   Get Text    xpath=//div[@id='contentarea_responsive']//div[4]//tr[${ROWS}]//td[${COUNTER}]
    \  ${tmp_status} =  Catenate   ${tmp_status}    ${catenate}
    \  ${tmp_status} =   Catenate   ${tmp_status}    \t
    [Return]  ${tmp_status}


*** Test Cases ***
Test title
    [Tags]    DEBUG
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-using
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go to    https://www.track-trace.com/aircargo   #chrome      ##PROD
    Maximize Browser Window
    Sleep    4s
    Click Button    //button[@class='tingle-btn tingle-btn--primary']
    Input Text    //input[@id='number']    ${shipment_id}
    Click Button    //div[@id='vue-multi-form']//div[3]//input[1]
    Wait Until Element Is Visible  //tr[@name='trackShiptablerow0']  timeout=30s
    ${status_string}=  Get Text    xpath=//tr[@name='trackShiptablerow0']//td[2]
    ${words} =  Split String    ${status_string}    \n
    send to DB  ${shipment_id}  ${words[0]}  ${current_remarks}  ${status_string}
    log to console   ${words[0]}
    log to console   ${current_remarks}
    log to console   ${status_string}
    Close Browser
