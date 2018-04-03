# GRC colorizes nifty unix tools all over the place
# if (( $+commands[grc] )) && (( $+commands[brew] ))
if [[ -r /etc/profile.d/grc.bashrc ]]; then
  source /etc/profile.d/grc.bashrc
fi
