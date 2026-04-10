  util.AddNetworkString("TTT2RallyBuffSFX")
  util.AddNetworkString("TTT2RallyExpireSFX")
  
  function SendRallyBuffToClient(ply)
    net.Start("TTT2RallyBuffSFX")
    net.Send(ply)
  end
  
  function SendRallyExpireToClient(ply)
    net.Start("TTT2RallyExpireSFX")
    net.Send(ply)
  end