tell application "Google Chrome"
    activate
    open location "https://dmc.divvy.co/db"
    delay 1
    activate
    -- you'll need to go to View > Developer > Allow JavaScript from Apple Events. See: support.google.com/chrome/?p=applescript – Leland
    execute front window's active tab javascript "document.querySelectorAll('[alt=\"DEEP_IMPACT-PRD-Readonly-Database-Creds\"]')[0].click();"
    delay 1
end tell
activate application "Postico"
tell application "System Events" to tell process "Postico"
    delay 1
    click button "New Favorite" of window 1
    delay 1
    keystroke return
    delay 1
    click button "Connect" of last group of sheet 1 of front window
end tell
