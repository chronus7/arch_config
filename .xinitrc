xrdb merge ~/.Xresources    # colours etc.
bash ~/.fehbg               # background
xset b off                  # turn beep off
xhost +local:               # to allow containers a connection to X
exec i3
