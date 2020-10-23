# Set colors
red_000 = "#F9B7B0"
red_025 = "#F97A6D"
red_050 = "#E62B17"
red_075 = "#8F463F"
red_100 = "#6D0D03"

blue_000 = "#A9BDE6"
blue_025 = "#7297E6"
blue_050 = "#1D4599"
blue_075 = "#2F3F60"
blue_100 = "#031A49"

green_000 = "#A6EBB5"
green_025 = "#67EB84"
green_050 = "#11AD34"
green_075 = "#2F6C3D"
green_100 = "#025214"

brown_000 = "#F9E0B0"
brown_025 = "#F9C96D"
brown_050 = "#E69F17"
brown_075 = "#8F743F"
brown_100 = "#6D4903"

grid_color = "#d5e0c9"
text_color = "#6a6a6a"

# Set the font
my_font = "SVBasic Manual, 15" # To import font, download it in .fonts and add the path to .profile

# Some variable
my_line_width = "3"
my_axis_width = "2"
my_ps = "1"
resolution_x = "1280"
resolution_y = "1024"
my_grid_width = "2"

# define the font for the terminal
set terminal pngcairo size resolution_x, resolution_y enhanced font my_font

# Define the position of the legend
set key top left

# set default point size
set pointsize my_ps

# Set the line styles
set style line 1 linecolor rgbcolor blue_025 linewidth my_line_width pt 7
set style line 2 linecolor rgbcolor green_025 linewidth my_line_width pt 5
set style line 3 linecolor rgbcolor red_025 linewidth my_line_width pt 9
set style line 4 linecolor rgbcolor brown_025 linewidth my_line_width pt 13
set style line 5 linecolor rgbcolor blue_050 linewidth my_line_width pt 11
set style line 6 linecolor rgbcolor green_050 linewidth my_line_width pt 7
set style line 7 linecolor rgbcolor red_050 linewidth my_line_width pt 5
set style line 8 linecolor rgbcolor brown_050 linewidth my_line_width pt 9
set style line 9 linecolor rgbcolor blue_075 linewidth my_line_width pt 13
set style line 10 linecolor rgbcolor green_075 linewidth my_line_width pt 11
set style line 11 linecolor rgbcolor red_075 linewidth my_line_width pt 7
set style line 12 linecolor rgbcolor brown_075 linewidth my_line_width pt 5
set style line 13 linecolor rgbcolor blue_100 linewidth my_line_width pt 9
set style line 14 linecolor rgbcolor green_100 linewidth my_line_width pt 13
set style line 15 linecolor rgbcolor red_100 linewidth my_line_width pt 11
set style line 16 linecolor rgbcolor brown_100 linewidth my_line_width pt 7
set style line 17 linecolor rgbcolor "#224499" linewidth my_line_width pt 5
set style line 18 lc rgb '#808080' lt 1 linewidth my_axis_width 
set style line 19 lc rgb '#808080' lt 0 linewidth my_grid_width

# this is to use the user-defined styles we just defined.
set style increment user

# set the color and font of the text of the axis
# set xtics textcolor rgb text_color font my_font
# set ytics textcolor rgb text_color font my_font
# set ztics textcolor rgb text_color font my_font

# set the color and font (and a default text) for the title and each axis
# set title "Top Title" textcolor rgb text_color font my_font
# set xlabel "X Label (unit)" textcolor rgb text_color font my_font
# set ylabel "Y Label (unit)" textcolor rgb text_color font my_font
# set zlabel "Z Label (unit)" textcolor rgb text_color font my_font

# set the text color and font for the label
# set label textcolor rgb text_color font my_font

# set the color and width of the axis border
# set border 31 lw my_axis_width lc rgb text_color

# Set the border color
set border 3 back ls 18
set tics nomirror

# Set a grid in the back ground
set grid back ls 19

