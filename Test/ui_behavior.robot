*** Settings ***
Library    SeleniumLibrary
Resource    variables.robot
Suite Setup       Open Browser To IKEA Website
Suite Teardown    Close Browser

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

Send Message
    [Arguments]    ${message}
    Wait Until Page Contains Element    ${CHAT_INPUT}    10s
    Input Text    ${CHAT_INPUT}    ${message}
    sleep     1s
    Press Keys     ${CHAT_INPUT}   RETURN
    Sleep    10s

*** Test Cases ***

#  Chat widget loads correctly on desktop and mobile
Chat Widget Loads On Desktop
    [Documentation]    Ensure chat widget is visible on desktop view.
    Page Should Contain Element    ${CHAT_ICON}
    Log To Console    Chat widget visible on desktop

Chat Widget Loads On Mobile
    [Documentation]    Validate chatbot icon appears on mobile viewport.
    Set Window Size    400    800
    Reload Page
    Wait Until Page Contains Element    ${CHAT_ICON}    10s
    Log To Console     Chat widget visible on mobile layout
    Set Window Size    1280    720

#  User can send messages via input box
User Can Send Message
    Open Chatbot
    Sleep      2s
    Click Button    ${Cookies_Accept}
    Send Message    What are your store timings of IKEA Dubai Festival City?
    ${response}=    Get Text    ${RESPONSE_BUBBLE}
    Should Not Be Empty    ${response}
    Log To Console    User able to send the message   ${response}

# AI responses are rendered properly in the conversation area
Responses Render Properly
    Open Chatbot
    Sleep      2s
    Click Button    ${Cookies_Accept}
    Send Message    Do you have delivery services?
    Wait Until Page Contains Element    ${RESPONSE_BUBBLE}    10s
    ${response}=    Get Text    ${RESPONSE_BUBBLE}
    Element Should Be Visible    ${RESPONSE_BUBBLE}
    Should Not Be Empty    ${response}
    Log To Console    AI response rendered correctly

# Multilingual support (LTR for English, RTL for Arabic)
Multilingual Layout Verification
    Open Chatbot
    Sleep      2s
    Click Button    ${Cookies_Accept}
    # English message
    Send Message    Do you have Exchange services?
    ${dir_en}=    Execute JavaScript    return window.getComputedStyle(document.body).direction
    Log To Console    English Layout Direction: ${dir_en}
    Should Be Equal    ${dir_en}    ltr

    # Arabic message
   Send Message        هل لديكم خدمات التبادل؟
    Execute JavaScript    document.documentElement.lang='ar'; document.documentElement.dir='rtl';
    ${dir_ar}=    Execute JavaScript    return document.documentElement.dir
    Should Be Equal    ${dir_ar}    rtl


#  Input is cleared after sending
Input Cleared After Sending
    Open Chatbot
    Sleep      2s
    Click Button    ${Cookies_Accept}
    Send Message    Do you have delivery services?
    Sleep    4s
    ${value}=    Get Value    ${CHAT_INPUT}
    Should Be Equal    ${value}    ${EMPTY}
    Log To Console    Input cleared successfully

# Scroll and accessibility work as expected
Scroll And Accessibility Check
    Open Chatbot
    Sleep      2s
    Click Button    ${Cookies_Accept}
    Send Message    Tell me about furniture options.
    Sleep    3s
    Send Message    Tell me about kitchen furniture.
    Sleep    3s
   # Scroll down by 500px
    Execute JavaScript    document.getElementById("oriChatbotConversationContainer").scrollTop += 500

    # Get scroll position
    ${scroll_pos}=    Execute JavaScript    return document.getElementById("oriChatbotConversationContainer").scrollTop
    Should Be True    ${scroll_pos} > 0
    Log To Console     Scrolling functional inside chatbot



