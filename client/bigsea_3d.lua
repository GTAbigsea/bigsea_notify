local notifys = {}  -- 通知列表

-- 生成通知ID
function GenerateId()
    local id = GetGameTimer() .. math.random(1000, 9999)
    return id
end

-- 创建帮助通知
function CreateHelp(key, text)
    if not key then
        return
    end

    local id = GenerateId()

    -- 添加通知到列表
    table.insert(notifys, {
        id = id,
        key = key,
        text = text
    })

    -- 发送创建通知的消息给前端
    SendNUIMessage({
        action = "CreateHelp",
        id = id,
        text = text,
        key = key
    })

    return id
end

-- 更新帮助通知
function UpdateHelp(id, key, text)
    for i = 1, #notifys do
        if notifys[i].id == id then
            notifys[i].key = key
            notifys[i].text = text
            break
        end
    end

    -- 发送更新通知的消息给前端
    SendNUIMessage({
        action = "UpdateHelp",
        id = id,
        text = text,
        key = key
    })
end

-- 移除帮助通知
function RemoveHelp(id)
    for i = 1, #notifys do
        if notifys[i].id == id then
            table.remove(notifys, i)
            break
        end
    end

    -- 发送移除通知的消息给前端
    SendNUIMessage({
        action = "RemoveHelp",
        id = id
    })
end

-- 定时器线程，用于处理鼠标位置
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)

        if #notifys > 0 then
            local coordX, coordY = GetNuiCursorPosition()

            -- 发送鼠标位置信息给前端
            SendNUIMessage({
                action = "TickHelp",
                x = coordX,
                y = coordY,
                hide = IsPauseMenuActive()
            })
        end
    end
end)

-- 注册网络事件
RegisterNetEvent("bigsea_notify:CreateHelp", CreateHelp)
RegisterNetEvent("bigsea_notify:UpdateHelp", UpdateHelp)
RegisterNetEvent("bigsea_notify:RemoveHelp", RemoveHelp)

-- 导出函数给其他脚本使用
exports("CreateHelp", CreateHelp)
exports("UpdateHelp", UpdateHelp)
exports("RemoveHelp", RemoveHelp)
