

1.if myHero.charName ~= "Zac" then return end


2.--[[


3.        Zac: What about Flubber!


4.        by: Tux


5.        Made with Simple Minion Marker by Kilua


6.--]]


7. 


8.local ts = TargetSelector(TARGET_LOW_HP,600,DAMAGE_MAGIC,true)


9.local qrRange = 550


10.local wRange = 275


11.local eRange = 


12.function OnLoad()


13.    ZacConfig = scriptConfig("What about Flubber!", "ZacCombo")


14.    ZacConfig:addParam("Active", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)


15.    ZacConfig:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))


16.    ZacConfig:addParam("KS", "Auto KS", SCRIPT_PARAM_ONOFF, true)


17.        ZacConfig:addParam("Ignite", "Ignite Killable Target", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("Z"))


18.        ZacConfig:addParam("Marker", "Minion Marker", SCRIPT_PARAM_ONOFF, true)


19.        ZacConfig:addParam("DoubleIgnite", "Don't Double Ignite", SCRIPT_PARAM_ONOFF, true)


20.    ZacConfig:addParam("Movement", "Move to Mouse", SCRIPT_PARAM_ONOFF, true)


21.    ZacConfig:addParam("DrawCircles", "Draw Circles", SCRIPT_PARAM_ONOFF, true)


22.    ZacConfig:addParam("Ultimate", "Use Ultimate", SCRIPT_PARAM_ONOFF, false)


23.        ZacConfig:permaShow("Active")


24.        ZacConfig:permaShow("Harass")


25.        ZacConfig:permaShow("Ultimate")


26.        ZacConfig:permaShow("Ignite")


27.    ts.name = "Zac"


28.    ZacConfig:addTS(ts)


29.    PrintChat(">> Zac - What about Flubber! v1.1 loaded! <<")


30.        MinionMarkerOnLoad()


31.        if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ign = SUMMONER_1


32.        elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ign = SUMMONER_2


33.                else ign = nil


34.        end


35.end


36. 


37.function OnCreateObj(obj)


38.        if ZacConfig.Marker then


39.                MinionMarkerOnCreateObj(obj)


40.        end


41.end


42. 


43.function CanCast(Spell)


44.    return (player:CanUseSpell(Spell) == READY)


45.end


46. 


47.function IReady()


48.        if ign ~= nil then


49.                return (player:CanUseSpell(ign) == READY)


50.        end


51.end


52. 


53.function AutoIgnite()


54.        local iDmg = 0          


55.        if ign ~= nil and IReady and not myHero.dead then


56.                for i = 1, heroManager.iCount, 1 do


57.                        local target = heroManager:getHero(i)


58.                        if ValidTarget(target) then


59.                                iDmg = 50 + 20 * myHero.level


60.                                if target ~= nil and target.team ~= myHero.team and not target.dead and target.visible and GetDistance(target) < 600 and target.health < iDmg then


61.                                        if ZacConfig.DoubleIgnite and not TargetHaveBuff("SummonerDot", target) then


62.                                                CastSpell(ign, target)


63.                                                elseif not ZacConfig.DoubleIgnite then


64.                                                        CastSpell(ign, target)


65.                                        end


66.                                end


67.                        end


68.                end


69.        end


70.end 


71. 


72.function OnTick()


73.        ts:update()


74.        if ZacConfig.Ignite then AutoIgnite() end


75.        if ZacConfig.KS then AutoKS() end


76.        if ZacConfig.Active then Combo() end


77.        if ZacConfig.Harass then Harassment() end


78.        if ZacConfig.Movement and (ZacConfig.Active or ZacConfig.Harass) and ts.target == nil then myHero:MoveTo(mousePos.x, mousePos.z)


79.    end


80.end


81. 


82.function OnDraw()


83.        if ZacConfig.DrawCircles and not myHero.dead then


84.                DrawCircle(myHero.x,myHero.y,myHero.z,550,0xFFFF0000)


85.                DrawCircle(myHero.x,myHero.y,myHero.z,550,0xFFFF0000)


86.        end


87.        if ZacConfig.Marker then


88.                MinionMarkerOnDraw()


89.        end


90.end


91. 


92.--[[


93.        Combat


94.--]]


95. 


96.function getPred(speed, delay, target)


97.        if ts.target == nil then return nil end


98.        local travelDuration = (delay + GetDistance(myHero, target)/speed)


99.        travelDuration = (delay + GetDistance(GetPredictionPos(target, travelDuration))/speed)


100.        travelDuration = (delay + GetDistance(GetPredictionPos(target, travelDuration))/speed)


101.        travelDuration = (delay + GetDistance(GetPredictionPos(target, travelDuration))/speed)  


102.        return GetPredictionPos(target, travelDuration)


103.end


104. 


105.function Combo()


106.        local qPred = getPred(2.5, 110, ts.target)


107.        local rPred = getPred(1.8, 240, ts.target)


108.        local enemyHealth = target.health


109.        if ValidTarget(ts.target, qrRange) and qPred ~= nil and CanCast(_Q) then


110.                CastSpell(_Q, qPred.x, qPred.z)


111.                elseif ValidTarget(ts.target, wRange) and CanCast(_W) then


112.                        CastSpell(_W, ts.target)


113.                elseif ZacConfig.Ultimate and ValidTarget(ts.target, qrRange) and rPred ~= nil and CanCast(_R) then


114.                        CastSpell(_R, rPred.x, rPred.z)


115.                elseif not ZacConfig.Ultimate and target ~= nil and not target.dead and target.team ~= player.team and target.visible and GetDistance(target) < 550 then


116.                        rDmg = getDmg("R", target, player)


117.                        if rPred ~= nil and enemyHealth < rDmg*2.8 and CanCast(_R) then


118.                                CastSpell(_R, rPred.x, rPred.z)


119.                elseif ValidTarget(ts.target, 500) then


120.                        myHero:Attack(ts.target)


121.                end


122.        end


123.end


124. 


125.function Harassment()


126.        local qPred = getPred(2.5, 110, ts.target)


127.        if ValidTarget(ts.target, wRange) and CanCast(_W) then


128.                CastSpell(_W, ts.target)


129.        elseif ValidTarget(ts.target, qrRange) and qPred ~= nil and CanCast(_Q) then


130.                CastSpell(_Q, qPred.x, qPred.z)


131.        elseif ValidTarget(ts.target, 500) then


132.                myHero:Attack(ts.target)


133.        end


134.end


135. 


136.function AutoKS()


137.        local qPred = getPred(2.5, 110, ts.target)


138.    for i=1, heroManager.iCount do


139.    target = heroManager:GetHero(i)


140.        wDmg = getDmg("W", target, player)


141.        qDmg = getDmg("Q", target, player)


142.                if target ~= nil and not target.dead and target.team ~= player.team and target.visible and GetDistance(target) < 350 then


143.                        if qPred ~= nil and target.health < wDmg + qDmg and CanCast(_W) and CanCast(_Q) then


144.                                CastSpell(_W, target)


145.                                CastSpell(_Q, qPred.x, qPred.z)


146.                        end


147.                end


148.                if ts.target ~= nil and not target.dead and target.team ~= player.team and target.visible and GetDistance(ts.target) < 350 then


149.                        if target.health < qDmg and CanCast(_Q) then


150.                                CastSpell(_Q, qPred.x, qPred.z)


151.                        end


152.                end


153.        end


154.end


155. 


156.--[[


157.        Simple Minion Marker


158.        by: Kilua


159.--]]


160. 


161.function MinionMarkerOnLoad()


162.        minionTable = {}


163.        for i = 0, objManager.maxObjects do


164.                local obj = objManager:GetObject(i)


165.                if obj ~= nil and obj.type ~= nil and obj.type == "obj_AI_Minion" then 


166.                        table.insert(minionTable, obj) 


167.                end


168.        end


169.end


170. 


171.function MinionMarkerOnDraw() 


172.        for i,minionObject in ipairs(minionTable) do


173.                if minionObject.valid and (minionObject.dead == true or minionObject.team == myHero.team) then


174.                        table.remove(minionTable, i)


175.                        i = i - 1


176.                elseif minionObject.valid and minionObject ~= nil and myHero:GetDistance(minionObject) ~= nil and myHero:GetDistance(minionObject) < 1500 and minionObject.health ~= nil and minionObject.health <= myHero:CalcDamage(minionObject, myHero.addDamage+myHero.damage) and minionObject.visible ~= nil and minionObject.visible == true then


177.                        for g = 0, 6 do


178.                                DrawCircle(minionObject.x, minionObject.y, minionObject.z,80 + g,255255255)


179.                        end


180.        end


181.    end


182.end


183. 


184.function MinionMarkerOnCreateObj(object)


185.        if object ~= nil and object.type ~= nil and object.type == "obj_AI_Minion" then table.insert(minionTable, object) end


186.end

