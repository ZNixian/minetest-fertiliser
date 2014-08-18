fertiliser = {}
fertiliser.grows = {
	stdtree = function(pos, def)
		if farming~=nil and farming.generate_tree~=nil then
			farming:generate_tree(pos, def[4][1], def[4][2], def[4][3], def[4][4])
        	end
	end,
	jungletree = function(pos, def)
--		farming:generate_tree(pos, def[4][1], def[4][2], def[4][3], def[4][4])
		local nu = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		local is_soil = minetest.get_item_group(nu, "soil")
		if is_soil == 0 then
        		return
		end
		
		print("[fertiliser] spawned "..node.name.." tree")
		local vm = minetest.get_voxel_manip()
        	local minp, maxp = vm:read_from_map({x=pos.x-16, y=pos.y, z=pos.z-16}, {x=pos.x+16, y=pos.y+16, z=pos.z+16})
	 	local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
        	local data = vm:get_data()
        	default.grow_jungletree(data, a, pos, math.random(1,100000))
        	vm:set_data(data)
        	vm:write_to_map(data)
        	vm:update_map()
	end,
<<<<<<< HEAD
	jungletree = function(pos, def)
--		farming:generate_tree(pos, def[4][1], def[4][2], def[4][3], def[4][4])
		local nu = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
        local is_soil = minetest.get_item_group(nu, "soil")
        if is_soil == 0 then
                return
        end
        
		print("[fertiliser] spawned "..node.name.." tree")
        local vm = minetest.get_voxel_manip()
        local minp, maxp = vm:read_from_map({x=pos.x-16, y=pos.y, z=pos.z-16}, {x=pos.x+16, y=pos.y+16, z=pos.z+16})
        local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
        local data = vm:get_data()
        default.grow_jungletree(data, a, pos, math.random(1,100000))
        vm:set_data(data)
        vm:write_to_map(data)
        vm:update_map()
	end,
=======
>>>>>>> origin/master
	moretrees = function(pos, def)
		local node = minetest.get_node(pos)
		print("[fertiliser] spawned "..node.name.." tree")
		--plantslib.growing[def[1]](pos, node, nil, nil)
	end,
	clone = function(pos, def)
		local node = minetest.get_node(pos)
		
		while minetest.get_node(pos).name == node.name do
			pos.y = pos.y + 1
		end
		
		if minetest.get_node(pos).name=="air" then
			minetest.set_node(pos, node)
			return true
		end
		return false
	end,
}
fertiliser.saplings = {
	{
		"default:sapling",  --  name
		5,					--  chance
		fertiliser.grows.stdtree,
		{
			"default:tree",
			"default:leaves",
			{"default:dirt", "default:dirt_with_grass"},
			{},
		},
	},
	{
		"default:junglesapling",  --  name
		5,					--  chance
		fertiliser.grows.jungletree,
		{
			"default:tree",
			"default:leaves",
			{"default:dirt", "default:dirt_with_grass"},
			{},
		},
	},
	{
		"farming_plus:banana_sapling",
		5,
		fertiliser.grows.stdtree,
		{
			"default:tree",
			"farming_plus:banana_leaves",
			{"default:dirt", "default:dirt_with_grass"},
			{["farming_plus:banana"]=20},
		},
	},
	{
		"farming_plus:cocoa_sapling",
		5,
		fertiliser.grows.stdtree,
		{
			"default:tree",
			"farming_plus:cocoa_leaves",
			{"default:sand", "default:desert_sand"},
			{["farming_plus:cocoa"]=20},
		},
	},
	{
		"default:cactus",
		1,
		fertiliser.grows.clone,
	},
	{
		"default:papyrus",
		1,
		fertiliser.grows.clone,
	},
}

minetest.after(0, function()
	
	for name, def in pairs(minetest.registered_nodes) do
		if def.grow ~= nil then
			fertiliser.saplings[#fertiliser.saplings + 1] = {
				name,
				1,
				def.grow,
			}
		end
	end
	
	local register = function(val)
		for i = 1, #val.names do
			local name = val.names[i]
			fertiliser.saplings[#fertiliser.saplings + 1] = {
				name,
				1,
				function(pos, def)
					minetest.set_node(pos, {name = (val.names[i+1] or val.full_grown)})
				end,
			}
		end
	end
	
	if farming.registered_plants~=nil then
		for _, val in ipairs(farming.registered_plants) do
			register(val)
		end
	end
	
	local names = {"farming:wheat_1",
					"farming:wheat_2",
					"farming:wheat_3",
					"farming:wheat_4",
					"farming:wheat_5",
					"farming:wheat_6",
					"farming:wheat_7"}
	
	register( {
		full_grown = "farming:wheat_8",
		names = names
	})
	
	names = {		"farming:cotton_1",
					"farming:cotton_2",
					"farming:cotton_3",
					"farming:cotton_4",
					"farming:cotton_5",
					"farming:cotton_6",
					"farming:cotton_7"}
	
	register( {
		full_grown = "farming:cotton_8",
		names = names
	})
	
	-------------  more trees
	
	if minetest.get_modpath("moretrees")~=nil then
--		local tree_table = {
--						{moretrees.spawn_beech_object,},
--						{moretrees.spawn_apple_tree_object,},
--						{moretrees.spawn_oak_object,},
--						{moretrees.spawn_sequoia_object,},
--						{moretrees.spawn_palm_object,},
--						{moretrees.spawn_pine_object,},
--						{moretrees.spawn_rubber_tree_object,},
--						{moretrees.spawn_willow_object,},
--						{moretrees.spawn_birch_object,},
--						{moretrees.spawn_spruce_object,},
--						{moretrees.spawn_jungletree_object,},
--						{moretrees.spawn_fir_object, moretrees.spawn_fir_snow_object},
--					}
--		for i=1, #tree_table do
		for i=1, #moretrees.treelist do
			fertiliser.saplings[#fertiliser.saplings + 1] = {
				"moretrees:"..moretrees.treelist[i][1].."_sapling",
				moretrees.sapling_interval * moretrees.sapling_chance / 500,
				function(pos, def)
					minetest.remove_node(pos)
					local treename = moretrees.treelist[i][1]
					local tree_model = treename.."_model"
					local tree_biome = treename.."_biome"
					local node_or_function_or_model = moretrees[tree_model]
					if node_or_function_or_model==nil then
						node_or_function_or_model = "moretrees:grow_" .. treename
					end
					plantslib:replace_object(pos, nil, node_or_function_or_model, nil, nil)
					
--					if type(node_or_function_or_model) == "table" then
--						plantslib:dbg("Spawn tree at {"..dump(pos).."}")
--						plantslib:generate_tree(pos, node_or_function_or_model)
--					elseif type(node_or_function_or_model) == "string" then
--						if not minetest.registered_nodes[node_or_function_or_model] then
--							plantslib:dbg("Call function: "..node_or_function_or_model.."("..dump_pos(pos)..")")
--							local t2=os.clock()
--							assert(loadstring(node_or_function_or_model.."("..dump_pos(pos)..")"))()
--							plantslib:dbg("Executed that function in ".. (os.clock()-t2)*1000 .."ms")
----						else
----							plantslib:dbg("Add node: "..node_or_function_or_model.." at ("..dump(p_top)..")")
----							minetest.add_node(pos, { name = node_or_function_or_model })
--						end
--					end
					
				end,
			}
		end
	end
end)

minetest.register_craftitem("fertiliser:fertiliser", {
	description = "Fertiliser",
	inventory_image = "fertiliser_fertiliser.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" then
			local pos = pointed_thing.under
			local node = minetest.get_node(pos)
			for i=1, #fertiliser.saplings do
				local def = fertiliser.saplings[i]
				if node.name==def[1] then
					local try = true
					if user:get_player_control().sneak==true then
						if itemstack:get_count() < def[2] then
							return
						end
					else
						if math.random(def[2])~=1 then
							try = false
						end
					end
					if try==true then
						local res = def[3](pos, def)
					end
					if res~=false then
						if user:get_player_control().sneak==true then
							for i=1, def[2] do
								itemstack:take_item()
							end
						else
							itemstack:take_item()
						end
					end
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
    output = 'fertiliser:fertiliser 9',
    recipe = {
        {'default:dirt',	'default:dirt',			'default:dirt'},
        {'default:dirt',	'bones:single_bone',	'default:dirt'},
        {'default:dirt',	'default:dirt',			'default:dirt'},
    },
})

minetest.register_craft({
    output = 'bones:bones',
    recipe = {
        {'bones:single_bone', 'bones:single_bone', 'bones:single_bone'},
        {'bones:single_bone', 'bones:single_bone', 'bones:single_bone'},
        {'bones:single_bone', 'bones:single_bone', 'bones:single_bone'},
    },
})

minetest.register_craft({
	type = 'shapeless',
    output = 'bones:single_bone 9',
    recipe = {'bones:bones'},
})

minetest.register_craftitem(":bones:single_bone", {
	description = "Single Bone",
	inventory_image = "fertiliser_bone.png",
})
