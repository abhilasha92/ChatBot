*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Library    Chatbot_Test/resource/custom_keyword.py
Resource    variables.robot
Resource    ui_behavior.robot

Suite Setup       Open Browser To IKEA Website
Suite Teardown    Close Browser

*** Keywords ***

send arabic message
    [Arguments]    ${message}
    Wait Until Page Contains Element    ${CHAT_INPUT}    10s
    Input Text    ${CHAT_INPUT}    ${message}
    Press Keys     ${CHAT_INPUT}    ${SEND_KEY}
    Wait Until Page Contains Element    ${RESPONSE_BUBBLE}    15s
    ${response}=    Get Text    ${RESPONSE_BUBBLE}
    [Return]    ${response}
*** Test Cases ***

# AI provides clear and helpful responses
Validate Helpfulness Of English Response
    #Open Chatbot
    #Sleep      2s
    ${data}=    Load JSON From File        Chatbot_Test/Data/test_data.json
    ${prompt}=    Get Value From JSON    ${data}    $.en[0].prompt
    ${keywords}=  Get Value From JSON    ${data}    $.en[0].expected_keywords
    ${expected}=  Get Value From JSON    ${data}    $.en[0].expected_behavior
    Click Button    ${Cookies_Accept}
    ${response}=    Send Message And Wait Response    ${prompt}
    Sleep    7s
    Validate Semantic Similarity           ${response}    ${expected}
    Log To Console    ✅ Helpful AI response validated

# Responses are not hallucinated / irrelevant
No Hallucination Check
    Click Button    ${Cookies_Accept}
    ${response}=    Send Message And Wait Response    hii ,are you hungary ?
    Sleep    5s
    Should Contain Any          ${response}    Hello! I'm here to assist with any IKEA-related questions or provide information on IKEA products and services. How may I help you today?
    Log To Console    ✅ AI avoided hallucinated answer

#  Responses stay consistent for English & Arabic
Response Consistency EN-AR
    ${data}=    Load JSON From File        Chatbot_Test/Data/test_data.json
    ${prompt_en}=    Get Value From JSON    ${data}    $.en[1].prompt
    ${prompt_ar}=    Get Value From JSON    ${data}    $.ar[1].prompt
    Click Button    ${Cookies_Accept}
    ${response_en}=    Send Message And Wait Response    ${prompt_en}
    Sleep    5s
    ${response_ar}=    send arabic message    ${prompt_ar}
    sleep     5s
    Validate Semantic Similarity           ${response_en}    ${response_ar}
    Log To Console    ✅ English and Arabic responses consistent




