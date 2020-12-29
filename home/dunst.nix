{
  services.dunst = {
    enable = true;
    settings = {
     global = {
       # browser = "/usr/bin/env firefox -new-tab";
       #foo
       follow = "mouse";
       font = "Iosevka 10";
       frame_color = "#b16286";
       frame_width = "2";
       geometry = "800x10-8+8";
       horizontal_padding = "2";
       padding = "2";
       shrink = false;
       word_wrap = true;
     };
     urgency_critcal = {
       background = "#3c3836";
       foreground = "#ebdbb2";
       timeout = 10;
     };
     urgency_low = {
       background = "#3c3836";
       foreground = "#ebdbb2";
       timeout = 10;
     };
     urgency_normal = {
       background = "#3c3836";
       foreground = "#ebdbb2";
       timeout = 10;
     };
   };
 };
}
