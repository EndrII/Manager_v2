import QtQuick 2.12
import QtQuick.Window 2.12
// import qt quick controls & layouts
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12
// import some text field styles
import QtQuick.Controls.Styles 1.3
// import Qt Quick Dialogs
import QtQuick.Dialogs 1.2


ApplicationWindow {
    id: rootElementId
    visible: true
    width: 1024
    height: 720
    title: qsTr("Bienvenue au Linux Manager Utilitaire")
    // Add the Menu Bar for all items regarding Manager Application
    //
    menuBar: MenuBar {
        // change default color of MenuBar
        background: Rectangle {
            color: "lightgray"
        }
        Menu {
            title: "&Help"
            Action {
                id: aboutManagerId
                text: qsTr("Manager &Help")
                icon.source: "/aboutManager.png"
                icon.color: "transparent"
                onTriggered: {
                    console.log("About Manager Appl Action was triggered ...")
                    aboutManagerDialogId.open()
                }
            }
            Action {
                id: aboutAuthorId
                text: "About &Author"
                icon.source: "/aboutAuthor.png"
                icon.color: "transparent"
                onTriggered: {
                    console.log("About Author Action was triggered ...")
                }
            }
        }
        // Window Manager App MenuBar & respective Actions :
        // [1] Change Manager background color & [2] Quit Manager Application
        //
        Menu {
            title: qsTr("&Window")
            width: 200
            Action {
                id: changeColorActionId
                text: qsTr("Change Manager &Color")
                icon.source: "/backColor.png"
                icon.color: "transparent"
                onTriggered: {
                    // open ColorDialog to choose a color
                    colorDialogId.open()
                }
            }
            MenuSeparator {}
            Action {
                id: quitManagerAppId
                text: qsTr("Quit &Manager")
                icon.source: "/exit.png"
                icon.color: "transparent"
                onTriggered: {
                    console.log("Quit Action was triggered ...")
                    quitManagerDialogId.open()
                }
            }
        }
    }
    // A popUp Message Dialog in order to choose YES | NO upon quit action from Manager Application
    //
    MessageDialog {
        id: quitManagerDialogId
        title: "Quit Manager Application ?"
        text: "Are you sure you want to exit Manager?"
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            console.log("Quit MessageDialog accepted ...")
            Qt.quit()
        }
        onRejected: {
            console.log("Quit MessageDialog rejected ...")
        }
    }

    // Dialog to open when About Manager Action is chosen
    //
    Dialog {
        id: aboutManagerDialogId

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: Math.min(parent.width, parent.height) / 3 * 2
        ////contentHeight: parent.height/2 // This doesn't cause the binding loop.
        ////parent: Overlay.overlay

        ////modal: true
        title: "About Manager"
        standardButtons: Dialog.Close

        Column {
            id: column
            spacing: 20
            width: rootElementId.width/3*2
            height: rootElementId.height

            Image {
                id: logo
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                source: "/manager.png"
            }

            Label {
                width: parent.width
                text: "This is a Qt Quick Linux Application that helps user create, remove or rename "
                      + "a user in Linux Desktop. Enter current user username and type password two "
                      + "times just for confirmation. Then, enter 'Submit' Button in order to continue. "
                      + "Username and password fields can be cleared by switching the 'Clear' switch to the right. "
                      + "Linux Manager Application also gives user the ability to add or remove a group from "
                      + "its Linux Desktop. Last, but not least the user can check various information regarding "
                      + "its Linux Desktop, like for example current real users, real groups, Firewall configuration "
                      + "tables [Filter | RAW | Security | Mangle] can be printed out and see the applied rules for traffic. "
                      + "Furthermore, Routing table and Network Interfaces can be checked out. \n\t\tHave fun!"
                wrapMode: Label.Wrap
            }
        }
    }

    // A color dialog to choose Manager Application background color
    //
    ColorDialog {
        id: colorDialogId
        title: "Choose Manager Application background color"
        visible: false
        onAccepted: {
            // choose a color opening systems default application
            managerBackgroundColorId.color = colorDialogId.color
            console.log("User has just selected Manager background color to: " + colorDialogId.color)
        }
        onRejected: {
            console.log("ColorDialog is rejected, color remains the same ...")
        }
    }

    // Add the ToolBar Actions regarding Manager Application
    //
    header: ToolBar {
        Row {
            anchors.fill: parent
            ToolButton {
                action: aboutManagerId
            }
            ToolButton {
                action: aboutAuthorId
            }
            ToolButton {
                action: quitManagerAppId
            }
        }
    }

    // change the background color of application window using a rectangle
    //
    background: Rectangle {
        id: managerBackgroundColorId
        color: "lightblue"
    }
    font: {font.family="Arial"; font.pointSize=9;}

    // quit() with ESC
    //
    Item {
        id: quitItemId
        // Attention: without focus property enabled it is not going to work!!!
        //
        focus: true
        Keys.onPressed: {
            if(event.key === Qt.Key_Escape) {
                console.log("Escape key is pressed ... quit() is called upon app ... ciao !!!")
                Qt.quit()
            }
        }
    }

    // Declare three global vars for username, pass(1) and pass(2)
    //
    property string username: ""
    property string passwd_une: ""
    property string passwd_deux: ""
    // Declare variables for the new user that is about to be created
    //
    property string new_username: ""
    property string new_user_realname: ""
    property string new_user_group: ""
    property string new_user_id: ""
    property string new_user_shell: ""
    property string new_user_encr_password: ""

    GroupBox {
        x: 5; y: 5
        title: qsTr("Credentials")
        id: credsGroupBoxId
        font.bold: true
        // this groupbox refers to operator credentials, i.e. username/password
        // and a submit button in order to store these values
        //
        Column {
            // Row element container for username fields
            //
            Row {
                id: usernameRowId
                spacing: 10
                width: 300
                bottomPadding: 5
                // A label for username
                Label {
                    text: "Type username            : "
                    id: usernameLabelId
                    color: "gray"
                }

                // A text field to enter operator's username
                TextField {
                    id:usernameTextFieldId
                    width: 100
                    placeholderText: "username"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Please type your username")

                    echoMode: TextInput.Normal
                    font: Qt.font({family: "Helvetica", pointSize: 9, italic: true})
                    onEditingFinished: {
                        username = text
                        console.log("username: " + username)
                    }
                    // remove border color from the text field
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 20
                        border.color: "transparent"
                    }
                }
            }
            // Row element containing password fields #1st time
            //
            Row {
                id: passwdUneRowId
                spacing: 10
                width: 300
                bottomPadding: 5
                // A label for password
                Label {
                    text: "Type password            : "
                    id: passwordLabel1Id
                    color: "gray"
                }
                // A text field to enter operator's password | time #1
                TextField {
                    id: passwordTextField1Id
                    placeholderText: "password"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Please type your password")

                    // password should not be visible when typed
                    echoMode: TextInput.Password
                    font: Qt.font({family: "Helvetica", pointSize: 9, italic: true})
                    onEditingFinished: {
                        passwd_une = text
                    }
                    // remove border color from the text field
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 20
                        border.color: "transparent"
                    }
                }
            }
            // Row element containing password fields #2nd time
            Row {
                //
                id: passwdDeuxRowId
                spacing: 10
                width: 300
                bottomPadding: 5
                // A label for password re-entry
                Label {
                    text: "Retype password        : "
                    id: passwordLabel2Id
                    color: "gray"
                }
                // A text field to enter operator's password | time #2
                TextField {
                    id: passwordTextField2Id
                    placeholderText: "password"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Please type your password again")

                    // password should not be visible when typed
                    echoMode: TextInput.Password
                    font: Qt.font({family: "Helvetica", pointSize: 9, italic: true})
                    onEditingFinished: {
                        passwd_deux = text
                    }
                    // remove border color from the text field
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 20
                        border.color: "transparent"
                    }
                }
            }
            // A Row containing CheckBox | when checked passwords become visible
            //
            Row {
                spacing: 10
                width: 200
                bottomPadding: 10
                CheckBox {
                    id: showPasswdsCheckBoxId
                    checked: false
                    text: qsTr("Show passwords")
                    // when this checkBos is checked --> make passwords text fields visible
                    //
                    onClicked: {
                        if(checked===true) {
                            // make password #1/2 textInput field visible
                            passwordTextField1Id.echoMode = TextInput.Normal
                            passwordTextField2Id.echoMode = TextInput.Normal
                        } else {
                            // make password #1/2 textInput field invisible
                            passwordTextField1Id.echoMode = TextInput.Password
                            passwordTextField2Id.echoMode = TextInput.Password
                        }
                    }
                }
            }

            // A DelayButton to 'Submit' operator's username and password
            // Should only be accepted IF and only IF password===retypeOfPassword
            /// and username === getenv("USER")
            Row {
                spacing: 10
                width: 300
                bottomPadding: 10
                DelayButton {
                    id: submitButtonId
                    property bool activated: false
                    // When the 'Submit' Button is pressed for '1.5' seconds, then it is activated and going on ...
                    delay: 1500
                    text: "Submit Credentials"
                    onActivated: {
                        activated = true
                    }
                    onPressed: {
                        if(activated === true) {
                            // TODO: Remove it at the end of this Manager Application
                            // test to see how can i call a c++ function from my QML UI code
                            ///////////////////////////////////
                            //console.log("-->> " + myManager.sayHello("Dimos Kacimardos | called c++ from QML ... nice ..."))

                            //console.log("password#1: " + passwd_une + " || password#2: " + passwd_deux)
                            if(passwd_une === "" || passwd_deux === "" || username === "") {
                                console.log("Please provide username, type your password and retype it again to continue ...")
                            } else {

                                if(passwd_une !== passwd_deux) {
                                    console.log("Passwords do not match ... Please try again ... ")
                                } else {
                                    console.log("Passwords match ... Seems to be ok ... Continue procedure ...")
                                    // pass entered username from the TextField to my C++ code
                                    //
                                    myManager.setUsername(username)
                                    // Same for password
                                    //
                                    myManager.setPassword(passwd_une)
                                    // Last action -> compare current username into system with the entered username in the TextField
                                    //
                                    if(myManager.compare_usernames() === false) {
                                        console.log("ERROR: It seems user: " + username + " is not the currently logged user ... Please specify correct user!")
                                        // If username is fake -> then swipe switch to the right and clean up text fields
                                        clearSwitchId.checked = true
                                        clearSwitchId.checked = false
                                    }
                                }
                            }
                        }
                    }
                    // align 'Submit' button in the center of the last Row
                    //
                    anchors.horizontalCenter: Qt.AlignHCenter
                    opacity: .75
                }
            }

            // Create a Switch to Clear Credentials Fields if the operator wants to
            //
            Switch {
                id: clearSwitchId
                text: "Clear Fields"
                checked: false
                onCheckedChanged: {
                    if(checked === true) {
                        usernameTextFieldId.text = ""
                        passwordTextField1Id.text = ""
                        passwordTextField2Id.text = ""
                        console.log("Just cleared username and password fields up ... from QML code")
                        // Call c++ function that cleans up username/password Qstring variables
                        //
                        myManager.clearCredentials()
                    }
                }
            }


        }
    }

    /*                        END OF Credentials GroupBox                   */
    GroupBox {
        id: userMgmntId
        title: "User Management"
        font: Qt.font({family: "Helvetica", pointSize: 9, italic: true, bold: true})
        spacing: 5
        anchors.top: credsGroupBoxId.bottom
        width: credsGroupBoxId.width
        height: 400
        x: 5
        ColumnLayout {
            id: userMgmntColumnId
            Row {
                width: parent.width
                bottomPadding: 10
                // new user username Column
                // label & TextField
                Label {
                    text: "User Name          "
                    id: newUsernameLabelId
                }
                TextField {
                    id: newUsernameTextFieldId
                    width: userMgmntId.width - newUsernameLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "      new user username"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created username")
                    onEditingFinished: {
                        new_username = newUsernameTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user real name Column
                // label & TextField
                Label {
                    text: "User Real Name     "
                    id: newUserRealnameLabelId
                }
                TextField {
                    id: newUserRealnameTextFieldId
                    width: userMgmntId.width - newUserRealnameLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "  new user real name"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created real name")
                    onEditingFinished: {
                        new_user_realname = newUserRealnameTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user group Column
                // label & TextField
                Label {
                    text: "User Group Name    "
                    id: newUserGroupLabelId
                }
                TextField {
                    id: newUserGroupTextFieldId
                    width: userMgmntId.width - newUserGroupLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "new user's group"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created group")
                    onEditingFinished: {
                        new_user_group = newUserGroupTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user ID Column
                // label & TextField
                Label {
                    text: "User ID            "
                    id: newUserIDLabelId
                }
                TextField {
                    id: newUserIDTextFieldId
                    width: userMgmntId.width - newUserIDLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "          new user's ID"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created ID")
                    onEditingFinished: {
                        new_user_id = newUserIDTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user Shell Column
                // label & TextField
                Label {
                    text: "User Shell         "
                    id: newUserShellLabelId
                }
                TextField {
                    id: newUserShellTextFieldId
                    width: userMgmntId.width - newUserShellLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "        new user's shell"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created shell")
                    onEditingFinished: {
                        new_user_shell = newUserShellTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user Password label & TextField
                //
                Label {
                    text: "User Password     "
                    id: newUserPasswordLabelId
                }
                TextField {
                    id: newUserPasswordTextFieldId
                    width: userMgmntId.width - newUserPasswordLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    echoMode: TextInput.Password
                    placeholderText: "    new user's password"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created password")
                    onEditingFinished: {
                        new_user_encr_password = newUserPasswordTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // Show passwords CheckBox Column
                Switch {
                    id: showNewUserPasswdsSwitchId
                    text: "Show Password"
                    checked: false
                    onCheckedChanged: {
                        if(checked === true) {
                            newUserPasswordTextFieldId.echoMode = TextInput.Normal
                        } else {
                            newUserPasswordTextFieldId.echoMode = TextInput.Password
                        }
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // Clear all User Management Fields
                Switch {
                    id: clearUserMgmntSwitchId
                    text: qsTr("Clear User Management Text Fields")
                    checked: false
                    onCheckedChanged: {
                        if(checked === true) {
                            newUsernameTextFieldId.text = ""
                            newUserGroupTextFieldId.text = ""
                            newUserRealnameTextFieldId.text = ""
                            newUserIDTextFieldId.text = ""
                            newUserShellTextFieldId.text = ""
                            newUserPasswordTextFieldId.text = ""
                        }
                    }
                }
            }

            Row {
                bottomPadding: 10
                width: parent.width
                // new user Confirm CheckBox Column
                CheckBox {
                    text: "Confirm above elements"
                    checked: false
                    // when clicked, check if username or password of the new user is empty !
                    // IF empty , do not proceed
                    onClicked: {
                        if(checked === true) {
                            if(new_username === "" || new_user_encr_password === "") {
                                console.log("New user to be created username and password should be both specified! Please enter them and try again!")
                            } else {
                                // call c++ code to pass string values from QML elements (TExtFieds) to c++ QString variables
                                // uername - real name (comment) - group - ID - user shell - password
                                //
                                myManager.setNew_username(new_username)
                                myManager.setNew_user_realname(new_user_realname)
                                myManager.setNew_user_group(new_user_group)
                                myManager.setNew_user_id(new_user_id)
                                myManager.setNew_user_shell(new_user_shell)
                                myManager.setNew_user_encr_password(new_user_encr_password)
                            }
                        }
                    }
                }
            }
            Row {
                bottomPadding: 10
                width: parent.width
                // new user 'CREATE' PushButton && 'REMOVE' DelayButton Row
                RowLayout {
                    Button {
                        id: createNewUserButtonId
                        text: qsTr("CREATE")
                        onClicked: {
                            if(myManager.is_username_valid() === true) {
                                console.log("Username: " + new_username + " is a valid one ... Continue procedure ... ")
                            } else {
                                console.log("Invalid username ... Aborting ...")
                            }
                        }
                    }
                    DelayButton {
                        id: removeUserDelayButtonId
                        text: qsTr("REMOVE")
                        anchors.left: parent.right
                    }
                }
            }
        }
    }
}
