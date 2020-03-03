Bedrock Markup Language Mod v1.3
By Leslie E. Krause

Bedrock Markup Language is an extensible markup language and API specifically tailored
for Minetest formspecs with simple-to-use tags for layout and formatting (e.g. colors,
headers, borders, rows and columns), builtin word-wrapping, and support for embedded
images (e.g. skins, items, etc.)

It makes a particularly nice drop-in replacement for the default sign and book editors, 
if you want to give your users the ability to create nicer looking messages, rather than 
accepting raw formspec strings which could pose security risks.

There is support for 15 text colors (including white) via the following inline tags:

   [q=gray][/q] - gray text
   [q=red][/q] - red text
   [q=green][/q] - green text
   [q=blue][/q] - blue text
   [q=cyan][/q] - cyan text
   [q=magenta][/q] - magenta text
   [q=yellow][/q] - yellow text
   [q=black][/q] - black text
   [q=brown][/q] - brown text
   [q=teal][/q] - teal text
   [q=purple][/q] - purple text
   [q=olive][/q] - olive text
   [q=indigo][/q] - indigo text
   [q=maroon][/q] - maroon text

There is also support for rows and columns via the [r] and [c] tags. Both tags accept an
optional numeric attribute to alter the size of the cell to be rendered.

You can set the depth of all cells on the next row using [r=#], and you can set the width 
of the next cell using [c=#]. In both cases, # must be a number (or 0 for the default). 
The unit of measurement is an approximation of the standard "em" used in typography.

Here is a basic table with two rows and two columns:

>  Upper left cell[c]Upper right cell
>  [r]
>  Lower left cell[c]Lower right cell

Notice how the initial [r] tag is missing, and the initial [c] tags are also missing. Not 
to worry! The lexer automatically fills in these tags behind the scenes. It is entirely 
optional to include them. This markup is more verbose, but produces the same results:

>  [r=0][c=0]Upper left cell[c=0]Upper right cell
>  [r=0][c=0]Lower left cell[c=0]Lower right cell

By default rows and columns are evenly spaced vertically and/or horizontally for the most 
pleasing appearance. The lexer is capable of automatically resizing rows and columns to 
fit within the allowed dimensions of the formspec and to prevent overruns.

In addition to all of the features described above, you can easily add bordered text, 
headline text, and even images (both skin and item textures) into your formspecs!

   [b]<text>
   Insert a new border row with a depth of 1.0

   [b=#]<text>
   Same as above, but with the specified depth

   [h]<text>
   Insert a new header row with a depth of 1.0

   [h=#]<text>
   Same as above, but with the specified depth

   [i]<item_name>
   Insert the specified item texture with a width of 2.0 (if image is too big to fit on 
   the current row, then it will be shrunk to fit).

   [i=#]<item_name>
   Same as above, but with the specified width

   [s]<skin_name>
   Insert the specified skin texture with a width of 2.0 (if image is too big to fit on 
   the current row, then it will be shrunk to fit).

   [s=#]<skin_name>
   Same as above, but with the specified width

It is also possible to include dynamic text using variable interpolation:

   $name - the name of the current player
   $item - the wielded item of the current player (for use with the [­i] tag)
   $skin - the selected skin of the current player (for use with the [­s] tag)
   $date - the current world date
   $time - the current world time
   $cur_users - the current number of online players
   $max_users - the maximum number of online players

And a variety of special characters can be inserted by means of escape codes:

   &amp; - ampersand
   &gt; - greater-than
   &lt; - less-than
   &rb; - right bracket
   &lt; - left bracket
   &copy; - copyright
   &sect; - section
   &half; - one-half
   &deg; - degree
   &pm; - plus-or-minus
   &div; - division
   &mul; - multiplication
   &dash; - em-dash
   &bull; - bullet
   &lq; - opening quote
   &rq; - closing quote
   &lsq; - opening single-quote
   &rsq; - closing single-quote

The Bedrock Markup Language also supports emojis! It's simple and easy to embed smilies 
and other symbols into your formspecs using the existing item tag. Just type one of the 
following emoji shortnames preceded by a colon, such as [i]:cupid_heart or [i]:smitten.

   happy           silly           annoyed         mad             heart
   hungry          amused          disappointed    cool            cupid_heart
   smug            confused        angry           cheerful        black_heart
   frustrated      surprised       sad             smitten         frozen_heart
   laughing        kissing         crying          sleeping        heartbreak
   warning         danger          keep_out        cone            lock

The following functions are available as part of the Bedrock Markup Language API:

 * markup.get_builtin_vars( player_name )
   Return a table consisting of builtin variables for use by the parser. You can add or 
   remove builtin variables or even disable them entirely by overriding this function.
    * 'player_name' is the player for whom the formspec string will be generated.

 * markup.parse_message( message, vars )
   Parse the given message and return the rows as a table.
    * 'message' is the message consisting of Bedrock Markup Language.
    * 'vars' is a table of variables, with each key being the variable name and each
      value being the corresponding string value of the variable.

 * markup.get_formspec_string(
           rows, min_horz, min_vert, max_horz, max_vert, border_color, header_color )
   Generate a formspec string from the rows table returned by markup.parse_message( ).
    * 'rows' is the rows table returned by the parser
    * 'min_horz' is the left position of the rendering area in formspec coordinates
    * 'min_vert' is the bottom position of the rendering area in formspec coordinates
    * 'max_horz' is the right position of the rendering area in formspec coordinates
    * 'max_vert' is the bottom position of the rendering area in formspec coordinates

Note that the parser will skip unknown tags and undefined variables and symbols, rather 
than stripping them from the original message.


Repository
----------------------

Browse source code...
  https://bitbucket.org/sorcerykid/markup

Download archive...
  https://bitbucket.org/sorcerykid/markup/get/master.zip
  https://bitbucket.org/sorcerykid/markup/get/master.tar.gz

Compatability
----------------------

Minetest 0.4.15+ required

Installation
----------------------

  1) Unzip the archive into the mods directory of your game.
  2) Rename the markup-master directory to "markup".
  3) Add "markup" as a dependency to any mods using the API.

Source Code License
----------------------

The MIT License (MIT)

Copyright (c) 2019-2020, Leslie E. Krause.

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

For more details:
https://opensource.org/licenses/MIT


Multimedia License (textures, sounds, and models)
----------------------------------------------------------

Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)

	/textures/emoji_amused.png
	by sorcerykid

	/textures/emoji_cheerful.png
	by sorcerykid

	/textures/emoji_crying.png
	by sorcerykid

	/textures/emoji_frozen_heart.png
	by sorcerykid

	/textures/emoji_heartbreak.png
	by sorcerykid

	/textures/emoji_kissing.png
	by sorcerykid

	/textures/emoji_sad.png
	by sorcerykid

	/textures/emoji_smug.png
	by sorcerykid

	/textures/emoji_yum.png
	by sorcerykid

	/textures/emoji_angry.png
	by sorcerykid

	/textures/emoji_cone.png
	by sorcerykid

	/textures/emoji_cupid_heart.png
	by sorcerykid

	/textures/emoji_frustrated.png
	by sorcerykid

	/textures/emoji_heart.png
	by sorcerykid

	/textures/emoji_laughing.png
	by sorcerykid

	/textures/emoji_silly.png
	by sorcerykid

	/textures/emoji_surprised.png
	by sorcerykid

	/textures/emoji_annoyed.png
	by sorcerykid

	/textures/emoji_confused.png
	by sorcerykid

	/textures/emoji_danger.png
	by sorcerykid

	/textures/emoji_grin.png
	by sorcerykid

	/textures/emoji_hungry.png
	by sorcerykid

	/textures/emoji_lock.png
	by sorcerykid

	/textures/emoji_sleeping.png
	by sorcerykid

	/textures/emoji_unknown.png
	by sorcerykid

	/textures/emoji_black_heart.png
	by sorcerykid

	/textures/emoji_cool.png
	by sorcerykid

	/textures/emoji_disappointed.png
	by sorcerykid

	/textures/emoji_happy.png
	by sorcerykid

	/textures/emoji_keep_out.png
	by sorcerykid

	/textures/emoji_mad.png
	by sorcerykid

	/textures/emoji_smitten.png
	by sorcerykid

	/textures/emoji_warning.png
	by sorcerykid

You are free to:
Share — copy and redistribute the material in any medium or format.
Adapt — remix, transform, and build upon the material for any purpose, even commercially.
The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

Attribution — You must give appropriate credit, provide a link to the license, and
indicate if changes were made. You may do so in any reasonable manner, but not in any way
that suggests the licensor endorses you or your use.

No additional restrictions — You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.

Notices:

You do not have to comply with the license for elements of the material in the public
domain or where your use is permitted by an applicable exception or limitation.
No warranties are given. The license may not give you all of the permissions necessary
for your intended use. For example, other rights such as publicity, privacy, or moral
rights may limit how you use the material.

For more details:
http://creativecommons.org/licenses/by-sa/3.0/
