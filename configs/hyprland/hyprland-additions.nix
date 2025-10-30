# Additional Hyprland Configuration
# Add these to your main hyprland.conf file

###################
### SCREENSHOTS ###
###################

# Screenshot keybindings
bind = $mainMod SHIFT, S, exec, grimblast copy area
bind = $mainMod, Print, exec, grimblast copy output
bind = , Print, exec, grimblast copy screen
bind = $mainMod CTRL, S, exec, grimblast save area ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png
bind = $mainMod ALT, S, exec, grimblast --freeze copy area

####################
### WINDOW RULES ###
####################

# Float specific windows
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = float, class:^(org.pulseaudio.pavucontrol)$
windowrulev2 = float, class:^(pwvucontrol)$
windowrulev2 = float, class:^(blueman-manager)$
windowrulev2 = float, class:^(nm-connection-editor)$
windowrulev2 = float, class:^(xfce-polkit)$
windowrulev2 = float, class:^(qt5ct)$
windowrulev2 = float, class:^(qt6ct)$
windowrulev2 = float, class:^(nwg-look)$
windowrulev2 = float, title:^(Picture-in-Picture)$

# Center floating windows
windowrulev2 = center, class:^(pavucontrol)$
windowrulev2 = center, class:^(blueman-manager)$

# Size specific windows
windowrulev2 = size 800 600, class:^(pavucontrol)$
windowrulev2 = size 1000 700, class:^(thunar)$, title:^(File Operation Progress)$

# Workspace assignments
# windowrulev2 = workspace 1 silent, class:^(kitty)$
windowrulev2 = workspace 2 silent, class:^(firefox)$
windowrulev2 = workspace 2 silent, class:^(Google-chrome)$
windowrulev2 = workspace 3 silent, class:^(Code)$
windowrulev2 = workspace 3 silent, class:^(code-url-handler)$
windowrulev2 = workspace 4 silent, class:^(Postman)$
windowrulev2 = workspace 5 silent, class:^(Spotify)$
windowrulev2 = workspace 6 silent, class:^(vesktop)$
windowrulev2 = workspace 6 silent, class:^(discord)$
windowrulev2 = workspace 7 silent, class:^(Slack)$
windowrulev2 = workspace 7 silent, class:^(Microsoft Teams)$
windowrulev2 = workspace 8 silent, class:^(Thunderbird)$
windowrulev2 = workspace 9 silent, class:^(obs)$

# Opacity rules
# windowrulev2 = opacity 0.95 0.85, class:^(kitty)$
windowrulev2 = opacity 1.0 override 1.0 override, class:^(firefox)$
windowrulev2 = opacity 1.0 override 1.0 override, class:^(Google-chrome)$
windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*YouTube.*)$
windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*Twitch.*)$

# Picture-in-Picture
windowrulev2 = float, title:^(Picture-in-Picture)$
windowrulev2 = pin, title:^(Picture-in-Picture)$
windowrulev2 = move 70% 70%, title:^(Picture-in-Picture)$
windowrulev2 = size 25% 25%, title:^(Picture-in-Picture)$

# Dialog windows
windowrulev2 = float, class:^(.*), title:^(Open File)$
windowrulev2 = float, class:^(.*), title:^(Save File)$
windowrulev2 = float, class:^(.*), title:^(Open Folder)$
windowrulev2 = center, class:^(.*), title:^(Open File)$
windowrulev2 = center, class:^(.*), title:^(Save File)$

# Game mode (disable animations and effects for better performance)
windowrulev2 = immediate, class:^(steam_app).*
windowrulev2 = immediate, class:^(gamescope).*

#########################
### CLIPBOARD MANAGER ###
#########################

# Clipboard history
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store

# Clipboard keybind
bind = $mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

#####################
### COLOR PICKER ###
#####################

bind = $mainMod SHIFT, C, exec, hyprpicker -a

########################
### SCREEN RECORDING ###
########################

# Note: Install wf-recorder or obs-studio for screen recording
# bind = $mainMod SHIFT, R, exec, wf-recorder -g "$(slurp)" -f ~/Videos/recording_$(date +%Y%m%d_%H%M%S).mp4
# bind = $mainMod CTRL SHIFT, R, exec, killall -s SIGINT wf-recorder

#########################
### WINDOW MANAGEMENT ###
#########################

# Resize mode (vim-like)
bind = $mainMod, I, submap, resize
submap = resize
binde = , h, resizeactive, -20 0
binde = , l, resizeactive, 20 0
binde = , k, resizeactive, 0 -20
binde = , j, resizeactive, 0 20
bind = , escape, submap, reset
submap = reset

# Move windows (vim-like)
bind = $mainMod SHIFT, h, movewindow, l
bind = $mainMod SHIFT, l, movewindow, r
bind = $mainMod SHIFT, k, movewindow, u
bind = $mainMod SHIFT, j, movewindow, d

# Focus windows (vim-like)
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

# Fullscreen
bind = $mainMod, F, fullscreen, 0
bind = $mainMod SHIFT, F, fullscreen, 1

# Pin window
bind = $mainMod SHIFT, P, pin

# Group windows (tabbed layout)
bind = $mainMod, G, togglegroup
bind = $mainMod, Tab, changegroupactive, f
bind = $mainMod SHIFT, Tab, changegroupactive, b

######################
### SYSTEM CONTROL ###
######################

# Lock screen
bind = $mainMod, L, exec, hyprlock

# Logout menu
bind = $mainMod SHIFT, E, exec, wlogout

# Power menu script (create this if needed)
# bind = $mainMod SHIFT, Escape, exec, ~/.local/bin/power-menu
