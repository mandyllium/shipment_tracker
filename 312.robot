*** Settings ***
Documentation    Suite description
Library     Selenium2Library
Library     MYSQlWrapper.py

*** Variables ***
${shipment_id}         default_circuit_id
${tmp_status}
${status_string}

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
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go to    https://www.track-trace.com/aircargo   #chrome      ##PROD
    Maximize Browser Window
    Sleep    4s
    Click Button    //button[@class='tingle-btn tingle-btn--primary']
    Input Text    //input[@id='number']    ${shipment_id}
    Click Button    //div[@id='vue-multi-form']//div[3]//input[1]
    Wait Until Element Is Visible  //span[@id='lblLatestActivity']  timeout=30s
    ${ROWS}=  Get Element Count    //div[@id='contentarea_responsive']//div[4]//tr
    ${status}=   Get Text    xpath=//span[@id='lblLatestActivity']
    ${current_remarks}=  Get Current Remarks  ${ROWS}
    ${ROWS}=    Evaluate    ${ROWS} + 1
    : FOR    ${INDEX}    IN RANGE    2  ${ROWS}
    \  ${catenate} =  Get String  ${INDEX}
    \  ${status_string} =   Catenate   ${status_string}    ${catenate}
    \  ${status_string} =   Catenate   ${status_string}    \n
    \  ${catenate} =   Set variable   ${EMPTY}
    send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
    Close Browser
