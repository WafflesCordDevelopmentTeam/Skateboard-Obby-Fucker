-- Load the necessary libraries for GUI and notifications
local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = library.subs.Wait -- Only returns if the GUI has not been terminated. For 'while Wait() do' loops

local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local Notify = AkaliNotif.Notify

-- Create the main window of the GUI
local SkateboardObbyFucker = library:CreateWindow({
    Name = "Skateboard Obby Fucker", -- GUI title
    Themeable = {
        Info = "Discord: pekoara | Made By Vort" -- Info section for Discord and credits
    }
})

-- Main Tab (now combined all functionalities into this tab)
local MainTab = SkateboardObbyFucker:CreateTab({
    Name = "Main"
})

-- Add a label with the message for coding skills on the main tab
MainTab:AddLabel({
    Name = "Sorry For The Ugly Coding Skills, On Github But it's Whatever Atleast It's Working Right?",
    TextSize = 14, -- Adjusting text size for better fit
    TextXAlignment = Enum.TextXAlignment.Center, -- Center alignment for better look
    TextYAlignment = Enum.TextYAlignment.Center -- Center alignment for better look
})

-- Section for the main teleportation features
local MainSection = MainTab:CreateSection({
    Name = "Main Controls",
    Side = "Left"
})

-- Spam Chat Section
local SpamChatSection = MainTab:CreateSection({
    Name = "Spam Chat",
    Side = "Right"
})

-- Anti-Crash Section
local AntiCrashSection = MainTab:CreateSection({
    Name = "Anti-Crash",
    Side = "Left"
})

-- Credits Section
local CreditsSection = MainTab:CreateSection({
    Name = "Credits",
    Side = "Right"
})

-- Variables for player and character parts
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")

-- Function to get all the checkpoints in the map and sort them numerically
local function getSortedCheckpoints()
    local checkpoints = workspace.Map.Checkpoints:GetChildren()
    table.sort(checkpoints, function(a, b) return tonumber(a.Name) < tonumber(b.Name) end)
    return checkpoints
end

-- Function to teleport the player to a checkpoint instantly
local function teleportToCheckpointInstant(checkpoint)
    if checkpoint:FindFirstChild("Flag") then
        local flag = checkpoint.Flag
        -- Instantly teleport the player to the flag's position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = flag.CFrame
    end
end

-- Loop control variables
local isLooping = false -- Flag to control the looping behavior
local isAntiCrashEnabled = false -- Flag for anti-crash feature
local lastTeleportTime = 0 -- To track the last teleport time
local lastMessageTime = 0 -- To track the last message sent time

-- Add a toggle for enabling/disabling the teleportation loop
MainSection:AddToggle({
    Name = "Enable Teleport Loop",
    Flag = "TeleportLoopToggler",
    Callback = function(value)
        isLooping = value -- Enable or disable the loop based on toggle state
        if isLooping then
            Notify({
                Description = "Teleport loop enabled.",
                Title = "Success",
                Duration = 4
            })
            -- Start the teleport loop
            spawn(function()
                while isLooping do
                    local checkpoints = getSortedCheckpoints()
                    for _, checkpoint in ipairs(checkpoints) do
                        -- Ensure smooth teleportation and handle intervals
                        local currentTime = tick()
                        if currentTime - lastTeleportTime >= 0.5 then -- Smooth teleport with a 0.5 second interval
                            teleportToCheckpointInstant(checkpoint) -- Instant teleport
                            lastTeleportTime = currentTime
                        end
                        task.wait(0.1) -- Added small wait to prevent script overload
                    end
                    -- Optionally, you can loop through the checkpoints indefinitely
                    task.wait(1) -- Added delay to prevent overload and ensure smooth looping
                end
            end)
        else
            Notify({
                Description = "Teleport loop disabled.",
                Title = "Success",
                Duration = 4
            })
        end
    end
})

-- Add a toggle for disabling the teleportation loop
MainSection:AddToggle({
    Name = "Disable Teleport Loop",
    Flag = "DisableTeleportLoopToggler",
    Callback = function(value)
        isLooping = not value -- Disable teleport loop by setting isLooping to false
        Notify({
            Description = "Teleport loop has been disabled.",
            Title = "Success",
            Duration = 4
        })
    end
})

-- Spam Chat feature
SpamChatSection:AddTextbox({
    Name = "Spam Message",
    PlaceholderText = "Enter message to spam",
    Callback = function(message)
        local spamEnabled = true -- Change this to a toggle if you want to enable/disable spam
        if spamEnabled and message ~= "" then
            -- Anti-crash check: Only send a message every 1 second to avoid overload
            if isAntiCrashEnabled then
                spawn(function()
                    while spamEnabled do
                        local currentTime = tick()
                        -- Ensure that we don't spam too quickly (every 1 second)
                        if currentTime - lastMessageTime >= 1 then
                            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
                            lastMessageTime = currentTime
                        end
                        task.wait(0.1) -- Added wait to prevent server overload
                    end
                end)
            end
        end
    end
})

-- Toggle to stop spam chat
SpamChatSection:AddToggle({
    Name = "Enable Spam Chat",
    Flag = "SpamChatToggler",
    Callback = function(value)
        if value then
            Notify({
                Description = "Spam Chat enabled.",
                Title = "Success",
                Duration = 4
            })
        else
            Notify({
                Description = "Spam Chat disabled.",
                Title = "Success",
                Duration = 4
            })
        end
    end
})

-- Anti-Crash Feature: Enable/Disable Anti-Crash
AntiCrashSection:AddToggle({
    Name = "Enable Anti-Crash",
    Flag = "AntiCrashToggler",
    Callback = function(value)
        isAntiCrashEnabled = value -- Toggle the anti-crash flag
        if isAntiCrashEnabled then
            Notify({
                Description = "Anti-Crash enabled.",
                Title = "Success",
                Duration = 4
            })
        else
            Notify({
                Description = "Anti-Crash disabled.",
                Title = "Success",
                Duration = 4
            })
        end
    end
})

-- Credits Section
CreditsSection:AddLabel({
    Name = "Skateboard Fucker GUI Made By Vort",
    TextSize = 14, -- Adjusting text size for better fit
    TextXAlignment = Enum.TextXAlignment.Center, -- Center alignment for better look
    TextYAlignment = Enum.TextYAlignment.Center -- Center alignment for better look
})
CreditsSection:AddLabel({
    Name = "Discord: pekoara",
    TextSize = 14, -- Adjusting text size for better fit
    TextXAlignment = Enum.TextXAlignment.Center, -- Center alignment for better look
    TextYAlignment = Enum.TextYAlignment.Center -- Center alignment for better look
})

-- Add task.wait() for smoother operation and less risk of overload
task.wait(1) -- Small wait to help avoid script overload
