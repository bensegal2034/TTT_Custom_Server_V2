local muteTime = CreateConVar("sabotage_dart_time", 15, FCVAR_ARCHIVE, "How long to mute all players.");
if ( SERVER ) then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_sabotage.vtf")
	resource.AddFile("materials/vgui/ttt/icon_sabotage.vmt")
    resource.AddFile("sound/weapons/sabotage/sabo3.wav")
    resource.AddFile("sound/weapons/sabotage/sabo_end.wav")
end

SWEP.Icon = "VGUI/ttt/icon_sabotage";
SWEP.EquipMenuData = {
    name = "Comms Sabotage",
    type = "Weapon",
    desc = "Mute all players discord for " .. muteTime:GetInt() .. " seconds."
};
SWEP.Author = "amongu"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.HoldType = "normal"
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.IsSilent = false
SWEP.UseHands = false
SWEP.LimitedStock = true;
SWEP.Primary.Ammo = "none"
SWEP.AmmoEnt = ""
SWEP.PrintName = "Sabotage"

SWEP.Kind = WEAPON_EQUIP
SWEP.Slot = 7

SWEP.ViewModel = "models/weapons/gamefreak/v_buddyfinder.mdl"
SWEP.WorldModel = ""

SWEP.Primary.Delay = 0.4
SWEP.Primary.ClipSize = 1;
SWEP.Primary.ClipMax = 1;
SWEP.Primary.DefaultClip = 1;

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    if not self:CanPrimaryAttack() then return end

	self:DoSATMAnimation(true)
	-- Don't allow flicker-tracks that prevent the tracked player from responding
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:TakePrimaryAmmo(1)
    local muteTime = muteTime:GetInt();
    local owner = self:GetOwner()

    for _, muteply in ipairs(player.GetAll()) do
        muteply:PrintMessage(HUD_PRINTCENTER, "Shhhh...");
        hook.Run("MutePlayer", muteply, muteTime);
        if CLIENT then
            surface.PlaySound("weapons/sabotage/sabo3.wav")
        end
        timer.Simple(muteTime, function()
            if not IsValid(muteply) 
            or not muteply:Alive() then 
                return 
            end
            if CLIENT then
                surface.PlaySound("weapons/sabotage/sabo_end.wav")
            end
        end)
    end
    if SERVER then
        if IsValid(owner) then
            owner:PrintMessage(HUD_PRINTTALK, "Comms Sabotaged! All players muted for 15 seconds.");
            timer.Simple(muteTime, function()
                if not IsValid(owner)
                or not owner:Alive() then
                    return
                else 
                    owner:PrintMessage(HUD_PRINTTALK, "Comms Restored! All players unmuted!");
                end
            end)
        end
    end
end

function SWEP:DoSATMAnimation(bool)
    local switchweapon = bool
	self:SetNextPrimaryFire(CurTime() + 0.4)
	self:SetNextSecondaryFire(CurTime() + 0.4)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	timer.Simple(0.3, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_IDLE)
            if switchweapon && CLIENT && IsValid(self.Owner) && self.Owner == LocalPlayer() && self.Owner:Alive() then
				RunConsoleCommand("lastinv")
			end
            if SERVER && self:Clip1() <= 0 then
				self:Remove()
			end
		end
	end)
end