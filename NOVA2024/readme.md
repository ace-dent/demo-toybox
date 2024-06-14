# Notes

## Artwork

Start - Hacking away with Affinity Designer to try and make some tiling version of the NOVA logo.
13:00 After the challenge to convert the vector logo into 8x8px tile artwork, we can start to create and test a til  eset using [Pulp](https://play.date/pulp/) for PlayDate.  
13:08 So far the `N` takes 6 tiles.  
14:00 Adding down slopes for `V` and `A`, now at 9 tiles.  
14:15 All tiles done. Cheaky re-use of one (adds 2x junk pixels), saves a tile. Giving total 15 (x8 --> ~120 bytes). `O` is still to be drawn. Plan was using a circle, but perhaps could be tiles if there's room at the end...? Now need to get something in PICO-8.  
14:35 Use ImageMagick to slice up Pulp export into individual tiles.  
15:26 Back to Pulp to try tweaking the logo design a little, for thinner horizontal lines.  
16:00 New design looks better. Make tiles and convert to P8 code.  
16:14 Just spotted a couple of pixels off in the artwork. One is a quick fix, the other would add a tile to the leading stroke of `V`, so will ignore it.  
21:42 If bytes allow, can scroll with cursor(-x), or flip 90deg and scroll... this would allow a bigger logo effect...


## Coding

14:45 Repurposing a bash script to convert png tiles into P8 code snippets  
15:05 We have an `N`! 🎉  
15:12 Drawing full tileset logo in P8. Concern is that the print code takes 74chrs (unoptimized). Perhaps I should have stored artwork at half-height and then doubled on rendering...?  
15:24 Playing around with P8 font modifier [effects](https://pico-8.fandom.com/wiki/P8SCII_Control_Codes#Changing_character_rendering_modes). Not sure I like the thicker horizontal lines in the artwork.  
16:05 Quick hack to draw oval in place of `O` to complete the logo. Looking good. Taking a break to recharge and may head to the party!  
20:30 Back in the saddle... At NOVA! Sizecoding first to see what we have to work with...  
20:45 Double checking how the tile data is stored; counting repeatitions.  
21:10 Combined the tile set into one data stream, embedded in the file. 154 chrs.  
21:15 Now optimize the print stream for drawing the logo.  
21:30 Break!  
23:15 Work a bit on presentation. Let's get this vertically centered! 128-(3*8*2)=80. Need 40px at top- 5 rows (single spaced). Repeat line feeds "\*5\n" → "¹5\n" →  vertical cursor move "⁴🅾️" approx.  

