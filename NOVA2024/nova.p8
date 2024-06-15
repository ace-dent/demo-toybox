--10print"nova"
--by ace_dent for nova 2024

--poke the tileset data
--into a custom font.
--setup font as 8x8px
--then dump data in 'a' onwards
?"⁶@56000003⁸x⁸⁶!5908ヲヲヲヲヲヲヲヲ◝◝◝◝\0\0\0\0?○◝◝ヲヲヲヲヲヲヲヲヲヲユナ\0\0\0\0゜?○◝ユナら█\0\0\0\0¹³⁷⁷ᶠᶠ゜゛><|xヲユユナナらら██\0\0\0\0\0\0\0\0\0▒▒れれフ◝◝◝~<⁷³³¹¹\0\0\0|<>゛゜ᶠᶠ⁷█らナナユユヲx³³⁷⁷◝◝◝◜"
-- total 167 chrs

--Scroll offset
x=4

-- prepare screen
cls()

--Draw the 'O' in NOVA
circ(98+x,54,40+(x/10),9)

--Use carriage position to scroll
--the doubled text across the viewport
cursor(x,32,2)

-- draw logo to screen
?"ᵉ⁶pabbc   fbg ng\na  a¹5 hjmhj\na  de¹4 iklioe\n"
-- 58 chrs


--2am hacked version to back-port and improve
-- x=-256d=1
-- ::★::
-- circ(98+x,54,40+(x/10),9)
-- cursor(x,32,2)
-- ?"ᵉ⁶pabbc   fbg ng\na  a¹5 hjmhj\na  de¹4 iklioe\n"
-- x=x+d
-- if x>10then d=d*-1end?"⁶1⁶c"
-- goto ★
