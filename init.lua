--------------------------------------------------------
-- Minetest :: Bedrock Markup Language (bedrock)
--
-- See README.txt for licensing and other information.
-- Copyright (c) 2016-2019, Leslie Ellen Krause
--
-- ./games/just_test_tribute/mods/markup/init.lua
--------------------------------------------------------

markup = { }

local registered_icons = {
	happy = "emoji_happy.png",
	silly = "emoji_silly.png",
	annoyed = "emoji_annoyed.png",
	mad = "emoji_mad.png",
	hungry = "emoji_hungry.png",
	amused = "emoji_amused.png",
	disappointed = "emoji_disappointed.png",
	cool = "emoji_cool.png",
	smug = "emoji_smug.png",
	confused = "emoji_confused.png",
	angry = "emoji_angry.png",
	cheerful = "emoji_cheerful.png",
	frustrated = "emoji_frustrated.png",
	surprised = "emoji_surprised.png",
	sad = "emoji_sad.png",
	smitten = "emoji_smitten.png",
	laughing = "emoji_laughing.png",
	kissing = "emoji_kissing.png",
	crying = "emoji_crying.png",
	sleeping = "emoji_sleeping.png",
	heart = "emoji_heart.png",
	cupid_heart = "emoji_cupid_heart.png",
	black_heart = "emoji_black_heart.png",
	frozen_heart = "emoji_frozen_heart.png",
	heartbreak = "emoji_heartbreak.png",
	warning = "emoji_warning.png",
	danger = "emoji_danger.png",
	keep_out = "emoji_keep_out.png",
	cone = "emoji_cone.png",
	lock = "emoji_lock.png",
	left_arrow = "emoji_left_arrow.png",
	right_arrow = "emoji_right_arrow.png",
}

function table.get_index( self, sel_val, def_idx )
	for idx, val in ipairs( self ) do
		if val == sel_val then return idx end
	end
	return def_idx
end

markup.get_builtin_vars = function ( player_name )
	local player = minetest.get_player_by_name( player_name )

	return {
		["$name"] = player_name,
		["$hash"] = cipher.tokenize( cipher.get_checksum( player_name ) ),
		["$rank"] = default.rank_to_string( default.get_player_rank( player_name ) ),
		["$item"] = player:get_wielded_item( ):get_name( ),
		["$skin"] = skins.skins[ player_name ],
		["$home"] = minetest.pos_to_string( beds.player_pos[ player_name ] or default.spawn_pos ),
		["$lifetime"] = math.floor( player:get_lifetime( ) / 60 ),
		["$uptime"] = math.floor( minetest.get_server_info( ).uptime / 60 ),
		["$time"] = minetest.get_time_string( ),
		["$date"] = minetest.get_date_string( ),
		["$cur_users"] = #default.player_list,
		["$max_users"] = minetest.setting_get( "max_users" ),
	}
end

markup.parse_message = function ( message, vars )
	local text_colors = { cyan = "#44FFFF", magenta = "#FF44FF", yellow = "#FFFF44", red = "#FF4444", green = "#00DD00", blue = "#0000DD", black = "#000000", gray = "#AAAAAA" }

	-- preprocess the table tags (we should use tokenizer!)

	message = string.gsub( message, "%[r", "[rn" ) -- normal
	message = string.gsub( message, "%[b", "[rb" ) -- border
	message = string.gsub( message, "%[h", "[rh" ) -- header

	message = string.gsub( message, "%[c", "[ct" ) -- text
	message = string.gsub( message, "%[i", "[ci" ) -- item
	message = string.gsub( message, "%[s", "[cs" ) -- skin
	message = string.gsub( message, "%[f", "[cf" ) -- form

	local rows = { }
	local input_rows = string.split( message, "[r", true )

	local r_types = { n = "normal", b = "border", h = "header" }
	local c_types = { t = "text", i = "item", s = "skin", f = "form" }

	for r_idx, r_val in ipairs( input_rows ) do

		local p, v, t = string.match( r_val, "^(.)=(%d+)%](.*)" )
		local type = "normal"
		local vert = 0.0
		if v then
			vert = tonumber( v ) / 2
			type = r_types[ p ]
			r_val = t
		else
			r_val = string.gsub( r_val, "^(.)=?%]", function ( p )
				type = r_types[ p ]
				return ""
			end )	-- allow default tags
		end
		r_val = string.trim( r_val )

		if t or r_val ~= "" then
			local cols = { }
			local input_cols = string.split( r_val, "[c", true )

			for c_idx, c_val in ipairs( input_cols ) do

				local p, h, t = string.match( c_val, "^(.)=(%d+)%](.*)" )
				local type = "text"
				local horz = 0.0
				if h then
					horz = tonumber( h ) / 2
					type = c_types[ p ]
					c_val = t
				else
					c_val = string.gsub( c_val, "^(.)=?%]", function ( p )
						type = c_types[ p ]
						return ""
					end )	-- allow default tags
				end

				c_val = string.trim( c_val )
				if t or c_val ~= "" then
					c_val = string.gsub( c_val, "%$[a-zA-Z_]+", vars )	-- interpolate variables
				--	c_val = string.gsub( c_val, "[^\]%[.-%]", "" )		-- strip undefined tags?

					if type == "text" then
						local text = string.gsub( c_val, "%[q=([a-z]+)%](.-)%[/q%]", function ( code, text )
							return text_colors[ code ] and minetest.colorize( text_colors[ code ], text ) or "?" .. text
						end )
						table.insert( cols, { horz = horz, text = text, type = type } )

					elseif type == "form" then
						local text = string.gsub( c_val, "%[q[^%]]*%]", "" )
						table.insert( cols, { horz = horz, text = text, type = type } )

					elseif type == "item" and string.find( c_val, "^[a-zA-Z0-9_]+:[a-zA-Z0-9_]+$" ) then
						local itemdef = minetest.registered_items[ c_val ] or ":unknown"
						local text = "unknown_item.png"
						if itemdef.type == "tool" or itemdef.type == "craft" then
							text = itemdef.inventory_image
						elseif itemdef.tiles then
							text = itemdef.tiles[ 1 ]
						end
						table.insert( cols, { horz = horz, text = text, type = type } )

					elseif type == "item" and string.find( c_val, "^:[a-zA-Z0-9_]+$" ) then
						local text = registered_icons[ string.sub( c_val, 2 ) ] or "emoji_unknown.png"
						table.insert( cols, { horz = horz, text = text, type = type } )

					elseif type == "skin" and string.find( c_val, "^character_%d+$" ) then
						local text = skins.meta[ c_val ] and c_val .. "_preview.png" or "character_preview.png"
						table.insert( cols, { horz = horz, text = text, type = type } )

					elseif type == "icon" and string.find( c_val, "^%w+$" ) then
					end
				end
			end
			table.insert( rows, { vert = vert, cols = cols, type = type } )
		end
	end

	return rows
end

markup.get_formspec_string = function ( rows, min_horz, min_vert, max_horz, max_vert, border_color, header_color )
	-- now render all the cells of the table

	local formspec = ""
	local def_depths = { header = 0.5, border = 0.5 }
	local def_widths = { item = 1.0, skin = 1.0 }
	local vert_margins = { header = 0.15, border = 0.15 }

	local off_vert = min_vert

	for r_idx, r in ipairs( rows ) do
		if off_vert >= max_vert then break end	-- don't overrun the page bounds

		local depth = r.vert == 0 and def_depths[ r.type ] or r.vert

		if depth == 0 then
			-- rows are evenly spaced by default
			depth = math.max( ( max_vert - off_vert ) / ( #rows - r_idx + 1 ), 0.5 )
		end
		if off_vert + depth > max_vert then
			-- crop oversized row to remaining space
			depth = max_vert - off_vert
		end

		local off_horz = min_horz

		if r_idx > 1 and vert_margins[ r.type ] then
			off_vert = off_vert + vert_margins[ r.type ]
		end

		if r.type == "border" then
			formspec = formspec ..
				string.format( "box[%0.2f,%0.2f;%0.2f,%0.2f;%s]", off_horz - 0.5, off_vert, max_horz - off_horz + 0.2, depth + 0.1, border_color )
			off_vert = off_vert + 0.1

		elseif r.type == "header" then
			formspec = formspec ..
				string.format( "box[%0.2f,%0.2f;%0.2f,%0.2f;%s]", off_horz - 0.4, off_vert + depth - 0.05, max_horz - off_horz, 0.05, header_color )
		end

		for c_idx, c in ipairs( r.cols ) do
			if off_horz >= max_horz then break end  -- don't overrun page bounds

			local width = c.horz == 0 and def_widths[ c.type ] or c.horz

			if width == 0 then
				-- columns are evenly spaced by default
				width = math.max( ( max_horz - off_horz ) / ( #r.cols - c_idx + 1 ), 0.5 )
			end
			if off_horz + width > max_horz then
				-- never crop oversized column
				break
			end

			if c.type == "text" then
				if r.type == "header" then
					formspec = formspec ..
						string.format( "textarea[%0.2f,%0.2f;%0.2f,%0.2f;;%s;]", off_horz + 0.0, off_vert, width, depth + depth / 6,
							minetest.formspec_escape( c.text ) )
				end

				formspec = formspec ..
					-- correct for oddity with textarea stretching
					string.format( "textarea[%0.2f,%0.2f;%0.2f,%0.2f;;%s;]", off_horz, off_vert, width, depth + depth / 6,
						minetest.formspec_escape( c.text ) )

			elseif c.type == "form" then
				formspec = formspec .. string.format( "field[%0.1f,%0.1f;%0.1f,1.3;userdata;;%s]", off_horz, off_vert, width,
					minetest.formspec_escape( c.text ) )

			elseif c.type == "item" then
				-- NB: image must be shifted left to correspond with formspec text
				if depth >= 0.5 then
					formspec = formspec .. string.format( "image[%0.1f,%0.1f;%0.1f,%0.1f;%s]",
						off_horz - 0.3, off_vert, math.min( width, depth ), math.min( width, depth ), c.text )
				end

			elseif c.type == "skin" then
				-- NB: image must be shifted left to correspond with formspec text
				if depth >= 0.5 then
					formspec = formspec .. string.format( "image[%0.1f,%0.1f;%0.1f,%0.1f;%s]",
						off_horz - 0.3, off_vert, math.min( width, depth / 2 ), math.min( width * 2, depth ), c.text )
				end

			end

			off_horz = off_horz + width
		end

		if vert_margins[ r.type ] then
			off_vert = off_vert + depth + vert_margins[ r.type ]
		else
			off_vert = off_vert + depth
		end
	end

	return formspec
end
