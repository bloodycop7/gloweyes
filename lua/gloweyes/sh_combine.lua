print("[GlowEyes] Half-Life: 2 Combine made by eon")

local eyeMaterialFallBack = Material("sprites/light_glow02_add", "smooth nomips clamp")

glowEyes:Register("models/combine_soldier.mdl", {
    serverInit = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end
        
        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:Remove()
        end
        
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:Remove()
        end
        
        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:Remove()
        end
        
        local attachment = ent:GetAttachment(ent:LookupAttachment("eyes"))
        
        if not ( attachment ) then
            return
        end
        
        local pos = attachment.Pos
        
        local leftEyePos = attachment.Pos
        leftEyePos = leftEyePos + attachment.Ang:Right() * -1.7
        leftEyePos = leftEyePos + attachment.Ang:Forward() * -0.2
        
        local rightEyePos = attachment.Pos
        rightEyePos = rightEyePos + attachment.Ang:Right() * 1.7
        rightEyePos = rightEyePos + attachment.Ang:Forward() * -0.2
        
        local lColor, rColor, gColor = Color(0, 255, 255), Color(0, 255, 255), Color(0, 255, 255)

        if ( self.color and isfunction(self.color) ) then
            lColor, rColor, gColor = self:color(ent)
        end

        ent.leftEyeGlow = ents.Create("env_sprite")
        ent.leftEyeGlow:SetPos(leftEyePos)
        ent.leftEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.leftEyeGlow:SetKeyValue("rendermode", "9")
        ent.leftEyeGlow:SetKeyValue("renderamt", "255")
        ent.leftEyeGlow:SetKeyValue("rendercolor", lColor.r .. " " .. lColor.g .. " " .. lColor.b)
        ent.leftEyeGlow:SetKeyValue("renderfx", "0")
        ent.leftEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.leftEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.leftEyeGlow:SetKeyValue("scale", "0.05")
        ent.leftEyeGlow:Spawn()
        
        ent.rightEyeGlow = ents.Create("env_sprite")
        ent.rightEyeGlow:SetPos(rightEyePos)
        ent.rightEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.rightEyeGlow:SetKeyValue("rendermode", "9")
        ent.rightEyeGlow:SetKeyValue("renderamt", "255")
        ent.rightEyeGlow:SetKeyValue("rendercolor", rColor.r .. " " .. rColor.g .. " " .. rColor.b)
        ent.rightEyeGlow:SetKeyValue("renderfx", "0")
        ent.rightEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.rightEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.rightEyeGlow:SetKeyValue("scale", "0.05")
        ent.rightEyeGlow:Spawn()
        
        ent.worldGlowSprite = ents.Create("env_sprite")
        ent.worldGlowSprite:SetPos(pos)
        ent.worldGlowSprite:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.worldGlowSprite:SetKeyValue("rendermode", "9")
        ent.worldGlowSprite:SetKeyValue("renderamt", "60")
        ent.worldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.worldGlowSprite:SetKeyValue("renderfx", "0")
        ent.worldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.worldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.worldGlowSprite:SetKeyValue("scale", "0.2")
        ent.worldGlowSprite:Spawn()

        timer.Simple(0.1, function()
            local glowTable = {}

            if ( IsValid(ent.leftEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.leftEyeGlow
            end

            if ( IsValid(ent.rightEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.rightEyeGlow
            end

            if ( IsValid(ent.worldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.worldGlowSprite
            end

            net.Start("glowEyes.NetworkLightsToClientside")
                net.WriteEntity(ent)
                net.WriteTable(glowTable)
            net.Broadcast()

            ent.glowEyesTable = glowTable
        end)
    end,
    color = function(self, ent)
        if ( ent:GetSkin() == 1 ) then
            return Color(255, 80, 0), Color(255, 80, 70), Color(255, 80, 0)
        end

        return Color(0, 255, 255), Color(0, 255, 255), Color(0, 255, 255)
    end,
    serverThink = function(self, ent)
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:SetKeyValue("rendercolor", select(1, self:color(ent)).r .. " " .. select(1, self:color(ent)).g .. " " .. select(1, self:color(ent)).b)
        end

        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:SetKeyValue("rendercolor", select(2, self:color(ent)).r .. " " .. select(2, self:color(ent)).g .. " " .. select(2, self:color(ent)).b)
        end

        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:SetKeyValue("rendercolor", select(3, self:color(ent)).r .. " " .. select(3, self:color(ent)).g .. " " .. select(3, self:color(ent)).b)
        end
    end
})

glowEyes:Register("models/combine_soldier_prisonguard.mdl", {
    serverInit = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end
        
        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:Remove()
        end
        
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:Remove()
        end
        
        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:Remove()
        end
        
        local attachment = ent:GetAttachment(ent:LookupAttachment("eyes"))
        
        if not ( attachment ) then
            return
        end
        
        local pos = attachment.Pos
        
        local leftEyePos = attachment.Pos
        leftEyePos = leftEyePos + attachment.Ang:Right() * -1.7
        leftEyePos = leftEyePos + attachment.Ang:Forward() * -0.2
        
        local rightEyePos = attachment.Pos
        rightEyePos = rightEyePos + attachment.Ang:Right() * 1.7
        rightEyePos = rightEyePos + attachment.Ang:Forward() * -0.2
        
        local lColor, rColor, gColor = Color(0, 255, 255), Color(0, 255, 255), Color(0, 150, 255)

        if ( self.color and isfunction(self.color) ) then
            lColor, rColor, gColor = self:color(ent)
        end

        ent.leftEyeGlow = ents.Create("env_sprite")
        ent.leftEyeGlow:SetPos(leftEyePos)
        ent.leftEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.leftEyeGlow:SetKeyValue("rendermode", "9")
        ent.leftEyeGlow:SetKeyValue("renderamt", "255")
        ent.leftEyeGlow:SetKeyValue("rendercolor", lColor.r .. " " .. lColor.g .. " " .. lColor.b)
        ent.leftEyeGlow:SetKeyValue("renderfx", "0")
        ent.leftEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.leftEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.leftEyeGlow:SetKeyValue("scale", "0.05")
        ent.leftEyeGlow:Spawn()
        
        ent.rightEyeGlow = ents.Create("env_sprite")
        ent.rightEyeGlow:SetPos(rightEyePos)
        ent.rightEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.rightEyeGlow:SetKeyValue("rendermode", "9")
        ent.rightEyeGlow:SetKeyValue("renderamt", "255")
        ent.rightEyeGlow:SetKeyValue("rendercolor", rColor.r .. " " .. rColor.g .. " " .. rColor.b)
        ent.rightEyeGlow:SetKeyValue("renderfx", "0")
        ent.rightEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.rightEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.rightEyeGlow:SetKeyValue("scale", "0.05")
        ent.rightEyeGlow:Spawn()
        
        ent.worldGlowSprite = ents.Create("env_sprite")
        ent.worldGlowSprite:SetPos(pos)
        ent.worldGlowSprite:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.worldGlowSprite:SetKeyValue("rendermode", "9")
        ent.worldGlowSprite:SetKeyValue("renderamt", "60")
        ent.worldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.worldGlowSprite:SetKeyValue("renderfx", "0")
        ent.worldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.worldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.worldGlowSprite:SetKeyValue("scale", "0.2")
        ent.worldGlowSprite:Spawn()

        timer.Simple(0.1, function()
            local glowTable = {}

            if ( IsValid(ent.leftEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.leftEyeGlow
            end

            if ( IsValid(ent.rightEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.rightEyeGlow
            end

            if ( IsValid(ent.worldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.worldGlowSprite
            end
    
            net.Start("glowEyes.NetworkLightsToClientside")
                net.WriteEntity(ent)
                net.WriteTable(glowTable)
            net.Broadcast()

            ent.glowEyesTable = glowTable
        end)
    end,
    color = function(self, ent)
        if ( ent:GetSkin() == 1 ) then
            return Color(200, 50, 0), Color(255, 50, 0), Color(255, 50, 0)
        end

        return Color(255, 185, 0), Color(255, 185, 0), Color(255, 150, 0)
    end,
    serverThink = function(self, ent)
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:SetKeyValue("rendercolor", select(1, self:color(ent)).r .. " " .. select(1, self:color(ent)).g .. " " .. select(1, self:color(ent)).b)
        end

        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:SetKeyValue("rendercolor", select(2, self:color(ent)).r .. " " .. select(2, self:color(ent)).g .. " " .. select(2, self:color(ent)).b)
        end

        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:SetKeyValue("rendercolor", select(3, self:color(ent)).r .. " " .. select(3, self:color(ent)).g .. " " .. select(3, self:color(ent)).b)
        end
    end
})

glowEyes:Register("models/combine_super_soldier.mdl", {
    serverInit = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end
        
        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:Remove()
        end
        
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:Remove()
        end
        
        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:Remove()
        end
        
        local attachment = ent:GetAttachment(ent:LookupAttachment("eyes"))
        
        if not ( attachment ) then
            return
        end
        
        local pos = attachment.Pos
        pos = pos + attachment.Ang:Forward() * -0.2
        pos = pos + attachment.Ang:Up() * 1
        
        local eyePos = attachment.Pos
        eyePos = eyePos + attachment.Ang:Forward() * -0.2
        eyePos = eyePos + attachment.Ang:Up() * 0.4
        
        local eColor, gColor = Color(255, 0, 0), Color(255, 0, 0)

        if ( self.color and isfunction(self.color) ) then
            eColor, gColor = self:color(ent)
        end

        ent.leftEyeGlow = ents.Create("env_sprite")
        ent.leftEyeGlow:SetPos(eyePos)
        ent.leftEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.leftEyeGlow:SetKeyValue("rendermode", "9")
        ent.leftEyeGlow:SetKeyValue("renderamt", "255")
        ent.leftEyeGlow:SetKeyValue("rendercolor", eColor.r .. " " .. eColor.g .. " " .. eColor.b)
        ent.leftEyeGlow:SetKeyValue("renderfx", "0")
        ent.leftEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.leftEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.leftEyeGlow:SetKeyValue("scale", "0.05")
        ent.leftEyeGlow:Spawn()
        
        ent.worldGlowSprite = ents.Create("env_sprite")
        ent.worldGlowSprite:SetPos(pos)
        ent.worldGlowSprite:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.worldGlowSprite:SetKeyValue("rendermode", "9")
        ent.worldGlowSprite:SetKeyValue("renderamt", "110")
        ent.worldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.worldGlowSprite:SetKeyValue("renderfx", "0")
        ent.worldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.worldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.worldGlowSprite:SetKeyValue("scale", "0.2")
        ent.worldGlowSprite:Spawn()
        
        timer.Simple(0.1, function()
            local glowTable = {}

            if ( IsValid(ent.leftEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.leftEyeGlow
            end

            if ( IsValid(ent.worldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.worldGlowSprite
            end
    
            net.Start("glowEyes.NetworkLightsToClientside")
                net.WriteEntity(ent)
                net.WriteTable(glowTable)
            net.Broadcast()

            ent.glowEyesTable = glowTable
        end)
    end,
    color = function(self, ent)
        return Color(255, 0, 0), Color(255, 0, 0)
    end
})

glowEyes:Register("models/hunter.mdl", {
    serverInit = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end
        
        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:Remove()
        end
        
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:Remove()
        end
        
        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:Remove()
        end
        
        local attachment = ent:GetAttachment(ent:LookupAttachment("top_eye"))
        local secondAttachment = ent:GetAttachment(ent:LookupAttachment("bottom_eye"))
        
        if not ( attachment and secondAttachment ) then
            return
        end
        
        local pos = attachment.Pos
        pos = pos + attachment.Ang:Forward() * -0.2
        
        local topEyePos = attachment.Pos
        topEyePos = topEyePos + attachment.Ang:Forward() * -6

        local bottomEyePos = secondAttachment.Pos
        bottomEyePos = bottomEyePos + secondAttachment.Ang:Forward() * -6

        local eColor, gColor = Color(0, 255, 255), Color(0, 255, 255)

        if ( self.color and isfunction(self.color) ) then
            eColor, gColor = self:color(ent)
        end

        ent.topEyeGlow = ents.Create("env_sprite")
        ent.topEyeGlow:SetPos(topEyePos)
        ent.topEyeGlow:SetParent(ent, ent:LookupAttachment("top_eye"))
        ent.topEyeGlow:SetKeyValue("rendermode", "9")
        ent.topEyeGlow:SetKeyValue("renderamt", "255")
        ent.topEyeGlow:SetKeyValue("rendercolor", eColor.r .. " " .. eColor.g .. " " .. eColor.b)
        ent.topEyeGlow:SetKeyValue("renderfx", "0")
        ent.topEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.topEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.topEyeGlow:SetKeyValue("scale", "0.05")
        ent.topEyeGlow:Spawn()

        ent.bottomEyeGlow = ents.Create("env_sprite")
        ent.bottomEyeGlow:SetPos(bottomEyePos)
        ent.bottomEyeGlow:SetParent(ent, ent:LookupAttachment("bottom_eye"))
        ent.bottomEyeGlow:SetKeyValue("rendermode", "9")
        ent.bottomEyeGlow:SetKeyValue("renderamt", "255")
        ent.bottomEyeGlow:SetKeyValue("rendercolor", eColor.r .. " " .. eColor.g .. " " .. eColor.b)
        ent.bottomEyeGlow:SetKeyValue("renderfx", "0")
        ent.bottomEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.bottomEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.bottomEyeGlow:SetKeyValue("scale", "0.05")
        ent.bottomEyeGlow:Spawn()
        
        ent.topWorldGlowSprite = ents.Create("env_sprite")
        ent.topWorldGlowSprite:SetPos(topEyePos)
        ent.topWorldGlowSprite:SetParent(ent, ent:LookupAttachment("top_eye"))
        ent.topWorldGlowSprite:SetKeyValue("rendermode", "9")
        ent.topWorldGlowSprite:SetKeyValue("renderamt", "60")
        ent.topWorldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.topWorldGlowSprite:SetKeyValue("renderfx", "0")
        ent.topWorldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.topWorldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.topWorldGlowSprite:SetKeyValue("scale", "0.2")
        ent.topWorldGlowSprite:Spawn()

        ent.bottomWorldGlowSprite = ents.Create("env_sprite")
        ent.bottomWorldGlowSprite:SetPos(bottomEyePos)
        ent.bottomWorldGlowSprite:SetParent(ent, ent:LookupAttachment("bottom_eye"))
        ent.bottomWorldGlowSprite:SetKeyValue("rendermode", "9")
        ent.bottomWorldGlowSprite:SetKeyValue("renderamt", "60")
        ent.bottomWorldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.bottomWorldGlowSprite:SetKeyValue("renderfx", "0")
        ent.bottomWorldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.bottomWorldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.bottomWorldGlowSprite:SetKeyValue("scale", "0.2")
        ent.bottomWorldGlowSprite:Spawn()

        timer.Simple(0.1, function()
            local glowTable = {}

            if ( IsValid(ent.topEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.topEyeGlow
            end

            if ( IsValid(ent.bottomEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.bottomEyeGlow
            end

            if ( IsValid(ent.topWorldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.topWorldGlowSprite
            end

            if ( IsValid(ent.bottomWorldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.bottomWorldGlowSprite
            end
    
            net.Start("glowEyes.NetworkLightsToClientside")
                net.WriteEntity(ent)
                net.WriteTable(glowTable)
            net.Broadcast()

            ent.glowEyesTable = glowTable
        end)
    end,
    color = function(self, ent)
        return Color(0, 255, 255), Color(0, 255, 255)
    end
})

glowEyes:Register("models/combine_scanner.mdl", {
    serverInit = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end
        
        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:Remove()
        end
        
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:Remove()
        end
        
        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:Remove()
        end
        
        local attachment = ent:GetAttachment(ent:LookupAttachment("eyes"))
        
        if not ( attachment ) then
            return
        end
        
        local pos = attachment.Pos
        pos = pos + attachment.Ang:Forward() * 1.5
        
        local eyePos = attachment.Pos
        eyePos = eyePos + attachment.Ang:Forward() * 1.5
        
        local eColor, gColor = Color(255, 0, 0), Color(255, 0, 0)

        if ( self.color and isfunction(self.color) ) then
            eColor, gColor = self:color(ent)
        end

        ent.leftEyeGlow = ents.Create("env_sprite")
        ent.leftEyeGlow:SetPos(eyePos)
        ent.leftEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.leftEyeGlow:SetKeyValue("rendermode", "9")
        ent.leftEyeGlow:SetKeyValue("renderamt", "255")
        ent.leftEyeGlow:SetKeyValue("rendercolor", eColor.r .. " " .. eColor.g .. " " .. eColor.b)
        ent.leftEyeGlow:SetKeyValue("renderfx", "0")
        ent.leftEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.leftEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.leftEyeGlow:SetKeyValue("scale", "0.05")
        ent.leftEyeGlow:Spawn()
        
        ent.worldGlowSprite = ents.Create("env_sprite")
        ent.worldGlowSprite:SetPos(pos)
        ent.worldGlowSprite:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.worldGlowSprite:SetKeyValue("rendermode", "9")
        ent.worldGlowSprite:SetKeyValue("renderamt", "110")
        ent.worldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.worldGlowSprite:SetKeyValue("renderfx", "0")
        ent.worldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.worldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.worldGlowSprite:SetKeyValue("scale", "0.2")
        ent.worldGlowSprite:Spawn()
        
        timer.Simple(0.1, function()
            local glowTable = {}

            if ( IsValid(ent.leftEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.leftEyeGlow
            end

            if ( IsValid(ent.worldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.worldGlowSprite
            end
    
            net.Start("glowEyes.NetworkLightsToClientside")
                net.WriteEntity(ent)
                net.WriteTable(glowTable)
            net.Broadcast()

            ent.glowEyesTable = glowTable
        end)
    end,
    color = function(self, ent)
        return Color(255, 0, 0), Color(255, 0, 0)
    end
})

glowEyes:Register("models/player/combine_soldier.mdl", {
    serverInit = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end
        
        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:Remove()
        end
        
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:Remove()
        end
        
        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:Remove()
        end
        
        local attachment = ent:GetAttachment(ent:LookupAttachment("eyes"))
        
        if not ( attachment ) then
            return
        end
        
        local pos = attachment.Pos
        
        local leftEyePos = attachment.Pos
        leftEyePos = leftEyePos + attachment.Ang:Right() * -1.7
        leftEyePos = leftEyePos + attachment.Ang:Forward() * -0.2
        
        local rightEyePos = attachment.Pos
        rightEyePos = rightEyePos + attachment.Ang:Right() * 1.7
        rightEyePos = rightEyePos + attachment.Ang:Forward() * -0.2
        
        local lColor, rColor, gColor = Color(0, 255, 255), Color(0, 255, 255), Color(0, 255, 255)

        if ( self.color and isfunction(self.color) ) then
            lColor, rColor, gColor = self:color(ent)
        end

        ent.leftEyeGlow = ents.Create("env_sprite")
        ent.leftEyeGlow:SetPos(leftEyePos)
        ent.leftEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.leftEyeGlow:SetKeyValue("rendermode", "9")
        ent.leftEyeGlow:SetKeyValue("renderamt", "255")
        ent.leftEyeGlow:SetKeyValue("rendercolor", lColor.r .. " " .. lColor.g .. " " .. lColor.b)
        ent.leftEyeGlow:SetKeyValue("renderfx", "0")
        ent.leftEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.leftEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.leftEyeGlow:SetKeyValue("scale", "0.05")
        ent.leftEyeGlow:Spawn()
        
        ent.rightEyeGlow = ents.Create("env_sprite")
        ent.rightEyeGlow:SetPos(rightEyePos)
        ent.rightEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.rightEyeGlow:SetKeyValue("rendermode", "9")
        ent.rightEyeGlow:SetKeyValue("renderamt", "255")
        ent.rightEyeGlow:SetKeyValue("rendercolor", rColor.r .. " " .. rColor.g .. " " .. rColor.b)
        ent.rightEyeGlow:SetKeyValue("renderfx", "0")
        ent.rightEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.rightEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.rightEyeGlow:SetKeyValue("scale", "0.05")
        ent.rightEyeGlow:Spawn()
        
        ent.worldGlowSprite = ents.Create("env_sprite")
        ent.worldGlowSprite:SetPos(pos)
        ent.worldGlowSprite:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.worldGlowSprite:SetKeyValue("rendermode", "9")
        ent.worldGlowSprite:SetKeyValue("renderamt", "60")
        ent.worldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.worldGlowSprite:SetKeyValue("renderfx", "0")
        ent.worldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.worldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.worldGlowSprite:SetKeyValue("scale", "0.2")
        ent.worldGlowSprite:Spawn()

        timer.Simple(0.1, function()
            local glowTable = {}

            if ( IsValid(ent.leftEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.leftEyeGlow
            end

            if ( IsValid(ent.rightEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.rightEyeGlow
            end

            if ( IsValid(ent.worldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.worldGlowSprite
            end

            net.Start("glowEyes.NetworkLightsToClientside")
                net.WriteEntity(ent)
                net.WriteTable(glowTable)
            net.Broadcast()

            ent.glowEyesTable = glowTable
        end)
    end,
    color = function(self, ent)
        return ent:GetPlayerColor():ToColor(), ent:GetPlayerColor():ToColor(), ent:GetPlayerColor():ToColor()
    end,
    serverThink = function(self, ent)
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:SetKeyValue("rendercolor", select(1, self:color(ent)).r .. " " .. select(1, self:color(ent)).g .. " " .. select(1, self:color(ent)).b)
        end

        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:SetKeyValue("rendercolor", select(2, self:color(ent)).r .. " " .. select(2, self:color(ent)).g .. " " .. select(2, self:color(ent)).b)
        end

        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:SetKeyValue("rendercolor", select(3, self:color(ent)).r .. " " .. select(3, self:color(ent)).g .. " " .. select(3, self:color(ent)).b)
        end
    end
})

glowEyes:Register("models/player/combine_super_soldier.mdl", {
    serverInit = function(self, ent)
        if not ( IsValid(ent) ) then
            return
        end
        
        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:Remove()
        end
        
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:Remove()
        end
        
        if ( IsValid(ent.rightEyeGlow) ) then
            ent.rightEyeGlow:Remove()
        end
        
        local attachment = ent:GetAttachment(ent:LookupAttachment("eyes"))
        
        if not ( attachment ) then
            return
        end
        
        local pos = attachment.Pos
        pos = pos + attachment.Ang:Forward() * -0.2
        pos = pos + attachment.Ang:Up() * 1
        
        local eyePos = attachment.Pos
        eyePos = eyePos + attachment.Ang:Forward() * -0.2
        eyePos = eyePos + attachment.Ang:Up() * 0.4
        
        local eColor, gColor = Color(255, 0, 0), Color(255, 0, 0)

        if ( self.color and isfunction(self.color) ) then
            eColor, gColor = self:color(ent)
        end

        ent.leftEyeGlow = ents.Create("env_sprite")
        ent.leftEyeGlow:SetPos(eyePos)
        ent.leftEyeGlow:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.leftEyeGlow:SetKeyValue("rendermode", "9")
        ent.leftEyeGlow:SetKeyValue("renderamt", "255")
        ent.leftEyeGlow:SetKeyValue("rendercolor", eColor.r .. " " .. eColor.g .. " " .. eColor.b)
        ent.leftEyeGlow:SetKeyValue("renderfx", "0")
        ent.leftEyeGlow:SetKeyValue("HDRColorScale", "0.5")
        ent.leftEyeGlow:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
        ent.leftEyeGlow:SetKeyValue("scale", "0.05")
        ent.leftEyeGlow:Spawn()
        
        ent.worldGlowSprite = ents.Create("env_sprite")
        ent.worldGlowSprite:SetPos(pos)
        ent.worldGlowSprite:SetParent(ent, ent:LookupAttachment("eyes"))
        ent.worldGlowSprite:SetKeyValue("rendermode", "9")
        ent.worldGlowSprite:SetKeyValue("renderamt", "110")
        ent.worldGlowSprite:SetKeyValue("rendercolor", gColor.r .. " " .. gColor.g .. " " .. gColor.b)
        ent.worldGlowSprite:SetKeyValue("renderfx", "0")
        ent.worldGlowSprite:SetKeyValue("HDRColorScale", "1")
        ent.worldGlowSprite:SetKeyValue("model", "sun/overlay.vmt")
        ent.worldGlowSprite:SetKeyValue("scale", "0.2")
        ent.worldGlowSprite:Spawn()
        
        timer.Simple(0.1, function()
            local glowTable = {}

            if ( IsValid(ent.leftEyeGlow) ) then
                glowTable[#glowTable + 1] = ent.leftEyeGlow
            end

            if ( IsValid(ent.worldGlowSprite) ) then
                glowTable[#glowTable + 1] = ent.worldGlowSprite
            end
    
            net.Start("glowEyes.NetworkLightsToClientside")
                net.WriteEntity(ent)
                net.WriteTable(glowTable)
            net.Broadcast()

            ent.glowEyesTable = glowTable
        end)
    end,
    color = function(self, ent)
        return ent:GetPlayerColor():ToColor(), ent:GetPlayerColor():ToColor()
    end,
    serverThink = function(self, ent)
        if ( IsValid(ent.leftEyeGlow) ) then
            ent.leftEyeGlow:SetKeyValue("rendercolor", select(1, self:color(ent)).r .. " " .. select(1, self:color(ent)).g .. " " .. select(1, self:color(ent)).b)
        end

        if ( IsValid(ent.worldGlowSprite) ) then
            ent.worldGlowSprite:SetKeyValue("rendercolor", select(2, self:color(ent)).r .. " " .. select(2, self:color(ent)).g .. " " .. select(2, self:color(ent)).b)
        end
    end
})