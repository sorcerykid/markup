--------------------------------------------------------
-- Minetest :: Bedrock Markup Language Mod (markup)
--
-- See README.txt for licensing and other information.
-- Copyright (c) 2019-2020, Leslie Ellen Krause
--
-- ./games/minetest_game/mods/markup/init.lua
--------------------------------------------------------

markup = { }

local UNKNOWN_SKIN_TEXTURE = "character_preview.png"
local UNKNOWN_ITEM_TEXTURE = "unknown_item.png"
local UNKNOWN_EMOJI_TEXTURE = "emoji_unknown.png"

-------------------------

markup.registered_emojis = {
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
	yum = "emoji_yum.png",
	grin = "emoji_grin.png",
}

markup.registered_colors = {
	cyan = "#44FFFF",
	magenta = "#FF44FF",
	yellow = "#FFFF44",
	red = "#FF4444",
	green = "#44FF44",
	blue = "#4444FF",
	black = "#000000",
	gray = "#AAAAAA",
	brown = "#DDAA00",
	teal = "#00DDAA",
	purple = "#AA00DD",
	olive = "#AADD00",
	indigo = "#00AADD",
	maroon = "#DD00AA",
}

markup.registered_symbols = {
	amp = "&",
	gt = ">",
	lt = "<",
	rb = "]",
	lb = "[",
	copy = "©",
	sect = "§",
	half = "½",
	deg = "°",
	pm = "±",
	div = "÷",
	mul = "×",
	dash = "—",
	bull = "•",
	lq = "“",
	rq = "”",
	lsq = "‘",
	rsq = "’",
}

local _ = { }

local function is_match( text, glob )
	-- use array for captures
	_ = { string.match( text, glob ) }
	return #_ > 0 and _ or nil
end

-------------------------

markup.get_builtin_vars = function ( player_name )
	local player = minetest.get_player_by_name( player_name )

	return {
		name = player_name,
		item = player:get_wielded_item( ):get_name( ),
		skin = skins.skins[ player_name ],
		cur_users = #registry.player_list,
		max_users = minetest.setting_get( "max_users" ),
	}
end

markup.parse_message = function ( message, vars, defs )
	if not defs then defs = { } end

	if not defs.colors then
		defs.colors = markup.registered_colors
	end
	if not defs.emojis then
		defs.emojis = markup.registered_emojis
	end
	if not defs.symbols then
		defs.symbols = markup.registered_symbols
	end

--[[	-- instantiate generic filter for parsing expressions

        local filter = GenericFilter( )
	local filter_vars = {
		name = { type = FILTER_TYPE_STRING, value = vars.name },
		rank = { type = FILTER_TYPE_STRING, value = vars.rank },
		item = { type = FILTER_TYPE_STRING, value = vars.item },
		skin = { type = FILTER_TYPE_STRING, value = vars.skin },
		home = { type = FILTER_TYPE_STRING, value = vars.home },
		lifetime = { type = FILTER_TYPE_PERIOD, value = vars.lifetime },
		uptime = { type = FILTER_TYPE_PERIOD, value = vars.lifetime },
		time = { type = FILTER_TYPE_STRING, value = vars.time },
		date = { type = FILTER_TYPE_STRING, value = vars.date },
		max_lag = { type = FILTER_TYPE_NUMBER, value = vars.max_lag },
		avg_lag = { type = FILTER_TYPE_NUMBER, value = vars.avg_lag },
		cur_users = { type = FILTER_TYPE_NUMBER, value = vars.cur_users },
		max_users = { type = FILTER_TYPE_NUMBER, value = vars.max_users },
	}

        filter.add_preset_vars( filter_vars )

	filter.define_func( "str", FILTER_TYPE_STRING, { FILTER_TYPE_NUMBER },
		function ( v, a ) return tostring( a ) end )
	filter.define_func( "join", FILTER_TYPE_STRING, { FILTER_TYPE_SERIES, FILTER_TYPE_STRING },
		function ( v, a, b ) return table.concat( a, b ) end )
	filter.define_func( "when", FILTER_TYPE_STRING, { FILTER_TYPE_PERIOD, FILTER_TYPE_STRING },
		function ( v, a, b ) local f = { y = 31536000, w = 604800, d = 86400, h = 3600, m = 60, s = 1 }; return f[ b ] and ( math.floor( a / f[ b ] ) .. b ) or "?" end )
	filter.define_func( "cal", FILTER_TYPE_STRING, { FILTER_TYPE_MOMENT, FILTER_TYPE_STRING },
		function ( v, a, b ) local f = { ["Y"] = "%y", ["YY"] = "%Y", ["M"] = "%m", ["MM"] = "%b", ["D"] = "%d", ["DD"] = "%a", ["h"] = "%H", ["m"] = "%M", ["s"] = "%S" }; return os.date( string.gsub( b, "%a+", f ), a ) end )
	filter.define_func( "rand", FILTER_TYPE_NUMBER, { FILTER_TYPE_NUMBER },
		function ( v, a ) return math.random( a ) end )

	local evaluate = function ( expr )
		local oper = filter.translate( expr, filter_vars )

		if not oper or oper.type ~= FILTER_TYPE_STRING then
			return "?"
		end
		return oper.value
	end
]]
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
		local type = "normal"
		local vert = 0.0

		if is_match( r_val, "^(.)=(%d+)%](.*)" ) or is_match( r_val, "^(.)=(%d+%.%d)%](.*)" ) then
			vert = tonumber( _[ 2 ] ) / 2
			type = r_types[ _[ 1 ] ]
			r_val = _[ 3 ]
		elseif is_match( r_val, "^(.)=?%](.*)" ) then	-- permit default tag
			type = r_types[ _[ 1 ] ]
			r_val = _[ 2 ]
		end

		r_val = string.trim( r_val )

		if r_val ~= "" then
			local cols = { }
			local input_cols = string.split( r_val, "[c", true )

			for c_idx, c_val in ipairs( input_cols ) do
				local type = "text"
				local horz = 0.0

				if is_match( c_val, "^(.)=(%d+)%](.*)" ) or is_match( c_val, "^(.)=(%d+%.%d)%](.*)" ) then
					horz = tonumber( _[ 2 ] ) / 2
					type = c_types[ _[ 1 ] ]
					c_val = _[ 3 ]
				elseif is_match( c_val, "^(.)=?%](.*)" ) then	-- permit default tag
					type = c_types[ _[ 1 ] ]
					c_val = _[ 2 ]
				end

				c_val = string.trim( c_val )

				if c_val ~= "" or c_idx > 1 then
					c_val = string.gsub( c_val, "&([a-z]+);", defs.symbols )	-- expand escape codes
--					c_val = string.gsub( c_val, "%%{(.-)}", evaluate )		-- interpolate functions
					c_val = string.gsub( c_val, "%$([a-zA-Z_]+)", vars )		-- interpolate variables

					if type == "text" then
						local text = string.gsub( c_val, "%[q=([a-z]+)%](.-)%[/q%]", function ( code, text )
							return defs.colors[ code ] and minetest.colorize( defs.colors[ code ], text ) or "?" .. text
						end )
						table.insert( cols, { horz = horz, text = text, type = type } )

					elseif type == "form" then
						local text = string.gsub( c_val, "%[q[^%]]*%]", "" )
						table.insert( cols, { horz = horz, text = text, type = type } )

					elseif type == "item" then
						local text
						if string.find( c_val, "^[a-zA-Z0-9_]+:[a-zA-Z0-9_]+$" ) then
							local itemdef = minetest.registered_items[ c_val ]
							if not itemdef then
								text = UNKNOWN_ITEM_TEXTURE
							elseif itemdef.type == "node" and not itemdef.inventory_image then
								text = itemdef.tiles[ 1 ]
							else
								text = itemdef.inventory_image		-- always fallback to inventory image
							end
						elseif type == "item" and c_val == ":blank" then
							text = "blank.png"
						elseif type == "item" and string.find( c_val, "^:[a-zA-Z0-9_]+$" ) then
							text = defs.emojis[ string.sub( c_val, 2 ) ] or UNKNOWN_EMOJI_TEXTURE
						else
							text = UNKNOWN_ITEM_TEXTURE
						end
						table.insert( cols, { horz = horz, text = text, type = type } )					

					elseif type == "skin" then
						if string.find( c_val, "^character_%d+$" ) then
							text = skins.meta[ c_val ] and c_val .. "_preview.png" or UNKNOWN_SKIN_TEXTURE
						else
							text = UNKNOWN_SKIN_TEXTURE
						end
						table.insert( cols, { horz = horz, text = text, type = type } )
					end
				end
			end
			table.insert( rows, { vert = vert, cols = cols, type = type } )
		end
	end

	return rows
end

markup.get_formspec_string = function ( rows, min_horz, min_vert, max_horz, max_vert, border_color, header_color, normal_color )
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
				string.format( "box[%0.2f,%0.2f;%0.2f,%0.2f;%s]", off_horz - 0.2, off_vert, max_horz - off_horz + 0.2, depth + 0.1, border_color )
			off_vert = off_vert + 0.1

		elseif r.type == "header" then
			formspec = formspec ..
				string.format( "box[%0.2f,%0.2f;%0.2f,%0.2f;%s]", off_horz - 0.1, off_vert + depth - 0.05, max_horz - off_horz, 0.05, header_color )
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
				if normal_color and normal_color ~= "#FFFFFF" then
					local color_escape = minetest.get_color_escape_sequence( normal_color )
					c.text = color_escape .. c.text
					c.text = string.gsub( c.text, string.char( 0x1b ) .. "%(c@#ffffff%)", color_escape )
				end

				if r.type == "header" then
					formspec = formspec ..
						string.format( "textarea[%0.2f,%0.2f;%0.2f,%0.2f;;%s;]", off_horz + 0.3, off_vert, width, depth + depth / 6,
							minetest.formspec_escape( c.text ) )
				end

				formspec = formspec ..
					-- NB: correct for odditiese with dimension and position of textarea
					string.format( "textarea[%0.2f,%0.2f;%0.2f,%0.2f;;%s;]", off_horz + 0.3, off_vert, width, depth + depth / 6,
						minetest.formspec_escape( c.text ) )

			elseif c.type == "form" then
				formspec = formspec .. string.format( "field[%0.1f,%0.1f;%0.1f,1.3;userdata;;%s]", off_horz + 0.3, off_vert, width,
					minetest.formspec_escape( c.text ) )

			elseif c.type == "item" then
				if depth >= 0.5 then
					formspec = formspec .. string.format( "image[%0.1f,%0.1f;%0.1f,%0.1f;%s]",
						off_horz, off_vert, math.min( width, depth ), math.min( width, depth ), c.text )
				end

			elseif c.type == "skin" then
				if depth >= 0.5 then
					formspec = formspec .. string.format( "image[%0.1f,%0.1f;%0.1f,%0.1f;%s]",
						off_horz, off_vert, math.min( width, depth / 2 ), math.min( width * 2, depth ), c.text )
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
