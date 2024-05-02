AddCSLuaFile()

local ttt_doubleclickbuy = CreateConVar("ttt_doubleclickbuy", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)

if SERVER then
	return
end

local function DoClick(self)
	local systime = SysTime()

	if systime < (self.TTT_DOUBLECLICKBUY_LastClick or 0) + 0.35 -- do people double-click slower than this?
		and systime > (self.TTT_DOUBLECLICKBUY_LastClick or 0) + 0.05 -- prevent crappy mice from making accidental buys
	then
		systime = 0

		local parent = self:GetParent()
		parent = IsValid(parent) and parent:GetParent()

		if IsValid(parent) and parent.SelectedPanel == self then
			local dconfirm = self.TTT_DOUBLECLICKBUY_DConfirm

			if IsValid(dconfirm) then
				dconfirm:DoClick()
			end
		end
	end

	self.TTT_DOUBLECLICKBUY_LastClick = systime

	return self:TTT_DOUBLECLICKBUY_DoClick_Old()
end

hook.Add("TTTEquipmentTabs", "ttt_doubleclickbuy_TTTEquipmentTabs", function(dsheets)
	if not ttt_doubleclickbuy:GetBool() then
		return
	end

	local dequip = dsheets:GetItems()
	dequip = dequip and dequip[1] and dequip[1].Panel

	if not IsValid(dequip) or dequip:GetName() ~= "DPanel" then
		return
	end

	local dlist, dinfobg

	local childs = dequip:GetChildren()

	if CR_VERSION then
		dlist, dinfobg = childs[2], childs[3]
	else
		dlist, dinfobg = childs[1], childs[2]
	end

	if not IsValid(dlist) or dlist:GetName() ~= "EquipSelect"
		or not IsValid(dinfobg) or dinfobg:GetName() ~= "DPanel"
	then
		return
	end

	local dconfirm = dinfobg:GetChildren()[3]

	if not IsValid(dconfirm)
		or dconfirm:GetName() ~= "DButton"
		or dconfirm:GetText() ~= LANG.GetTranslation("equip_confirm")
	then
		return
	end

	for k, v in pairs(dlist:GetItems()) do
		v.TTT_DOUBLECLICKBUY_DConfirm = dconfirm

		v.TTT_DOUBLECLICKBUY_DoClick_Old = v.TTT_DOUBLECLICKBUY_DoClick_Old or v.DoClick

		v.DoClick = DoClick
	end
end)
