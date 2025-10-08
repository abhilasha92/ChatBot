*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://www.ikea.com/ae/en/
${BROWSER}            chrome

# Chat elements (approximate - update after inspection)
${CHAT_ICON}          xpath=//*[@id="oriDefaultTrigger"]/img
${CHAT_IFRAME}        xpath=//*[@id="chatbotContentContainer"]
${CHAT_INPUT}         xpath=//*[@id="chatbotContentContainer"]/div[4]/div/textarea
${SEND_KEY}           RETURN
${RESPONSE_BUBBLE}    xpath=//*[@class="ori-animated ori-fade-in"][3]
${CONVERSATION_AREA}  xpath=//div[@id='oriChatbotConversationContainer']
${Cookies_Accept}     xpath=//*[@id="onetrust-accept-btn-handler"]

*** Keywords ***
Open Browser To IKEA Website
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${CHAT_ICON}    15s
    Log To Console     IKEA homepage loaded successfully

Open Chatbot
    Click Element    ${CHAT_ICON}
    Sleep    5s
    Wait Until Page Contains Element    ${CHAT_IFRAME}    15s
    Log To Console    Chatbot opened inside iframe

Send Message And Wait Response
    [Arguments]    ${message}
    Open Chatbot
    Wait Until Page Contains Element    ${CHAT_INPUT}    10s
    Input Text    ${CHAT_INPUT}    ${message}
    Press Keys     ${CHAT_INPUT}    ${SEND_KEY}
    Wait Until Page Contains Element    ${RESPONSE_BUBBLE}    15s
    ${response}=    Get Text    ${RESPONSE_BUBBLE}
    [Return]    ${response}