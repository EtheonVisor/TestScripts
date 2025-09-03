-- 機訊框功能的測試腳本，深受 UNC 的啟發；這是由 EtheonVisor 撰寫的
local function testMessageBox()
    local totalTests = 0
    local passedTests = 0
    local failedTests = 0
    local undefinedTests = 0
    
    local testCases = {
        {title = "Basic messagebox", message = "Hello from Krampus!", caption = "Test Message", type = 0},
        {title = "Information icon", message = "This is an information message", caption = "Info", type = 64},
        {title = "Warning icon", message = "This is a warning message", caption = "Warning", type = 48},
        {title = "Error icon", message = "This is an error message", caption = "Error", type = 16},
        {title = "Question icon", message = "This is a question message", caption = "Question", type = 32},
        {title = "OK/Cancel buttons", message = "OK and Cancel buttons", caption = "Buttons", type = 1},
        {title = "Yes/No buttons", message = "Yes and No buttons", caption = "Buttons", type = 4},
        {title = "Error with OK/Cancel", message = "Error with OK/Cancel buttons", caption = "Combination", type = 17},
        {title = "Warning with Yes/No", message = "Warning with Yes/No buttons", caption = "Combination", type = 52},
    }
    
    print("Testing messagebox functionality...")
    
    for _, testCase in ipairs(testCases) do
        totalTests += 1
        print("Testing: " .. testCase.title)
        
        local success, result = pcall(function()
            return messagebox(testCase.message, testCase.caption, testCase.type)
        end)
        
        if success then
            print("✅ PASS: " .. testCase.title .. " executed successfully")
            if result ~= nil then
                print("   Return value: " .. tostring(result))
            end
            passedTests += 1
        else
            print("❌ FAIL: " .. testCase.title .. " - " .. tostring(result))
            failedTests += 1
        end
        
        
        wait(0.5)
    end

    totalTests += 1
    if type(messagebox) == "function" then
        print("✅ PASS: messagebox function is defined")
        passedTests += 1
    else
        print("⛔ FAIL: messagebox function is undefined")
        undefinedTests += 1
        failedTests += 1
    end

    local successRate = math.floor((passedTests / totalTests) * 100 + 0.5)
  
    print("\n" .. string.rep("-", 50))
    print("MESSAGEBOX SUMMARY")
    print(string.rep("-", 50))
    print("✅ Tested with a " .. successRate .. "% success rate (" .. passedTests .. "/" .. totalTests .. ")")
    print("⛔ " .. failedTests .. " tests failed")
    print("⚠️ " .. undefinedTests .. " functions are undefined")
    print("📊 Total UI tests: " .. totalTests)
    print(string.rep("-", 50))
  print("Written by EtheonVisor")
    
    return successRate
end


local uiScore = testMessageBox()
print("Messagebox score: " .. uiScore .. "%")


local function comprehensiveMessageBoxTest()
    print("\nRunning comprehensive messagebox test...")
    

    local messageboxTypes = {
        {name = "MB_OK", value = 0},
        {name = "MB_OKCANCEL", value = 1},
        {name = "MB_ABORTRETRYIGNORE", value = 2},
        {name = "MB_YESNOCANCEL", value = 3},
        {name = "MB_YESNO", value = 4},
        {name = "MB_RETRYCANCEL", value = 5},
        {name = "MB_ICONERROR", value = 16},
        {name = "MB_ICONQUESTION", value = 32},
        {name = "MB_ICONWARNING", value = 48},
        {name = "MB_ICONINFORMATION", value = 64}
    }
    
    for _, mbType in ipairs(messageboxTypes) do
        print("Testing " .. mbType.name .. " (" .. mbType.value .. ")")
        pcall(messagebox, "Testing " .. mbType.name, "MessageBox Test", mbType.value)
        wait(0.3)
    end
end
