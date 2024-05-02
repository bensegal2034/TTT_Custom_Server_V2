-- ==========================
-- Weapon Quick-Swap Mod
-- Translations
-- @Author: ValsdalV
-- ==========================

-- Red chat message style
LANG.SetStyle("wqs_no_drop", "chat_warn")
LANG.SetStyle("wqs_same_weapon", "chat_warn")
LANG.SetStyle("wqs_no_pickup", "chat_warn")

local EN, IT = LANG.Strings.english, LANG.Strings.italiano

-- Can't drop equipped weapon
EN.wqs_no_drop = "The weapon you are carrying can't be dropped!"
IT.wqs_no_drop = "L'arma che stai trasportando non può essere gettata!"

-- Already carrying this class
EN.wqs_same_weapon = "You are already carrying this type of weapon!"
IT.wqs_same_weapon = "Possiedi già un'arma di questo tipo!"

-- Generic failure message
EN.wqs_no_pickup = "You can't pick up this weapon!"
IT.wqs_no_pickup = "Non puoi raccogliere quest'arma!"
