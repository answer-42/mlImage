# README
This is an image viewer written in Ocaml. We use SDL to show and load the images
and it has a pure keyboard interface. The code has been published under the
BeerWare licence. 

Copyright Sebastian Benque 2013.

## Usage
After starting the program, with the path/images as an argument, mlImage will
recursively look for images in teh given direcetories. And then open them all.
Then you have the following commands ar your disposal.

    esc       Quit the program
    right     Next image
    left      Prev image
    a         Move image left
    d         Move image right
    s         Move image down
    w         Move image up
    i         Zoom in
    o         Zoom out
    f         Fit image
    z         Full image
    t         Show file name
    h         Show help text
    n         Don't show any text

## Install Instructions

### Archlinux
Install ocaml:

     # pacman -S ocaml

Install dependencies from AUR:

     ocamlsdl, ocaml-batteries, ocaml-magic
    
Then you can install mlImage.

     # cd mlImage/
     # omake
     # cp mlImage.opt <dir of choice>

### Linux in General
Use opam to install batteries and sdl.

     # opam update
     # opam install ocamlsdl
     # opan install batteries
     # opam install magic

Then you can install mlImage.

     # cd mlImage/
     # omake
     # cp mlImage.opt <dir of choice>

## Licence
"THE BEER-WARE LICENSE" (Revision 42):

<sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return Sebastian Benque
