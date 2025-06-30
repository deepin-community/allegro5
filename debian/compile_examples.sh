#!/bin/sh
set -e

if test -d $HOME/allegro5-examples
  then
    echo "Error: Directory ~/allegro5-examples already exists. Please remove it first."
    exit 2
fi

echo Copy compressed example sources from /usr/share/doc/allegro5-doc/examples to $HOME/allegro5-examples
cp -r /usr/share/doc/allegro5-doc/examples $HOME/allegro5-examples

echo "Uncompressing example sources"
gzip -dr $HOME/allegro5-examples

echo Creating symbolic link to DejaVuSans.ttf
ln -s /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf $HOME/allegro5-examples/data

#For simplicity we link against all libraries provided by Allegro here.
#Probably no example will really need all of them. We put the linker
#flags into a variable:
ALLEGRO_LIBS=$(pkg-config --libs allegro-5 allegro_color-5 allegro_font-5 allegro_main-5 allegro_memfile-5 allegro_primitives-5 allegro_acodec-5 allegro_audio-5 allegro_dialog-5 allegro_image-5 allegro_physfs-5 allegro_ttf-5 allegro_video-5)

#Switch to the source directory:
cd $HOME/allegro5-examples

echo "Compiling examples..."
for i in ex_*.c; do
  #ex_curl.c, ex_physfs.c and ex_glext.c are omitted because they need curl, physfs and glu around.
  if test x$i != xex_curl.c -a x$i != xex_physfs.c -a x$i != xex_glext.c; then
    gcc $i -o $i.ex $ALLEGRO_LIBS -lm -lGL -lenet
  fi
done


for i in ex_*.cpp nihgui.cpp; do
  if test x$i != xex_d3d.cpp  -a x$i != xex_ogre3d.cpp; then
    g++ -c $i -o $i.o
  fi  
done
for i in ex_*.cpp.o; do
  g++ $i nihgui.cpp.o -o $i.ex $ALLEGRO_LIBS -lm -lGL
done

echo "Compiled example programs are now in ~/allegro5-examples"

