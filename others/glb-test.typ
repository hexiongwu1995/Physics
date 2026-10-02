#import "@preview/neoplot:0.0.4" as gp




#figure(
  gp.exec(
    // Set the width of the graph
    width: 55%,
    ```gnuplot
        reset
     #set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 600, 400
    # set output 'surface2.6.png'
    set dummy u, v
    set key bmargin center horizontal Right noreverse enhanced autotitle nobox
    set parametric
    set view 45, 50, 1, 1
    set isosamples 100, 20
    set hidden3d back offset 1 trianglepattern 3 undefined 1 altdiagonal bentover
    set style data lines
    set xyplane relative 0
    set title "Parametric Helix"
    set trange [ * : * ] noreverse nowriteback
    set urange [ 0.00000 : 31.4159 ] noreverse nowriteback
    set vrange [ 0.00000 : 6.28319 ] noreverse nowriteback
    set xrange [ * : * ] noreverse writeback
    set x2range [ * : * ] noreverse writeback
    set yrange [ * : * ] noreverse writeback
    set y2range [ * : * ] noreverse writeback
    set zrange [ * : * ] noreverse writeback
    set cbrange [ * : * ] noreverse writeback
    set rrange [ * : * ] noreverse writeback
    set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front  noinvert bdefault
    I = {0.0, 1.0}
    VERSION = "gnuplot version 6.0.5"
    NO_ANIMATION = 1
    splot (1-0.1*cos(v))*cos(u),(1-0.1*cos(v))*sin(u),0.1*(sin(v)+u/1.7-10)
    ```,
  ),
  caption: "Graphs",
)





#figure({
  gp.exec(
    ```gnuplot
            reset
    # Spinning globe animation (webp or gif encoding)
    #
    # Simplified code;

    set term webp animate delay 100 size 300,300
    set output 'world.webp'
    #
    do for [ang = 0:355:5] {
        xrot = 60
        zrot = (720 - ang) %360
        set view xrot, zrot, 1.92, 1

        splot cos(u)*cos(v),cos(u)*sin(v),sin(u) with lines lc "blue", \
              'world.dat' with polygons fs transparent solid 0.5 fc "olive"
    }
    unset output
    ```,
  )
})



// A csv text in Typst
#let csvdata = ```
Date,A,B,C
2025-01-01,1,2,3
2025-01-02,2,3,4
2025-01-03,1,2,6
2025-01-04,2,1,8
```.text

#gp.exec(
  ```gnuplot
  reset
  # Set the terminal font
  set term svg font "New Computer Modern,20"
  # Read data from an external variable
  $data <<EOD

  ```.text
    + csvdata
    + ```gnuplot

    EOD
    # Set the data format
    set datafile sep ',' columnheaders
    set xdata time
    set timefmt "%Y-%m-%d"
    # Set tick labels
    set xtics timedate format '%m-%d' time 1 day rotate by 90 right
    set ytics format '%.1f'
    # Add a legend
    set bmargin 4.5
    set key right bmargin autotitle columnheader samplen 2 spacing 1 font ",8"
    # Set axis labels
    set xlabel "{/:Italic x}" offset 0,1
    set ylabel "{/:Italic y}" offset 1,0
    # Add grid lines
    set grid
    # Plot
    plot for [i=2:*] $data using 1:i with linespoints
    ```.text,
)


