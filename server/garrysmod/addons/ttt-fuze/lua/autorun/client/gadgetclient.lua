print("client")

surface.CreateFont( "EE", {

	size = 20,
	weight = 1200,
	shadow = true,
	outline = true,

})

hook.Add( "HUDPaint", "PickUp", function()
	if LocalPlayer():GetEyeTrace().Entity:IsValid() then
		if LocalPlayer():GetEyeTrace().Entity:GetClass() == "matryoshka" then
			local trace = LocalPlayer():GetEyeTrace()
			if math.Distance(trace.StartPos.x,trace.StartPos.y,trace.HitPos.x,trace.HitPos.y) <= 70 then
				draw.DrawText( "[E]", "EE", ScrW() * 0.5, ScrH() * 0.53, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
		end
	end
end)