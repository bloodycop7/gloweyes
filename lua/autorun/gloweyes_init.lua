glowEyes = { Stored = {} }

function glowEyes:Register(model, glowData)
    if not ( model ) then
        ErrorNoHalt("[GlowEyes] Attempted to register a model without a model!\n")

        return
    end

    if not ( glowData ) then
        ErrorNoHalt("[GlowEyes] Attempted to register a model without data!\n")
        
        return
    end

    if not ( file.Exists(model, "GAME") ) then
        ErrorNoHalt("[GlowEyes] Attempted to register an invalid model (" .. model .. ")! (MODEL IS MISSING)\n")

        return
    end

    glowEyes.Stored[string.lower(model)] = glowData
end

function glowEyes:IsActivated()
    if ( CLIENT ) then
        return GetConVar("gloweyes_enabled"):GetBool() or false
    end

    return hook.Run("ShouldRenderGlowingEyes") or true
end

function glowEyes:ShouldRenderEntity(ent)
    if not ( IsValid(ent) ) then
        return false
    end

    if not ( glowEyes:IsActivated() ) then
        return false
    end
    
    if not ( ent:IsPlayer() or ent:IsNPC() or ent:IsRagdoll() ) then
        return
    end

    if ( ent:GetNoDraw() ) then
        return false
    end

    local vModel = string.lower(ent:GetModel())
    local glowData = glowEyes.Stored[vModel]

    if not ( glowData ) then
        return false
    end

    if ( isfunction(glowData.shouldDraw) and not glowData:shouldDraw(ent) ) then
        return false
    end

    if ( hook.Run("ShouldRenderGlowingEyes", ent) == false ) then
        return false
    end

    if ( ent:IsRagdoll() and not GetConVar("gloweyes_ragdolls"):GetBool() ) then
        return false
    end

    if ( ent:IsPlayer() and not GetConVar("gloweyes_players"):GetBool() ) then
        return false
    end

    if ( ent:IsPlayer() ) then
        if not ( ent:GetViewEntity() == ent ) then
            return true
        end
    end

    return true
end

local files, dirs = file.Find("gloweyes/*.lua", "LUA")

for k, v in ipairs(files) do
    if ( SERVER ) then
        AddCSLuaFile("gloweyes/" .. v)
    end

    include("gloweyes/" .. v)
end

if ( CLIENT ) then
    timer.Create("glowEyes.RemoveClientsideEyeGlow", 0, 0, function()
        if not ( IsValid(LocalPlayer()) ) then
            return
        end

        local eyeGlowData = LocalPlayer().glowEyesTable

        if not ( eyeGlowData ) then
            return
        end

        for k, v in ipairs(eyeGlowData) do
            if not ( IsValid(v) ) then
                continue
            end

            v:SetNoDraw(true)
        end
    end)

    CreateClientConVar("gloweyes_enabled", "1", true, false, "Enable or disable glow eyes.", 0, 1)
    CreateClientConVar("gloweyes_ragdolls", "1", true, false, "Enable or disable glow eyes on ragdolls.", 0, 1)
    CreateClientConVar("gloweyes_players", "1", true, false, "Enable or disable glow eyes on players.", 0, 1)

    cvars.RemoveChangeCallback("gloweyes_enabled", "glowEyes.enabledChanged")
    cvars.AddChangeCallback("gloweyes_enabled", function(convar, sOldValue, sNewValue)
        local bConverted = tobool(sNewValue) or false
        if not ( isbool(bConverted) ) then
            return
        end

        for k, v in ipairs(ents.GetAll()) do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:GetModel() ) then
                continue
            end

            local glowData = glowEyes.Stored[string.lower(v:GetModel())]

            if not ( glowData ) then
                continue
            end

            local eyeData = v.glowEyesTable

            if not ( eyeData ) then
                continue
            end

            for a, b in ipairs(eyeData) do
                if not ( glowEyes:ShouldRenderEntity(v) ) then
                    if not ( IsValid(b) ) then
                        continue
                    end

                    b:SetNoDraw(false)
                end

                if ( bConverted ) then
                    if not ( IsValid(b) ) then
                        continue
                    end

                    b:SetNoDraw(false)
                else
                    if not ( IsValid(b) ) then
                        continue
                    end

                    b:SetNoDraw(true)
                end
            end
        end
    end, "glowEyes.enabledChanged")

    cvars.RemoveChangeCallback("gloweyes_ragdolls", "glowEyes.ragdollsChanged")
    cvars.AddChangeCallback("gloweyes_ragdolls", function(convar, sOldValue, sNewValue)
        local bConverted = tobool(sNewValue) or false
        if not ( isbool(bConverted) ) then
            return
        end

        if not ( glowEyes:IsActivated() ) then
            print("[GlowEyes] Glow Eyes is not enabled, so this change will not take effect.")

            return
        end

        for k, v in ipairs(ents.GetAll()) do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:GetModel() ) then
                continue
            end

            local glowData = glowEyes.Stored[string.lower(v:GetModel())]

            if not ( glowData ) then
                continue
            end

            if not ( v:IsRagdoll() ) then
                continue
            end

            local eyeData = v.glowEyesTable

            if not ( eyeData ) then
                continue
            end

            for a, b in ipairs(eyeData) do
                if not ( IsValid(b) ) then
                    continue
                end

                if not ( glowEyes:ShouldRenderEntity(v) ) then
                    b:SetNoDraw(false)
                end

                if ( bConverted ) then
                    b:SetNoDraw(false)
                else
                    b:SetNoDraw(true)
                end
            end
        end
    end, "glowEyes.ragdollsChanged")

    cvars.AddChangeCallback("gloweyes_players", function(convar, sOldValue, sNewValue)
        local bConverted = tobool(sNewValue) or false
        if not ( isbool(bConverted) ) then
            return
        end

        if not ( glowEyes:IsActivated() ) then
            print("[GlowEyes] Glow Eyes is not enabled, so this change will not take effect.")

            return
        end

        for k, v in ipairs(player.GetAll()) do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:GetModel() ) then
                continue
            end

            local glowData = glowEyes.Stored[string.lower(v:GetModel())]

            if not ( glowData ) then
                continue
            end

            local eyeData = v.glowEyesTable

            if not ( eyeData ) then
                continue
            end

            for a, b in ipairs(eyeData) do
                if not ( IsValid(b) ) then
                    continue
                end

                if not ( glowEyes:ShouldRenderEntity(v) ) then
                    b:SetNoDraw(false)
                end

                if ( bConverted ) then
                    b:SetNoDraw(false)
                else
                    b:SetNoDraw(true)
                end
            end
        end
    end, "glowEyes.playersChanged")

    net.Receive("glowEyes.NetworkLightsToClientside", function(len)
        if not ( IsValid(LocalPlayer()) ) then
            return
        end

        local ent = net.ReadEntity()

        if not ( IsValid(ent) ) then
            return
        end

        local eyesTable = net.ReadTable()

        if not ( eyesTable ) then
            return
        end

        ent.glowEyesTable = eyesTable

        if ( ent == LocalPlayer() ) then
            for k, v in ipairs(eyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:SetNoDraw(true)
            end
        end
    end)
else
    util.AddNetworkString("glowEyes.NetworkLightsToClientside")
    // util.AddNetworkString("glowEyes.ForceUpdateColors")

    /*
    net.Receive("glowEyes.ForceUpdateColors", function(ply, len)
        local ent = net.ReadEntity()
        local sprite = net.ReadEntity()
        local color = net.ReadString()

        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent.glowEyesTable ) then
            return
        end

        if not ( IsValid(sprite) ) then
            return
        end

        sprite:SetColor(Vector(tonumber(color)))
    end)
    */

    hook.Add("OnEntityCreated", "glowEyes.OnEntityCreated", function(ent)
        timer.Simple(0.1, function()
            if not ( IsValid(ent) ) then
                return
            end
        
            if not ( ent:GetModel() ) then
                return
            end

            if not ( not ent:IsPlayer() or ent:IsRagdoll() or ent:GetClass() == "prop_dynamic" or ent:GetClass() == "prop_physics" ) then
                return
            end

            local model = string.lower(ent:GetModel())
            local glowData = glowEyes.Stored[model]

            if not ( glowData ) then
                return
            end

            if ( glowData.serverInit and isfunction(glowData.serverInit) ) then
                glowData:serverInit(ent)
            end

            timer.Simple(0.1, function()
                if not ( IsValid(ent) ) then
                    return
                end

                if not ( glowEyes:ShouldRenderEntity(ent) ) then
                    return
                end

                if ( ent.glowEyesTable ) then
                    for k, v in ipairs(ent.glowEyesTable) do
                        if not ( IsValid(v) ) then
                            continue
                        end

                        v:SetNoDraw(true)
                    end
                end
            end)
        end)
    end)

    hook.Add("OnNPCKilled", "glowEyes.OnNPCKilled", function(ent, attacker, inflictor)
        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent:GetModel() ) then
            return
        end

        local model = string.lower(ent:GetModel())
        local glowData = glowEyes.Stored[model]

        if not ( glowData ) then
            return
        end

        if ( ent.glowEyesTable ) then
            for k, v in ipairs(ent.glowEyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:Remove()
            end
        end
    end)

    hook.Add("PlayerSpawn", "glowEyes.PlayerSpawn", function(ply)
        if not ( IsValid(ply) ) then
            return
        end

        local glowEyesData = glowEyes.Stored[string.lower(ply:GetModel())]

        if not ( glowEyesData ) then
            return
        end

        if ( glowEyesData.serverInit and isfunction(glowEyesData.serverInit) ) then
            glowEyesData:serverInit(ply)
        end

        timer.Simple(0.1, function()
            if ( ply.glowEyesTable ) then
                for k, v in ipairs(ply.glowEyesTable) do
                    if not ( IsValid(v) ) then
                        continue
                    end

                    if not ( glowEyes:ShouldRenderEntity(ply) ) then
                        v:SetNoDraw(true)
                    end
                end
            end
        end)
    end)

    hook.Add("DoPlayerDeath", "glowEyes.DoPlayerDeath", function(ply, attacker, dmginfo)
        if not ( IsValid(ply) ) then
            return
        end

        if not ( IsValid(ply:GetModel()) ) then
            return
        end

        local model = string.lower(ply:GetModel())
        local glowData = glowEyes.Stored[model]

        if not ( glowData ) then
            return
        end

        if ( ply.glowEyesTable ) then
            for k, v in ipairs(ply.glowEyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:Remove()
            end
        end
    end)

    hook.Add("Think", "glowEyes.Think", function()
        for k, v in ipairs(ents.GetAll()) do
            if not ( IsValid(v) ) then
                continue
            end

            if ( v:IsPlayer() ) then
                continue
            end

            if not ( v:GetModel() ) then
                continue
            end

            if not ( v:IsRagdoll() or v:IsNPC() or v:GetClass() == "prop_physics" or v:GetClass() == "prop_dynamic" ) then
                continue
            end

            local glowData = glowEyes.Stored[string.lower(v:GetModel())]

            if not ( glowData ) then
                continue
            end

            if ( glowData.serverThink and isfunction(glowData.serverThink) ) then
                glowData:serverThink(v)
            end

            local bShouldRenderEyes = true

            if ( isfunction(glowData.shouldDraw) and not glowData:shouldDraw(v) ) then
                bShouldRenderEyes = false
            end

            if ( v:GetNoDraw() or not glowEyes:ShouldRenderEntity(v) ) then
                bShouldRenderEyes = false
            end
            
            if ( v.glowEyesTable ) then
                for a, b in ipairs(v.glowEyesTable) do
                    if not ( IsValid(b) ) then
                        continue
                    end

                    if not ( bShouldRenderEyes ) then
                        b:SetNoDraw(true)

                        continue
                    end
                    
                    b:SetNoDraw(false)
                end
            end
        end

        for k, v in ipairs(player.GetAll()) do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:GetModel() ) then
                continue
            end

            local glowData = glowEyes.Stored[string.lower(v:GetModel())]

            if not ( glowData ) then
                continue
            end

            if ( glowData.serverThink and isfunction(glowData.serverThink) ) then
                glowData:serverThink(v)
            end

            local bShouldRenderEyes = true

            if ( isfunction(glowData.shouldDraw) and not glowData:shouldDraw(v) ) then
                bShouldRenderEyes = false
            end

            if ( v:GetNoDraw() or not glowEyes:ShouldRenderEntity(v) ) then
                bShouldRenderEyes = false
            end
            
            if ( v.glowEyesTable ) then
                for a, b in ipairs(v.glowEyesTable) do
                    if not ( IsValid(b) ) then
                        continue
                    end

                    if not ( bShouldRenderEyes ) then
                        b:SetNoDraw(true)
        
                        continue
                    end
                    
                    b:SetNoDraw(false)
                end
            end
        end
    end)

    hook.Add("DoPlayerDeath", "glowEyes.DoPlayerDeath", function(ply, attacker, dmginfo)
        if not ( IsValid(ply) ) then
            return
        end

        if not ( ply:GetModel() ) then
            return
        end

        local model = string.lower(ply:GetModel())
        local glowData = glowEyes.Stored[model]

        if not ( glowData ) then
            return
        end

        if ( ply.glowEyesTable ) then
            for k, v in ipairs(ply.glowEyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:Remove()
            end
        end

        timer.Simple(0.1, function()
            local rag = ply:GetRagdollEntity()

            if not ( IsValid(rag) ) then
                return
            end

            hook.Run("OnEntityCreated", rag)
        end)
    end)

    hook.Add("PlayerDisconnected", "glowEyes.PlayerDisconnected", function(ply)
        if not ( IsValid(ply) ) then
            return
        end

        if ( ply.glowEyesTable ) then
            for k, v in ipairs(ply.glowEyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:Remove()
            end
        end
    end)

    hook.Add("EntityRemoved", "glowEyes.EntityRemoved", function(ent)
        if not ( IsValid(ent) ) then
            return
        end

        if ( ent.glowEyesTable ) then
            for k, v in ipairs(ent.glowEyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:Remove()
            end
        end
    end)
end

/*
properties.Add("gloweyes_editcolors", {
    MenuLabel = "Edit Glow Eyes Colors",
    Order = 90001,
    MenuIcon = "icon16/color_wheel.png",
    Filter = function(self, ent, ply)
        if not ( IsValid(ent) ) then
            return false
        end

        if not ( ( ent:IsPlayer() and not ply:IsAdmin() ) or ent:IsNPC() or ent:IsRagdoll() ) then
            return false
        end

        if not ( ent:GetModel() ) then
            return false
        end

        local glowData = glowEyes.Stored[string.lower(ent:GetModel())]

        if not ( glowData ) then
            return false
        end

        return true
    end,
    Action = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent:GetModel() ) then
            return
        end

        local glowData = glowEyes.Stored[string.lower(ent:GetModel())]

        if not ( glowData ) then
            return
        end

        local propertyMenu = vgui.Create("DFrame")
        propertyMenu:SetPos(0, 0)
        propertyMenu:SetSize(500, 300)
        propertyMenu:Center()
        propertyMenu:MakePopup()

        local propertyContext = propertyMenu:Add("DProperties")
        propertyContext:Dock(FILL)

        for k, v in ipairs(ent.glowEyesTable) do
            if not ( IsValid(v) ) then
                continue
            end

            local color = propertyContext:CreateRow("Glow Eyes", k .. " Eye Color")
            color:Setup("VectorColor", {})
            color:SetValue(v:GetColor():ToVector())
            color.DataChanged = function(self, data)
                net.Start("glowEyes.ForceUpdateColors")
                    net.WriteEntity(ent)
                    net.WriteEntity(v)
                    net.WriteString(data)
                net.SendToServer()
            end
        end
    end
})
*/