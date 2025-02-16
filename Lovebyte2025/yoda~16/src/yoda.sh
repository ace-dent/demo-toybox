#!/bin/bash
printf '\e[32m\r
\r
 ▀██  ████  ██▀\r
  ▓██████████▓\r
   ▓██ ██ ██▓\r
     █ ██ █\r
     ██████\e[33m\r
    █▓▓▒▒▓▓█\r
   █░\e[32m██\e[33m░░\e[32m██\e[33m░█\r
   ▓█░░██░░█▓\r
     ▒██░█▒\r
    ███░████\r
   ▐████░██\e[1;30;43m♥\e[0;33m▌\r
\e[1;30m\r
  yoda~16 ACED\r\n\e[0m' | sed 's/♥/\x03/g' | iconv -f UTF-8 -t CP437 > YODA~16.ANS
