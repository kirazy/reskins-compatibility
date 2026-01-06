if mods["extendedangels"] then
	data:extend({
		{
			type = "bool-setting",
			name = "reskins-compatibility-extendedangels-warehouse-tiering",
			setting_type = "startup",
			default_value = true,
		},
	})
end
