Set shell = CreateObject("WScript.Shell")

shell.Run "taskkill /IM firefox.exe", 0
shell.Run "taskkill /IM zebar.exe /F", 0
shell.Run "taskkill /IM wezterm-gui.exe /F", 0
shell.Run "taskkill /IM sublime_text.exe /F", 0
