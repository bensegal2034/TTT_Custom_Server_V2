if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Pre Nerf"
ATTACHMENT.Description = {TFA.AttachmentColors["="],"ACOG Not Included",TFA.AttachmentColors["+"],"Decrease S P R E A D and Recoil by ALOT"}
ATTACHMENT.Icon = "entities/r6s_meatball.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "ACOG GOOD"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
                ["KickUp"] = function( wep, stat ) return stat * 0.55 end,
                ["KickHorizontal"] = function( wep, stat ) return stat * 0.25 end,				
				["Spread"] = function( wep, stat ) return stat * 0.45 end,		
                ["SpreadMultiplierMax"] = function( wep, stat ) return stat * 0.75 end,
				["SpreadRecovery"] = function( wep, stat ) return stat * 1.075 end,	
				["SpreadIncrement"] = function( wep, stat ) return stat * 0.85 end,									
        }
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end