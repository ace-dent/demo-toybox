# Notes

## Artwork

13:00 After the challenge to convert the vector logo into 8x8px tile artwork, we can start to create and test a tileset using Pulp for PlayDate https://play.date/pulp/.  
13:08 So far the `N` takes 6 tiles.  
14:00 Adding down slopes for `V` and `A`, now at 9 tiles.  
14:15 All tiles done. Cheaky re-use of one (adds 2x junk pixels), saves a tile. Giving total 15 (x8 --> ~120 bytes). `O` is still to be drawn. Plan was using a circle, but perhaps could be tiles if there's room at the end...? Now need to get something in PICO-8.  
14:35 Use ImageMagick to slice up Pulp export into individual tiles.  


## Coding

14:45 Repurposing a bash script to convert png tiles into P8 code snippets  
15:05 We have an `N`! 🎉
