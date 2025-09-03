--[[
    文件系统安全测试脚本
    作者: EtheonVisor
    描述: 此脚本专门测试执行器的文件系统安全功能，包括黑名单扩展名检查和路径遍历防护。
          通过尝试创建不同类型的文件来验证安全策略是否正常工作，确保恶意文件无法被创建。
    版本: 1.0
    最后更新: 2025 九月
Note: If you don't understand the script due to the chinese writtings please go to: https://raw.githubusercontent.com/EtheonVisor/TestScripts/refs/heads/main/BlackListedExtensionsTestEnglish.lua
]]

local function 测试黑名单扩展名()
    local 总测试数 = 0
    local 通过测试数 = 0
    local 失败测试数 = 0
    
    -- 定义黑名单扩展名测试用例
    local 黑名单扩展名 = {
        ".bat", ".cmd", ".vbs", ".js", ".ps1", 
        ".py", ".html", ".dll", ".exe", ".scr",
        ".msi", ".com", ".lnk", ".vbe", ".wsf"
    }
    
    -- 定义安全扩展名测试用例
    local 安全扩展名 = {
        ".txt", ".lua", ".json", ".xml", ".csv",
        ".md", ".log", ".cfg", ".ini", ".yml"
    }
    
    -- 定义路径遍历测试用例
    local 路径遍历测试 = {
        "../test.txt",
        "..\\test.txt",
        "folder/../../test.txt",
        "folder\\..\\..\\test.txt",
        "../敏感文件.bat",
        "..\\系统文件.dll"
    }
    
    print("开始执行文件系统安全测试...")
    print("正在测试黑名单扩展名防护...")
    
    -- 测试黑名单扩展名 (应被阻止)
    for _, 扩展名 in ipairs(黑名单扩展名) do
        总测试数 = 总测试数 + 1
        local 文件名 = "测试文件" .. 扩展名
        print("测试中: " .. 文件名)
        
        local 成功, 结果 = pcall(function()
            writefile(文件名, "Hello! 这是一个测试文件。")
        end)
        
        if 成功 then
            print("❌ 失败: " .. 文件名 .. " 被意外允许创建")
            失败测试数 = 失败测试数 + 1
            -- 清理已创建的文件
            pcall(function() delfile(文件名) end)
        else
            print("✅ 通过: " .. 文件名 .. " 已被正确阻止")
            通过测试数 = 通过测试数 + 1
        end
    end
    
    -- 测试安全扩展名 (应被允许)
    for _, 扩展名 in ipairs(安全扩展名) do
        总测试数 = 总测试数 + 1
        local 文件名 = "测试文件" .. 扩展名
        print("测试中: " .. 文件名)
        
        local 成功, 结果 = pcall(function()
            writefile(文件名, "Hello! 这是一个安全测试文件。")
        end)
        
        if 成功 then
            print("✅ 通过: " .. 文件名 .. " 已成功创建")
            通过测试数 = 通过测试数 + 1
            -- 清理测试文件
            pcall(function() delfile(文件名) end)
        else
            print("❌ 失败: " .. 文件名 .. " 被意外阻止: " .. tostring(结果))
            失败测试数 = 失败测试数 + 1
        end
    end
    
    -- 测试路径遍历尝试 (应被阻止)
    print("正在测试路径遍历防护...")
    for _, 路径 in ipairs(路径遍历测试) do
        总测试数 = 总测试数 + 1
        print("测试路径: " .. 路径)
        
        local 成功, 结果 = pcall(function()
            writefile(路径, "Hello! 这是一个路径遍历测试文件。")
        end)
        
        if 成功 then
            print("❌ 失败: 路径遍历被允许: " .. 路径)
            失败测试数 = 失败测试数 + 1
            -- 清理测试文件
            pcall(function() delfile(路径) end)
        else
            print("✅ 通过: 路径遍历已被正确阻止")
            通过测试数 = 通过测试数 + 1
        end
    end
    
    -- 计算成功率
    local 成功率 = 总测试数 > 0 and math.floor((通过测试数 / 总测试数) * 100 + 0.5) or 0
    
    -- 打印专业测试报告
    print("\n" .. string.rep("=", 60))
    print("文件系统安全测试报告")
    print(string.rep("=", 60))
    print("测试执行者: EtheonVisor")
    print("测试时间: " .. os.date("%Y-%m-%d %H:%M:%S"))
    print(string.rep("-", 60))
    print("✅ 测试通过率: " .. 成功率 .. "% (" .. 通过测试数 .. "/" .. 总测试数 .. ")")
    print("⛔ 失败测试数: " .. 失败测试数)
    print("📊 总测试用例: " .. 总测试数)
    print(string.rep("-", 60))
    print("测试详情:")
    print("  - 黑名单扩展名测试: " .. #黑名单扩展名 .. " 项")
    print("  - 安全扩展名测试: " .. #安全扩展名 .. " 项")
    print("  - 路径遍历测试: " .. #路径遍历测试 .. " 项")
    print(string.rep("=", 60))
    
    -- 提供安全评估
    if 成功率 >= 90 then
        print("安全评估: 🛡️ 优秀 - 文件系统安全防护工作正常")
    elseif 成功率 >= 70 then
        print("安全评估: ⚠️ 良好 - 文件系统安全防护基本正常")
    else
        print("安全评估: 🔴 不足 - 文件系统存在安全风险")
    end
    
    return 成功率
end

-- 执行测试
local 安全评分 = 测试黑名单扩展名()
print("安全评分: " .. 安全评分 .. "%")

-- 提供额外建议
if 安全评分 < 100 then
    print("\n建议: 检查文件系统安全策略，确保所有潜在危险扩展名均被正确阻止。")
end

print("\n文件系统安全测试执行完毕。")
