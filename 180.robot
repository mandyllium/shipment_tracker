*** Settings ***
Documentation    Suite description
Library     Selenium2Library
Library     String
Library     MYSQlWrapper.py

*** Variables ***
${shipment_id}         default_circuit_id
${status_string}
${tmp_status}
${current_remarks}     '-'

*** Test Cases ***
Test title
    [Tags]    DEBUG
#    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
#    Call Method    ${chrome_options}    add_argument    --disable-extensions
#    Call Method    ${chrome_options}    add_argument    --headless
#    Call Method    ${chrome_options}    add_argument    --disable-gpu
#    Call Method    ${chrome_options}    add_argument    --no-sandbox
#    Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
#    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Open Browser    https://www.track-trace.com/aircargo    chrome      ##PROD
    Maximize Browser Window
    Sleep    4s
    ${tracking_id}=	 Replace String Using Regexp	${shipment_id}	180	  ${EMPTY}	  count=1
    Click Button    //button[@class='tingle-btn tingle-btn--primary']
    Input Text    //input[@id='number']    ${shipment_id}
    Click Button    //div[@id='vue-multi-form']//div[3]//input[1]
    Wait Until Element Is Visible  //input[@name='awbDocNo']  timeout=30s
    Input Text    //input[@name='awbDocNo']    ${tracking_id}
    Wait Until Element Is Visible  //span[@class='fas fa-sort']  timeout=30s
    ${count}=  Get Element Count     //div[@class='timeLineStatus cargoStatus']//div//div
    ${count}=    Evaluate    ${count} - 1
    ${status}=   Get Text    xpath=//div[@class='timeLineStatus cargoStatus']//div[${count}]
    ${status_string}=    Get Location
    #send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
    Close Browser