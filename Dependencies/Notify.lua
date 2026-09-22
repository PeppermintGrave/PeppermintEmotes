local StarterGui = game:GetService("StarterGui")

getgenv().Notify = getgenv().Notify or function(data)
    data = data or {}
    local title = tostring(data.Title or "PeppermintGrave")
    local content = tostring(data.Content or "")
    local duration = tonumber(data.Duration) or 5

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = content,
            Duration = duration
        })
    end)
end

return getgenv().Notify
