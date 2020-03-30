*** Settings ***
Documentation    Suite description
Library     Selenium2Library
Library     String
Library     MYSQlWrapper.py

*** Variables ***
${shipment_id}         default_circuit_id
${status_string}
${tmp_status}

*** Keywords ***
Get String
    [Arguments]  ${INDEX}
    : FOR    ${COUNTER}    IN RANGE    1    7
    \  ${catenate} =   Get Text    xpath=//tr[@id='trackShiptable1rowInner0']//tr[${INDEX}]//td[${COUNTER}]
    \  ${tmp_status} =  Catenate   ${tmp_status}    ${catenate}
    \  ${tmp_status} =   Catenate   ${tmp_status}    \t
    [Return]  ${tmp_status}

Get Current Remarks
    : FOR    ${COUNTER}    IN RANGE    1    7
    \  ${catenate} =   Get Text    xpath=//tr[@id='trackShiptable1rowInner0']//tr[1]//td[${COUNTER}]
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
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    GO to    https://www.track-trace.com/aircargo    #headlesschrome      ##PROD
    Maximize Browser Window
    Sleep    4s
    Click Button    //button[@class='tingle-btn tingle-btn--primary']
    Input Text    //input[@id='number']    ${shipment_id}
    Click Button    //div[@id='vue-multi-form']//div[3]//input[1]
    Wait Until Element Is Visible  //tr[@id='trackShiptable1rowInner0']//tr[1]//td[3]  timeout=30s
    ${rows}=  Get Element Count    //tr[@id='trackShiptable1rowInner0']//tr
    ${ROWS}=    Convert To Integer    ${rows}
    ${status}=   Get Text    xpath=//tr[@id='trackShiptable1rowInner0']//tr[1]//td[3]
    : FOR    ${INDEX}    IN RANGE    1  ${ROWS}
    \  ${catenate} =  Get String  ${INDEX}
    \  ${status_string} =   Catenate   ${status_string}    ${catenate}
    \  ${status_string} =   Catenate   ${status_string}    \n
    \  ${catenate} =   Set variable   ${EMPTY}
    ${current_remarks}=  Get Current Remarks
    send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
    Close Browser