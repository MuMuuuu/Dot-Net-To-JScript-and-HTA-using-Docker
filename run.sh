#!/bin/bash

rm /app/DotNetToJScript/ExampleAssembly/TestClass.cs
cp /app/ExampleAssembly/TestClass.cs /app/DotNetToJScript/ExampleAssembly/TestClass.cs

# 重新編譯 ExampleAssembly
cd /app/DotNetToJScript/ExampleAssembly
xbuild /p:Configuration=Release

# 執行 DotNetToJScript
cd /app
mono ./DotNetToJScript/DotNetToJScript/bin/Release/DotNetToJScript.exe ./DotNetToJScript/ExampleAssembly/bin/Release/ExampleAssembly.dll --lang=Jscript --ver=v4 -o demo.js

mkdir -p /app/ExampleAssembly/output
tr -d '\r' < demo.js > /app/ExampleAssembly/output/demo.js

echo "Output output/demo.js"

# 讀取 demo.js 的內容
content=$(</app/ExampleAssembly/output/demo.js)

# 將內容放入 template.hta 中的 {{template}} 位置
output=$(awk -v c="$content" '{gsub("{{template}}",c)}1' /app/ExampleAssembly/template.hta)

# 將結果輸出到 demo.hta 檔案中
echo "$output" > /app/ExampleAssembly/output/demo.hta
echo "Output output/demo.hta"
