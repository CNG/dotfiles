# Screen tearing tests

`/etc/X11/xorg.conf.d/20-intel.conf`:

    Section "Device"
      Identifier  "Intel Graphics"
      Driver      "intel"
      
      # # tearing
      # Option      "TearFree"        "true"

      # # slow cursor before login
      # # tearing when fullscreen video
      # # no tearing in FF without fullscreen
      # Option      "AccelMethod"     "uxa"
      
      # normal cursor before login
      # small bit of tearing nonfullscreen
      # much more tearing fullscreen
      # layers.acceleration.force-enabled = true or false, same result
      # then maybe fixed tearing after adding kernel param i915.enable_guc=2 (and removing backlight one that shouldn't be related)
      Option      "AccelMethod"     "sna" # this is default, wiki claims X can crash without it sometimes
      Option      "TearFree"        "true" # not default

      # # weird display problems in Alacritty terminal
      # # normal login screen behavior
      # # definite tearing
      # Option      "AccelMethod"     "sna"
      # Option      "TearFree"        "true"
      # Option      "DRI"             "2"

      # # very slow cursor before login
      # # but apparently no tearing on https://www.youtube.com/watch?v=MfL_JkcEFbE
      # # nevermind, no tearing when not maximized but 
      # # definite tearing when fullscreen
      # Option      "AccelMethod"     "uxa"
      # Option      "DRI"             "3"

    EndSection
