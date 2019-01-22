# Dell P2415Q screen wake issues

I've had problems on macOS and now Linux with my Dell P2415Q 4K displays. They
are sometimes hard to wake after standby mode, requiring either turning off and
on again with the power button or fully unplugging the display and plugging back
in.

I had disabled DPMS some time ago because I thought it helped:

    xset -dpms

Its seems that's not working anymore. According to [a 2015 forum](https://www.dell.com/community/Monitors/P2415Q-does-not-wake-up-after-standby/td-p/4727228):

> But what worked for me was: on the monitor, go to the "menu", choose "others"
> then on the "DDC/CI" option, change to "Disable" instead of enable

Tried that with DPMS still disabled, and I still needed to turn off monitor to
get it to wake on my Thinkpad with display pluggen in through CalDigit hub over
DisplayPort.

Will troubleshoot more later and make notes here.

