--10print"nova"
--by ace_dent for nova 2024

-- scroll start position
x=240

--poke the tileset data
--into a custom font.
--setup font as 8x8px
--then dump data in 'a' onwards
?"⁶@56000003⁸x⁸⁶!5908ヲヲヲヲヲヲヲヲ◝◝◝◝\0\0\0\0?○◝◝ヲヲヲヲヲヲヲヲヲヲユナ\0\0\0\0゜?○◝ユナら█\0\0\0\0¹³⁷⁷ᶠᶠ゜゛><|xヲユユナナらら██\0\0\0\0\0\0\0\0\0▒▒れれフ◝◝◝~<⁷³³¹¹\0\0\0|<>゛゜ᶠᶠ⁷█らナナユユヲx³³⁷⁷◝◝◝◜"
-- total 167 chrs

::★:: -- loop it!

--scroll function
i=(sin(x/500)*150)-100

--draw the 'o' in nova
circ(98+i,54,40+(i/5),9)
circ(98+i,54,25+(i/2),10)


--use carriage position to scroll
--the doubled text across the viewport
cursor(i,32,2)

-- draw logo to screen
-- then flip and cls
?"ᵉ⁶pabbc   fbg ng\na  a¹5 hjmhj\na  de¹4 iklioe\n⁶1⁶c"
-- 56 chrs

x=x+1
goto ★
