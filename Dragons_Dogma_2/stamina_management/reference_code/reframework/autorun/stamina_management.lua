
local re = re       -- reframework
local sdk = sdk     -- sdk
local d2d = d2d     -- d2d
local imgui = imgui -- imgui
local log = log     -- log
local json = json   -- json
local draw = draw   -- draw

log.info("[stamina_management] Loaded");

local BattleManager = sdk.get_managed_singleton("app.BattleManager")
local function GetBattleManager()
    if BattleManager == nil then BattleManager = sdk.get_managed_singleton("app.BattleManager") end
	return BattleManager
end

local isInfiniteStamina = false

if BattleManager then
    isInfiniteStamina = not BattleManager:call("get_IsBattleMode()");
    log.info("set_IsInFollowerNPCCombat = " .. tostring(isInfiniteStamina))
end


local PlayerManager = sdk.get_managed_singleton("app.CharacterManager")
local function GetPlayerManager()
    if PlayerManager == nil then PlayerManager = sdk.get_managed_singleton("app.CharacterManager") end
	return PlayerManager
end

local StaminaManager = sdk.get_managed_singleton("app.StaminaManager")
local function GetStaminaManager()
    if StaminaManager == nil then StaminaManager = sdk.get_managed_singleton("app.StaminaManager") end
	return StaminaManager
end

re.on_frame(function ()
    isInfiniteStamina = not BattleManager:call("get_IsBattleMode()");
	if not isInfiniteStamina then return end

    local playerMgr = GetPlayerManager();
    if playerMgr then
        local player = playerMgr:call("get_ManualPlayer()");
        if player then
            local human = player:get_Human();
            if human and human:get_IsDrawedWeapon() then
                return
            end

            local mgr = player:call('get_StaminaManager()');
            if mgr then
                mgr:call("recoverAll()")
            end
        end
    end
end)

