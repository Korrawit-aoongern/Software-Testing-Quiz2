*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser

*** Variables ***
${LOGIN_URL}          https://chiangmuan.igovapp.com/login
${BROWSER}            headlesschrome

${EMAIL_INPUT}        //*[@id="login_email"]
${PASSWORD_INPUT}     //*[@id="login_password"]
${LOGIN_BUTTON}       //*[@id="page-login"]/div/main/div[2]/div/section[1]/div[2]/form/div/div[2]/button
${LOGIN_TEXT_DEFAULT}    Login
${LOGIN_TEXT_INVALID}    Invalid Login. Try again.
${SHOW_PASSWORD_BTN}  //*[@id="page-login"]/div/main/div[2]/div/section[1]/div[2]/form/div/div[1]/div[2]/div/span
${SIGNUP_LINK}        //*[@id="page-login"]/div/main/div[2]/div/section[1]/div[3]/a
${FORGOT_LINK}        //*[@id="page-login"]/div/main/div[2]/div/section[1]/div[2]/form/div/div[1]/p/a
${ERROR_MESSAGE}      css=.error-message

${VALID_EMAIL}        jane@example.com
${VALID_PASSWORD}     Password123
${INVALID_PASSWORD}   Wrong123

${LINE_LOGIN_BTN}     //*[@id="page-login"]/div/main/div[2]/div/section[1]/div[2]/form/div/div[3]/div/div/a
${LINE_FORGOT_LINK}   //*[@id="app"]/div/div/div/div[2]/div/div[3]/button

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window

Input Email
    [Arguments]    ${email}
    Input Text     ${EMAIL_INPUT}    ${email}

Input Password
    [Arguments]    ${password}
    Input Text     ${PASSWORD_INPUT}    ${password}

Click Login
    Click Button   ${LOGIN_BUTTON}

Login Should Be Successful
    Page Should Contain    ยินดีต้อนรับ

Login Should Fail
    Page Should Contain Element    ${ERROR_MESSAGE}

Login Button Should Show Invalid Message
    Element Text Should Be    ${LOGIN_BUTTON}    ${LOGIN_TEXT_INVALID}

Login Button Should Show Default Text
    Element Text Should Be    ${LOGIN_BUTTON}    ${LOGIN_TEXT_DEFAULT}

Page Should Still Be Login Page
    Location Should Be    ${LOGIN_URL}

Email Field Should Be Invalid
    Execute JavaScript
    ...    return document.getElementById('email').validity.valueMissing;

*** Test Cases ***
F01.1TC1 Login With Valid Email And Password
    Input Email       ${VALID_EMAIL}
    Input Password    ${VALID_PASSWORD}
    Click Login
    Login Should Be Successful

F01.1TC2 Login With Invalid Password
    Input Email       ${VALID_EMAIL}
    Input Password    ${INVALID_PASSWORD}
    Click Login
    Login Button Should Show Invalid Message

F01.1TC3 Login With Unregistered Email
    Input Email       unknown@test.com
    Input Password    ${VALID_PASSWORD}
    Click Login
    Login Button Should Show Invalid Message

F01.1TC4 Login With Empty Email And Password
    Click Login
    Email Field Should Be Invalid
    Page Should Still Be Login Page




F01.2TC1 Show Password
    Input Password    ${VALID_PASSWORD}
    Click Element     ${SHOW_PASSWORD_BTN}
    Element Attribute Value Should Be    ${PASSWORD_INPUT}    type    text

F01.2TC2 Hide Password
    Click Element     ${SHOW_PASSWORD_BTN}
    Element Attribute Value Should Be    ${PASSWORD_INPUT}    type    password

F01.2TC3 Navigate To Sign Up Page
    Click Link        ${SIGNUP_LINK}
    Page Should Contain    Sign Up




F01.3TC1 Forgot Password With Registered Email
    Click Link        ${FORGOT_LINK}
    Input Text        ${EMAIL_INPUT}    ${VALID_EMAIL}
    Click Button      Submit
    Page Should Contain    Reset email sent

F01.3TC2 Forgot Password With Unregistered Email
    Click Link        ${FORGOT_LINK}
    Input Text        ${EMAIL_INPUT}    unknown@test.com
    Click Button      Submit
    Page Should Contain Element    ${ERROR_MESSAGE}





F01.4TC1 Login With LINE Email And Password
    Click Element     ${LINE_LOGIN_BTN}
    Page Should Contain    LINE Login

F01.4TC2 Login With LINE QR Code
    Click Element     ${LINE_LOGIN_BTN}
    Page Should Contain    QR Code

F01.4TC3 LINE Forgot Email Or Password
    Click Element     ${LINE_LOGIN_BTN}
    Click Link        ${LINE_FORGOT_LINK}
    Page Should Contain    LINE Help
