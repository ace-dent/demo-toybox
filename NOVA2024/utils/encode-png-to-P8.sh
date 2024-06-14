#!/bin/bash

# WARNING: Not safe for public use! Created for the author's benefit.
# Assumes:
# - Filenames and directory structure follows the project standard.
# - Correct png images are fed in.
# - ImageMagick and OptiPNG executables are available

# - Optional: Enabling this function uses PICO-8 to produce a sprite sheet
# pico8() {
#   '/Applications/PICO-8.app/Contents/MacOS/pico8' "$@"
# }



# Minimal check for input file(s)
if [ -z "$1" ]; then
  echo 'Missing filename. Provide at least one png image to process.'
  exit
fi

# TODO: Check for external binaries (Exiftool, ImageMagick and OptiPNG)


# Directory for utilities
util_dir="$(dirname "${BASH_SOURCE[0]}")"
readonly util_dir


# Code snippet parameters
p8_map="$( echo {a..z} {0..9} {A..Z} \
  | tr -d '[:space:]' )" # Sequence of characters to assign for P8 patterns
readonly p8_map
readonly p8_map_length=${#p8_map}


img_counter=0

echo ''
echo 'Crunching images into patterns...'
while (( "$#" )); do

  # TODO: Check ~
  #   File exists
  #   Input PNG file validity (file size, file format)

  # Ensure the artwork has the correct file permissions set
  chmod 644 "$1"

  ((img_counter=img_counter+1))

  # Get the image name and group from the filename
  img_name="$( basename -s .png "$1" )" # e.g. "BayerDither00"
  img_root="${1%/*/*}" # Base directory for the pattern
  img_numbered_group="$( basename "${img_root}" | tr -d ' ' )" # e.g. "01-Dither"
  img_group="$( echo "${img_numbered_group}" | cut -f 2 -d '-' )" # e.g. "Dither"
  # Format variations with different case
  name_lowercase="$( echo "${img_name}" | tr '[:upper:]' '[:lower:]' )" # e.g. "bayerdither00"
  name_camelcase="${name_lowercase:0:1}${img_name:1}" # Lower case first letter and append remaining characters, e.g. "bayerDither00"
  name_camelcase="$( echo -n "${name_camelcase}" | tr -cs '[:alnum:]' '_')" # Replace non-alphanumeric characters with '_' for code compatibility
  group_lowercase="$( echo "${img_group}" | tr '[:upper:]' '[:lower:]' )" # e.g. "dither"


  # Produce code snippets
  # ---------------------

  # Create Horizontal and Vertical temporary files, with plain text binary and hexadecimal
  bin_h="${img_root}/$img_name.bin-h.txt" # Horizontal (HMSB)
  hex_h="${img_root}/$img_name.hex-h.txt"
  bin_v="${img_root}/$img_name.bin-v.txt" # Vertical (VLSB)
  hex_v="${img_root}/$img_name.hex-v.txt"
  magick "$1" -depth 1 +negate -compress None PBM:- \
    | tail -n +3 \
    | tr -d ' ' > "${bin_h}"
  magick "$1" -depth 1 +negate -rotate 90 -compress None PBM:- \
    | tail -n +3 \
    | tr -d ' ' > "${bin_v}"
  # Write files with hexadecimal values and ascii art comments
  for line in {1..8}; do
    binary_str="$( sed -n ${line}p "${bin_h}" )" # Horizontal (HMSB)
    value_dec=$((2#${binary_str}))
    printf '    0x%02X,' "${value_dec}"
    printf ' #  %s\n' "${binary_str}" | tr '01' '▓░'
  done > "${hex_h}"
  for line in {1..8}; do
    binary_str="$( sed -n ${line}p "${bin_v}" )" # Vertical (VLSB)
    value_dec=$((2#${binary_str}))
    printf '    0x%02X,' "${value_dec}"
    printf ' #  %s\n' "${binary_str}" | tr '01' '▓░'
  done > "${hex_v}"

  # Check the pattern's minimum repeat width and height
  pattern_width=8
  if [ "$(head -n 4 "${bin_v}")" = "$(tail -n 4 "${bin_v}")" ]; then
    pattern_width=4
    if [ "$(head -n 2 "${bin_v}")" = "$(tail -n 2 "${bin_v}")" ]; then
      pattern_width=2
      if [ "$(head -n 1 "${bin_v}")" = "$(tail -n 1 "${bin_v}")" ]; then
        pattern_width=1
      fi
    fi
  fi
  pattern_height=8
  if [ "$(head -n 4 "${bin_h}")" = "$(tail -n 4 "${bin_h}")" ]; then
    pattern_height=4 # Pattern heights below 4 are treated the same
  fi
  echo "${img_name} - Pattern ${pattern_width} x ${pattern_height} px #${pattern_uid}."



  # Create PICO-8 code
  p8_file="${img_root}/${img_group}.p8.lua.WIP.txt"
  # Store bitmap data as a custom font (HLSB data)
  index=$(( (img_counter-1) % p8_map_length ))
  p8_mapped_char="${p8_map:index:1}"
  ascii_code=$( printf '%d' "'${p8_mapped_char}" )
  {
    printf -- "\n--%u '%c' %s\n" "${ascii_code}" "${p8_mapped_char}" "${name_lowercase}"
    printf 'poke(0x5600+(8* %u),\n' "${ascii_code}"
    for row in {1..8}; do
    # P8 custom font characters are encoded row wise (horizontally).
    # The LSB of each byte corresponds to the first pixel of a row, (not the MSB),
    # so the bit sequence is reversed before calculating decimal value
      binary_str="$( sed -n ${row}p "${bin_h}" | rev )"
      value_dec=$((2#${binary_str}))
      printf ' %3u' "${value_dec}"
      if [ $row -lt 8 ]; then
        printf -- ', -- '
      else
        printf -- '  -- '
      fi
      sed -n ${row}p "${bin_h}" | tr '01' '▒█' # Shown as drawn to screen, not as the stored bitfield (reversed)
    done
    printf ')\n'
    # Helper code snippet to copy font character to Sprite 0
    printf -- '-->spr0: print"⁶@56000003⁸x⁸⁶c0ᵉ%c"for i=0,448,64do memcpy(i,24576+i,4)end cstore()\n' \
      "${p8_mapped_char}"
  } >> "${p8_file}"
  # Bonus: 'magic' one-off character, encoded as a string
  # We store the end of the string first
  encoded_string='"'
  digit_present=0
  for row in {8..1}; do
    # Find the decimal value for the current row (byte)
    binary_str="$( sed -n ${row}p "${bin_h}" | rev )"
    value_dec=$((2#${binary_str}))
    if [ ${value_dec} -eq 0 ] && [ ${digit_present} -eq 1 ]; then
      # Handle special case to make octal value unambiguous
      encoded_byte='\000'
      digit_present=0
    else
      # Use 'P8SCII' codepage to lookup string literal to encode the byte
      index=$((value_dec+1))
      encoded_byte="$(sed -n ${index}p "${util_dir}/p8-codepage")"
      if [ ${value_dec} -ge 48 ] && [ ${value_dec} -le 57 ]; then # Characters '0' - '9'
        digit_present=1
      else
        digit_present=0
      fi
    fi
    encoded_string="${encoded_byte}${encoded_string}" # Prepend byte to magic string
  done
  printf -- '--magic: ?"⁶rw¹シ⁶.".."%s\n' "${encoded_string}" >> "${p8_file}"
  # Bonus: For 4x4px patterns produce fillp() alternative
  if [ ${pattern_width} -le 4 ] && [ ${pattern_height} -le 4 ]; then
    # The hex value for PICO-8 can be reused for Picotron
    pico_fillp_string='0x'
    for row in {1..4}; do
      # Invert bits 0<>1 to fix fore-/background
      binary_str=$(sed -n ${row}p "${bin_h}"\
        | head -c 4\
        | tr '01' '10')
      value_hex=$( printf '%X' $((2#${binary_str})) )
      pico_fillp_string="${pico_fillp_string}${value_hex}"
    done
    printf -- '--fillp(%u)\n' "${pico_fillp_string}" >> "${p8_file}"
  fi



  # Remove temporary files
  rm -f "${bin_h}" ; rm -f "${bin_v}" ; rm -f "${hex_h}" ; rm -f "${hex_v}"

  # Move to next image file provided
  shift
done



# If defined, use P8 to create a sprite sheet for the final image's group
if type pico8 &> /dev/null; then
    echo '---'
    p8_script="${util_dir}/p8-spritesheets/${img_numbered_group}-sprsht.p8"
    p8_sprsht="${group_lowercase}.png" # sprite sheet file path (relative)
    echo "Generating sprite sheet - ${p8_sprsht}"
    # First execution updates the embedded sprites (`__gfx__`) for later export
    # Using P8 `printh()` the script returns the number of 8px rows occupied
    p8_rows=$(pico8 -x "${p8_script}" | tail -n 1)
    # P8 can only export into the current directory
    pushd "${img_root}" > /dev/null || exit
    pico8 "${p8_script}" -export "${p8_sprsht}" > /dev/null
    # Crop any unused 8px rows from the bottom of the 128px high image
    ((p8_chop=128-p8_rows*8))
    magick "${p8_sprsht}" -gravity South -chop x"${p8_chop}" \
      -define png:color-type='2' -define png:bit-depth='8' \
      -define png:include-chunk=none "${p8_sprsht}"
    optipng -q -nx -o6 "${p8_sprsht}" # Try to optimize 8bpp RGB png first.
    optipng -q -o6 "${p8_sprsht}" # Also try reducing to 1bpp indexed png.
    # Add metadata to the png sprite sheet
    exiftool -q -overwrite_original -fast1 \
      -Title="${img_group} - ${project//pattern/patterns}" \
      -Copyright="${copyright} ${license}" "${p8_sprsht}" "${p8_sprsht}"
    # Restore the working directory
    popd > /dev/null || exit
fi



echo '...Finished :)'
echo ''
exit
