*** Settings ***
Documentation    Suite description
Library     Selenium2Library
Library     MYSQlWrapper.py

*** Variables ***
${shipment_id}         default_circuit_id
${tmp_status}
${status_string}
${val}

*** Keywords ***
Get String
    [Arguments]  ${ROWS}
    ${string}=    Get Text    xpath=//table//tbody//tr[${ROWS}]//th
    : FOR    ${COUNTER}    IN RANGE    2    7
    \  ${catenate} =   Run Keyword If   """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 3 or ${COUNTER} == 4 and ${COUNTER} != 2
    \                  ...  Sleep    1s
    \                  ...  ELSE IF  """${string}""" != """Arrived""" and """${string}""" != """Arrival Scheduled"""
    \                  ...  Get Text    xpath=//table//tbody//tr[${ROWS}]//td[${COUNTER}]
    \                  ...  ELSE IF  """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 5
    \                  ...  Get Text    xpath=//table//tbody//tr[${ROWS}]//td[3]
    \                  ...  ELSE IF  """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 6
    \                  ...  Get Text    xpath=//table//tbody//tr[${ROWS}]//td[4]
    \                  ...  ELSE IF  """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 2
    \                  ...  Get Text    xpath=//table//tbody//tr[2]//td[${COUNTER}]
    \  ${tmp_status} =  Catenate   ${tmp_status}    ${catenate}
    \  ${tmp_status} =   Catenate   ${tmp_status}    \t
    [Return]  ${tmp_status}


Get Current Remarks
    [Arguments]  ${ROWS}
    ${string}=    Get Text    xpath=//table//tbody//tr[${ROWS}]//th
    : FOR    ${COUNTER}    IN RANGE    2    7
    \  ${catenate} =   Run Keyword If   """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 3 or ${COUNTER} == 4 and ${COUNTER} != 2
    \                  ...  Sleep    1s
    \                  ...  ELSE IF  """${string}""" != """Arrived""" and """${string}""" != """Arrival Scheduled"""
    \                  ...  Get Text    xpath=//table//tbody//tr[${ROWS}]//td[${COUNTER}]
    \                  ...  ELSE IF  """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 5
    \                  ...  Get Text    xpath=//table//tbody//tr[${ROWS}]//td[3]
    \                  ...  ELSE IF  """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 6
    \                  ...  Get Text    xpath=//table//tbody//tr[${ROWS}]//td[4]
    \                  ...  ELSE IF  """${string}""" == """Arrived""" or """${string}""" == """Arrival Scheduled""" and ${COUNTER} == 2
    \                  ...  Get Text    xpath=//table//tbody//tr[2]//td[${COUNTER}]
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
    Wait Until Element Is Visible  //h3[contains(text(),'Origin')]  timeout=30s
    ${HEADERS}=  Get Element Count    //table//tbody//tr//th
    ${status}=   Get Text    xpath=//table//tbody//tr[${HEADERS}]//th
    ${current_remarks}=  Get Current Remarks  ${HEADERS}
    ${HEADERS}=  Evaluate    ${HEADERS} + 1
    : FOR    ${INDEX}    IN RANGE    1  ${HEADERS}
    \  ${catenate} =  Get String  ${INDEX}
    \  ${status_string} =   Catenate   ${status_string}    ${catenate}
    \  ${status_string} =   Catenate   ${status_string}    \n
    \  ${catenate} =   Set variable   ${EMPTY}
    send to DB  ${shipment_id}  ${status}  ${current_remarks}  ${status_string}
    log to console   ${status}
    log to console   ${current_remarks}
    log to console   ${status_string}
    Close Browser
