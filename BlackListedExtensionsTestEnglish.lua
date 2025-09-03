--[[
File System Security Test Script
Author: EtheonVisor
Description: This script is designed to test the file system security features of an executor,
including blacklist extension checks and path traversal protection.
It verifies whether malicious files can be created by attempting to create files with
different extensions and paths to ensure the security policies are working correctly.
Version: 1.0
Last Updated: 2025

Some english might be wrong.
]]

local function testFileSystemSecurity()
    local totalTests = 0
    local passedTests = 0
    local failedTests = 0

    -- Define blacklist extension test cases
    local blacklistExtensions = {
        ".bat", ".cmd", ".vbs", ".js", ".ps1",
        ".py", ".html", ".dll", ".exe", ".scr",
        ".msi", ".com", ".lnk", ".vbe", ".wsf"
    }

    -- Define safe extension test cases
    local safeExtensions = {
        ".txt", ".lua", ".json", ".xml", ".csv",
        ".md", ".log", ".cfg", ".ini", ".yml"
    }

    -- Define path traversal test cases
    local pathTraversalTests = {
        "../test.txt",
        "..\\test.txt",
        "folder/../../test.txt",
        "folder\\..\\..\\test.txt",
        "../sensitive_file.bat",
        "..\\system_file.dll"
    }

    print("Starting file system security tests...")
    print("Testing blacklist extension protection...")

    -- Test blacklist extensions (should be blocked)
    for _, ext in ipairs(blacklistExtensions) do
        totalTests = totalTests + 1
        local filename = "test_file" .. ext
        print("Testing: " .. filename)

        local success, result = pcall(function()
            writefile(filename, "Hello! This is a test file.")
        end)

        if success then
            print("❌ Failed: " .. filename .. " was unexpectedly allowed to be created")
            failedTests = failedTests + 1
            -- Clean up created file
            pcall(function() delfile(filename) end)
        else
            print("✅ Passed: " .. filename .. " was correctly blocked")
            passedTests = passedTests + 1
        end
    end

    -- Test safe extensions (should be allowed)
    for _, ext in ipairs(safeExtensions) do
        totalTests = totalTests + 1
        local filename = "test_file" .. ext
        print("Testing: " .. filename)

        local success, result = pcall(function()
            writefile(filename, "Hello! This is a safe test file.")
        end)

        if success then
            print("✅ Passed: " .. filename .. " was successfully created")
            passedTests = passedTests + 1
            -- Clean up test file
            pcall(function() delfile(filename) end)
        else
            print("❌ Failed: " .. filename .. " was unexpectedly blocked: " .. tostring(result))
            failedTests = failedTests + 1
        end
    end

    -- Test path traversal attempts (should be blocked)
    print("Testing path traversal protection...")
    for _, path in ipairs(pathTraversalTests) do
        totalTests = totalTests + 1
        print("Testing path: " .. path)

        local success, result = pcall(function()
            writefile(path, "Hello! This is a path traversal test file.")
        end)

        if success then
            print("❌ Failed: Path traversal was allowed: " .. path)
            failedTests = failedTests + 1
            -- Clean up test file
            pcall(function() delfile(path) end)
        else
            print("✅ Passed: Path traversal was correctly blocked")
            passedTests = passedTests + 1
        end
    end

    -- Calculate success rate
    local successRate = totalTests > 0 and math.floor((passedTests / totalTests) * 100 + 0.5) or 0

    -- Print professional test report
    print("\n" .. string.rep("-", 60))
    print("File System Security Test Report")
    print(string.rep("-", 60))
    print("Tester: EtheonVisor")
    print("Test Time: " .. os.date("%Y-%m-%d %H:%M:%S"))
    print(string.rep("-", 60))
    print("✅ Success Rate: " .. successRate .. "% (" .. passedTests .. "/" .. totalTests .. ")")
    print("⛔ Failed Tests: " .. failedTests)
    print("📊 Total Test Cases: " .. totalTests)
    print(string.rep("-", 60))
    print("Test Details:")
    print(" - Blacklist extension tests: " .. #blacklistExtensions)
    print(" - Safe extension tests: " .. #safeExtensions)
    print(" - Path traversal tests: " .. #pathTraversalTests)
    print(string.rep("-", 60))

    -- Provide security assessment
    if successRate >= 90 then
        print("Security Assessment: 🛡️ Excellent - File system security protection is working properly")
    elseif successRate >= 70 then
        print("Security Assessment: ⚠️ Good - File system security protection is mostly working")
    else
        print("Security Assessment: 🔴 Poor - File system security has vulnerabilities")
    end

    return successRate
end

-- Run the test
local securityScore = testFileSystemSecurity()
print("Security Score: " .. securityScore .. "%")

-- Provide additional suggestions
if securityScore < 100 then
    print("\nSuggestion: Review the file system security policy to ensure all potentially dangerous extensions are correctly blocked.")
end

print("\nFile system security testing completed.")
