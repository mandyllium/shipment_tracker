*** Settings ***
Documentation    Suite description
Library     Selenium2Library
Library     String
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
    ${tracking_id}=	 Replace String Using Regexp	${shipment_id}	-	  ${EMPTY}	  count=1
    ${tracking_id}=	 Replace String Using Regexp	${shipment_id}	403	  ${EMPTY}	  count=1
    Go to    https://jumpseat.atlasair.com/aa/tracktracehtml/TrackTrace.html?pe=403&se=${tracking_id}  #chrome      ##PROD
    Maximize Browser Window
    Sleep    7s
    Wait Until Element Is Visible   //td[3][@class="statusinfo"]  timeout=60s
    ${columns} =  Get Element Count    //td[3][@class="statusinfo"]
    ${column}=      Evaluate    ${columns} + 1
    ${Result}=  Page Should Contain Element  //tr[${columns}]//td[3][@class="statusinfo"]
    log to console  ${Result}
    ${status}=  Run Keyword Unless  '${Result}'=='PASS'  Get Text    xpath=//tr[${columns}]//td[3][@class="statusinfo"]
    ${status}=  Run Keyword Unless  '${Result}'=='FAIL'  Get Text    xpath=//tr[${column}]//td[3][@class="statusinfo"]
    ${Result}=  Page Should Contain Element  //tr[${columns}]//td[3][@class="statusinfo"]
    log to console  ${Result}
    ${current_remarks}=  Run Keyword Unless  '${Result}'=='PASS'  Get Text    xpath=//tr[${columns}]
    ${current_remarks}=  Run Keyword Unless  '${Result}'=='FAIL'  Get Text    xpath=//tr[${column}]
    ${status_string}=    Get Location
    send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
    #Close Browser

TC 02
    Close Browser
