local mod = {}
function mod.setup()
	require("my.core.picker.fzf").setup()
	require("my.core.picker.mpick").setup()
end
return mod
