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
    ${columns} =  Get Element Count    //table[${INDEX}]//tr//td
    : FOR    ${COUNTER}    IN RANGE    1    9
    \  ${catenate} =   Run Keyword If   ${columns} == 18    Get Text    xpath=//table[${INDEX}]//tbody[1]//tr[4]//td[${COUNTER}]
    \                  ...  ELSE IF    ${columns} == 8     Get Text    xpath=//table[${INDEX}]//tbody[1]//tr[1]//td[${COUNTER}]
    \  ${tmp_status} =  Catenate   ${tmp_status}    ${catenate}
    \  ${tmp_status} =   Catenate   ${tmp_status}    \t
    [Return]  ${tmp_status}

Get Current Remarks
    [Arguments]  ${COUNTS}
    ${columns} =  Get Element Count    //table[${COUNTS}]//tr//td
    : FOR    ${COUNTER}    IN RANGE    1    9
    \  ${catenate} =   Run Keyword If   ${columns} == 18    Get Text    xpath=//table[${COUNTS}]//tbody[1]//tr[4]//td[${COUNTER}]   ELSE     Get Text    xpath=//table[${COUNTS}]//tbody[1]//tr[1]//td[${COUNTER}]
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
    GO to    https://www.track-trace.com/aircargo    #headlesschrome      ##PROD
    Maximize Browser Window
    Sleep    4s
    ${tracking_id}=	 Replace String Using Regexp	${shipment_id}	618	  ${EMPTY}	  count=1
    Click Button    //button[@class='tingle-btn tingle-btn--primary']
    Input Text    //input[@id='number']    ${shipment_id}
    Click Button    //div[2]//input[1]
    Click Element   //p[contains(text(),'Tracking results from Singapore Airlines(SQ) can n')]
    Select Window   Track Shipment
    Input Text    //input[@id='Suffix1']    ${tracking_id}
    Click Button    //input[@id='btnQuery']
    Sleep    5s
    #Wait Until Element Is Visible  //table  timeout=60s
    ${count}=  Get Element Count    //table
    ${count}=    Convert To Integer    ${count}
    ${counts}=      Evaluate    ${count} - 1
    ${columns} =  Get Element Count    //table[${counts}]//tr//td
    ${status}=   Run Keyword If   ${columns} == 18    Get Text    xpath=//table[${counts}]//tbody[1]//tr[4]//td[3]   ELSE     Get Text    xpath=//table[${counts}]//tbody[1]//tr[1]//td[3]
    : FOR    ${INDEX}    IN RANGE    1  ${count}
    \  ${columns} =  Get Element Count    //table[${INDEX}]//tr//td
    \  ${catenate} =  Run Keyword If   ${columns} == 18 or ${columns} == 8  Get String  ${INDEX}   ELSE   Continue For Loop
    \  ${status_string} =   Catenate   ${status_string}    ${catenate}
    \  ${status_string} =   Catenate   ${status_string}    \n
    \  ${catenate} =   Set variable   ${EMPTY}
    ${current_remarks}=  Get Current Remarks  ${counts}
    send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
     #Close Browser

TC 02
    Close Browser