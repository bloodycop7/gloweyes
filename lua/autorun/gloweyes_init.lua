glowEyes = { Stored = {} }

// For anyone reading this, YOU DO NOT KNOW HOW LONG IT TOOK THAT I REALIZE I COULD USE SETNODRAW FOR CLIENTSIDE RENDERING. I NEED THERAPY

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
    return GetConVar("gloweyes_enabled"):GetBool() or false
end

function glowEyes:ShouldRenderEntity(ent)
    if not ( IsValid(ent) ) then
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

    if not ( glowEyes:IsActivated() ) then
        return false
    end

    if ( ent:IsRagdoll() and not GetConVar("gloweyes_ragdolls"):GetBool() ) then
        return false
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
    timer.Create("glowEyes.RemoveClientsideEyeGlow", 1, 0, function()
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
    end, "glowEyes.ragdollsChanged")

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

    hook.Add("OnEntityCreated", "glowEyes.OnEntityCreated", function(ent)
        timer.Simple(0.1, function()
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

            if ( ent:IsRagdoll() and not GetConVar("gloweyes_ragdolls"):GetBool() ) then
                return
            end

            if ( ent:IsRagdoll() ) then
                ent:SetShouldServerRagdoll(true)
                ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
            end

            local uID = "glowEyes.serverThink." .. ent:GetClass() .. "." .. ent:EntIndex()

            timer.Create(uID, 1, 0.1, function()
                if not ( IsValid(ent) ) then
                    timer.Remove(uID)

                    return
                end

                if ( glowData.serverThink and isfunction(glowData.serverThink) ) then
                    glowData:serverThink(ent)
                end
            end)

            ent:CallOnRemove("glowEyes.serverThink.remove", function(this)
                timer.Remove(uID)
            end)

            if ( glowData.serverInit and isfunction(glowData.serverInit) ) then
                glowData:serverInit(ent)
            end

            local uID = "glowEyes.serverThink." .. ent:EntIndex()

            timer.Create(uID, 1, 0.1, function()
                if not ( IsValid(ent) ) then
                    timer.Remove(uID)

                    return
                end

                if ( ent.glowEyesTable ) then
                    for k, v in ipairs(ent.glowEyesTable) do
                        if not ( IsValid(v) ) then
                            continue
                        end

                        if ( glowEyes:ShouldRenderEntity(ent) ) then
                            continue
                        end

                        v:SetNoDraw(true)                        
                    end
                end

                if ( glowData.serverThink and isfunction(glowData.serverThink) ) then
                    glowData:serverThink(ent)
                end
            end)
            
            timer.Simple(0.1, function()
                if ( ent.glowEyesTable ) then
                    for k, v in ipairs(ent.glowEyesTable) do
                        if not ( IsValid(v) ) then
                            continue
                        end

                        if not ( glowEyes:ShouldRenderEntity(ent) ) then
                            v:SetNoDraw(true)
                        end

                        if not ( glowEyes:IsActivated() ) then
                            v:SetNoDraw(true)
                        end

                        if ( v:IsRagdoll() ) then
                            if not ( GetConVar("gloweyes_ragdolls"):GetBool() ) then
                                v:SetNoDraw(true)
                            end
                        end
                    end
                end
            end)
        end)
    end)

    hook.Add("PlayerSpawn", "glowEyes.PlayerSpawn", function(ply)
        timer.Simple(0.1, function()
            if not ( IsValid(ply) ) then
                return
            end

            local glowData = glowEyes.Stored[ply:GetModel():lower()]

            if not ( glowData ) then
                return
            end

            if ( glowData.serverInit and isfunction(glowData.serverInit) ) then
                glowData:serverInit(ply)
            end

            local uID = "glowEyes.serverThink." .. ply:SteamID64()

            timer.Create(uID, 1, 0.1, function()
                if not ( IsValid(ply) ) then
                    timer.Remove(uID)

                    return
                end

                if ( ply.glowEyesTable ) then
                    for k, v in ipairs(ply.glowEyesTable) do
                        if not ( IsValid(v) ) then
                            continue
                        end
    
                        if ( glowEyes:ShouldRenderEntity(ply) ) then
                            continue
                        end
    
                        v:SetNoDraw(true)                        
                    end
                end

                if ( glowData.serverThink and isfunction(glowData.serverThink) ) then
                    glowData:serverThink(ply)
                end
            end)
        end)
    end)

    hook.Add("DoPlayerDeath", "glowEyes.DoPlayerDeath", function(ply)
        if ( ply.glowEyesTable ) then
            for k, v in ipairs(ply.glowEyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:Remove()
            end
        end

        timer.Remove("glowEyes.serverThink." .. ply:SteamID64())
    end)
    
    hook.Add("PlayerDisconnected", "glowEyes.PlayerDisconnected", function(ply)
        if ( ply.glowEyesTable ) then
            for k, v in ipairs(ply.glowEyesTable) do
                if not ( IsValid(v) ) then
                    continue
                end

                v:Remove()
            end
        end

        timer.Remove("glowEyes.serverThink." .. ply:SteamID64())
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

        ent:SetShouldServerRagdoll(true)
    end)

    hook.Add("EntityRemoved", "glowEyes.EntityRemoved", function(ent)
        if not ( IsValid(ent) ) then
            return
        end

        if ( timer.Exists("glowEyes.serverThink." .. ent:EntIndex()) ) then
            timer.Remove("glowEyes.serverThink." .. ent:EntIndex())
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

    hook.Add("PlayerNoClip", "glowEyes.PlayerNoClip", function(ply, state)
        if not ( IsValid(ply) ) then
            return
        end

        if ( state ) then
            if ( ply.glowEyesTable ) then
                for k, v in ipairs(ply.glowEyesTable) do
                    if not ( IsValid(v) ) then
                        continue
                    end

                    v:SetNoDraw(false)
                end
            end
        end
    end)
end