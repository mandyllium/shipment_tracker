*** Settings ***
Documentation    Suite description
Library     SeleniumLibrary
Library     MYSQlWrapper.py
Library      XvfbRobot

*** Variables ***
${shipment_id}         default_circuit_id
${tmp_status}

*** Keywords ***
Get Current Remarks
    : FOR    ${COUNTER}    IN RANGE    1    7
    \  ${catenate} =   Get Text    xpath=//div[@id='tntTab1']//div[2]//div[${COUNTER}]
    \  ${tmp_status} =  Catenate   ${tmp_status}    ${catenate}
    \  ${tmp_status} =   Catenate   ${tmp_status}    \t
    [Return]  ${tmp_status}

*** Test Cases ***
Test title
    [Tags]    DEBUG
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${userAgent}=  set variable  --user-agent="Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19"
    #Call Method    ${chrome_options}    add_argument    --user-agent=Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36 System/ComputerId
    Call Method    ${chrome_options}  add_argument  ${userAgent}
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-using
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go to    https://www.track-trace.com/aircargo   #chrome      ##PROD
    Maximize Browser Window
    Wait Until Element Is Visible  //button[@class='tingle-btn tingle-btn--primary']  timeout=60s
    Click Button    //button[@class='tingle-btn tingle-btn--primary']
    Input Text    //input[@id='number']    ${shipment_id}
    Click Button    //div[@id='vue-multi-form']//div[3]//input[1]
    Wait Until Element Is Visible  //div[@id='tntTab1']//div[2]//div[2]  timeout=60s
    ${status}=   Get Text    xpath=//div[@id='tntTab1']//div[2]//div[2]
    ${current_remarks}=  Get Current Remarks
    ${status_string}=    Get Location
    send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
    #Close Browser

TC 02
    Close Browser