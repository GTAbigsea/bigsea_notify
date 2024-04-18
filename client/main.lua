local timer = 5000  -- 定时器时间
local loadingScreenFinished = false  -- 加载屏幕完成标志
local openIdcard = false  -- 是否打开身份证
local statusNotify = false  -- 通知状态

local current_help_notification = {  -- 当前帮助通知
	text = nil,  -- 文本
	timer = nil  -- 计时器
}

local is_thread_running = false  -- 线程运行状态

local help_notification_thread = function()  -- 帮助通知线程
	is_thread_running = true

	while true do
		if current_help_notification.text ~= nil then
			if current_help_notification.timer + 0.1 <= timer.Get() then
				RemoveHelpNotification()
				break
			end
		end

		Citizen.Wait(100)
	end

	is_thread_running = false
end

ShowHelpNotification = function(text, is_new)  -- 显示帮助通知
	current_help_notification.timer = GetInternalTimer()

	if current_help_notification.text ~= text then
		current_help_notification.text = text

		if not is_new and not is_thread_running then
			Citizen.CreateThread(help_notification_thread)
		end

		SendNUIMessage(
			{
				action = "SendHelpNotification",  -- 发送帮助通知
				text = text
			}
		)
	end
end

RemoveHelpNotification = function()  -- 移除帮助通知
	current_help_notification.text = nil

	SendNUIMessage({
		action = "RemoveHelpNotification"
	})
end

RegisterNetEvent("origen_notify:ShowNotification")  -- 注册显示通知事件
AddEventHandler(
	"origen_notify:ShowNotification",
	function(text, title, business)
		if statusNotify == true then
			while true do
				Wait(100)

				if statusNotify == false then
					break
				end
			end
		end

		if title == nil then
			title = "通知"
		end

		SendNUIMessage(
			{
				action = "SendNotification",  -- 发送通知
				text = text,
				title = title,
				business = business
			}
		)
	end
)

RegisterNetEvent("notify:client:statusNotify")  -- 注册通知状态事件
AddEventHandler(
	"notify:client:statusNotify",
	function(bool)
		statusNotify = bool
	end
)

RegisterCommand(  -- 注册命令
	"quinox",
	function()
		TriggerEvent("origen_notify:ShowNotification", "测试！", "复活节彩蛋")
	end,
	false
)

RegisterNetEvent("origen_notify:SendNotification")  -- 注册发送通知事件
AddEventHandler(
	"origen_notify:SendNotification",
	function(options)
		if statusNotify == true then
			while true do
				Wait(100)
				if statusNotify == false then
					break
				end
			end
		end
		SendNUIMessage(
			{
				action = "SendNotification",  -- 发送通知
				text = options.text,
				type = options.type,
				queue = options.queue,
				timeout = options.timeout,
				layout = options.layout
			}
		)
	end
)

RegisterNetEvent("origen_notify:SetQueueMax")  -- 注册设置队列最大值事件
AddEventHandler(
	"origen_notify:SetQueueMax",
	function(queue, value)
		SendNUIMessage(
			{
				action = "SetQueueMax",
				queue = queue,
				value = value
			}
		)
	end
)
