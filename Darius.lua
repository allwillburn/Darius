local ver = "0.04"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Darius" then return end

require("OpenPredict")
require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Darius/master/Darius.lua', SCRIPT_PATH .. 'Darius.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Darius/master/Darius.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local DariusE = { delay = 0.25, speed = math.huge, width = 300, range = 450, angle = 35 }

local DariusMenu = Menu("Darius", "Darius")

DariusMenu:SubMenu("Combo", "Combo")

DariusMenu.Combo:Boolean("Q", "Use Q in combo", true)
DariusMenu.Combo:Boolean("AA", "Use AA in combo", true)
DariusMenu.Combo:Boolean("W", "Use W in combo", true)
DariusMenu.Combo:Boolean("E", "Use E in combo", true)
DariusMenu.Combo:Slider("Epred", "E Hit Chance", 3,0,10,1)
DariusMenu.Combo:Boolean("R", "Use R in combo", true)
DariusMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
DariusMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
DariusMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
DariusMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
DariusMenu.Combo:Boolean("RHydra", "Use RHydra", true)
DariusMenu.Combo:Boolean("THydra", "Use THydra", true)
DariusMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
DariusMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
DariusMenu.Combo:Boolean("Randuins", "Use Randuins", true)


DariusMenu:SubMenu("AutoMode", "AutoMode")
DariusMenu.AutoMode:Boolean("Level", "Auto level spells", false)
DariusMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
DariusMenu.AutoMode:Boolean("Q", "Auto Q", false)
DariusMenu.AutoMode:Boolean("W", "Auto W", false)
DariusMenu.AutoMode:Boolean("E", "Auto E", false)
DariusMenu.AutoMode:Boolean("R", "Auto R", false)

DariusMenu:SubMenu("LaneClear", "LaneClear")
DariusMenu.LaneClear:Boolean("Q", "Use Q", true)
DariusMenu.LaneClear:Boolean("W", "Use W", true)
DariusMenu.LaneClear:Boolean("E", "Use E", true)
DariusMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
DariusMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

DariusMenu:SubMenu("Harass", "Harass")
DariusMenu.Harass:Boolean("Q", "Use Q", true)
DariusMenu.Harass:Boolean("W", "Use W", true)

DariusMenu:SubMenu("KillSteal", "KillSteal")
DariusMenu.KillSteal:Boolean("Q", "KS w Q", true)
DariusMenu.KillSteal:Boolean("E", "KS w E", true)
DariusMenu.KillSteal:Boolean("R", "KS w R", true)


DariusMenu:SubMenu("AutoIgnite", "AutoIgnite")
DariusMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

DariusMenu:SubMenu("Drawings", "Drawings")
DariusMenu.Drawings:Boolean("DQ", "Draw Q Range", true)
DariusMenu.Drawings:Boolean("rhpdraw", "rhpdraw", true)

DariusMenu:SubMenu("SkinChanger", "SkinChanger")
DariusMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
DariusMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local THydra = GetItemSlot(myHero, 3748)
	




	--AUTO LEVEL UP
	if DariusMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if DariusMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if DariusMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if DariusMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if DariusMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if DariusMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if DariusMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if DariusMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 450) then
                local EPred = GetPrediction(target,DariusE)
                       if EPred.hitChance > (DariusMenu.Combo.Epred:Value() * 0.1) then
                                 CastSkillShot(_E,EPred.castPos)
                       end
           end
              

            if DariusMenu.Combo.AA:Value() and ValidTarget(target, 175) then
                         AttackUnit(target)
            end

            if DariusMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastSpell(_W)
	    end

            if DariusMenu.Combo.AA:Value() and ValidTarget(target, 175) then
                         AttackUnit(target)
            end

            if DariusMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 425) then
		     if target ~= nil then 
                         CastSpell(_Q)
                     end
            end

            if DariusMenu.Combo.AA:Value() and ValidTarget(target, 175) then
                         AttackUnit(target)
            end


            if DariusMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if DariusMenu.Combo.AA:Value() and ValidTarget(target, 175) then
                         AttackUnit(target)
            end


            if DariusMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if DariusMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

            if DariusMenu.Combo.THydra:Value() and THydra > 0 and Ready(THydra) and ValidTarget(target, 400) then
			CastSpell(THydra)
            end	

            if DariusMenu.Combo.AA:Value() and ValidTarget(target, 175) then
                         AttackUnit(target)
            end
	    
	    
            if DariusMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 460) and (EnemiesAround(myHeroPos(), 460) >= DariusMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 425) and DariusMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSpell(_Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 450) and DariusMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSkillShot(_E, target)
  
                end
			
		if IsReady(_R) and ValidTarget(enemy, 460) and DariusMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                      CastTargetSpell(target, _R)
  
                end
	

               
end
      

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if DariusMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 425) then
	        	CastSpell(_Q)
                end

                if DariusMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 450) then
	        	CastSpell(_W)
	        end

                if DariusMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 450) then
	        	CastSkillShot(_E, closeminion)
	        end

                if DariusMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if DariusMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end

       function Qorb()
  local target = GetCurrentTarget()
  if target ~= nil and qCasting then
    local pos = myHero - (Vector(target) - myHero):normalized() * 307.5 
    if GetDistance(myHero, target) >= 307.5 then
      MoveToXYZ(GetOrigin(target))
    elseif GetDistance(myHero, target) <= 307.5 then
      MoveToXYZ(pos)
    end
  end
end      

        --AutoMode
        if DariusMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 425) then
		      CastSpell(_Q)
          end
        end 
        if DariusMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 450) then
	  	      CastSpell(_W)
          end
        end
        if DariusMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 450) then
		      CastSpell(_E)
	  end
        end
        if DariusMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 460) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if DariusMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
    
 		
			
end)
	

OnDraw(function (myHero)
        
         if DariusMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 425, 0, 200, GoS.Red)
	end

       

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
             

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if DariusMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Darius</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





