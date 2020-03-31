*** Settings ***
Documentation    Suite description
Library     Selenium2Library
Library     MYSQlWrapper.py

*** Variables ***
${shipment_id}         default_circuit_id

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
    Go To    https://www.track-trace.com/aircargo   #chrome      ##PROD
    Maximize Browser Window
    Sleep    4s
    Click Button    //button[@class='tingle-btn tingle-btn--primary']
    Input Text    //input[@id='number']    ${shipment_id}
    Click Button    //div[@id='vue-multi-form']//div[3]//input[1]
    Wait Until Element Is Visible  //div[@class='timelinecontainer']//div[1]//div[2]//div[1]//h3[1]  timeout=60s
    ${status}=   Get Text    xpath=//div[@class='timelinecontainer']//div[1]//div[2]//div[1]//h3[1]
    ${current_remarks}=  Get Text    xpath=//body[1]/div[1]/div[4]/div[1]/div[1]/div[2]/div[2]
    ${status_string}=    Get Location
    #send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
    Close Browser
