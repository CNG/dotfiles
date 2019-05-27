Connected:

`xrandr | grep -oP '^\S+(?= connected)'`

Active: 

`xrandr | grep -oP '^\S+(?= connected (?:primary )?\d+)'`

Clones:

`xrandr --output X --auto --output Y --auto --same-as X`

Separate:

`xrandr --output X --auto --output Y --auto --left-of X`

Rotate:

`xrandr --output X --rotate left`

Info for `$OUTPUT`:

`xrandr | grep -zoP "\n${OUTPUT}.*\n(?:  .*\n)+"`

Brightness:

`xrandr --output DP-1 --brightness .75`

## Screen tearing

Firefox setting: [`layers.acceleration.force-enabled`](about:config?filter=layers.acceleration.force-enabled)

https://bugs.freedesktop.org/show_bug.cgi?id=96847#c1

https://bbs.archlinux.org/viewtopic.php?id=229111


## Notes from troubleshooting display problem

```
 Device 0 [GeForce GTX 1080 Ti] PCIe GEN 2@ 4x RX: 27.00 MB/s TX: 7.000 MB/s
 GPU 1873MHz MEM 5005MHz TEMP  89°C FAN  95% POW 249 / 270 W
 GPU-Util[|||||||||||||||||||88%] MEM-Util[           0.2G/11.7G] Encoder[     0%] Decoder[     0%]

 Device 1 [GeForce GTX 1080 Ti] PCIe GEN 3@ 8x RX: 20.00 MB/s TX: 3.000 MB/s
 GPU 1911MHz MEM 5005MHz TEMP  75°C FAN  56% POW 164 / 270 W
 GPU-Util[||||||||||         44%] MEM-Util[           0.2G/11.7G] Encoder[     0%] Decoder[     0%]

 Device 2 [GeForce GTX 1080 Ti] PCIe GEN 3@ 8x RX: 160.0 MB/s TX: 130.0 MB/s
 GPU 1632MHz MEM 5005MHz TEMP  86°C FAN  89% POW 159 / 270 W
 GPU-Util[|||||||||||||||    66%] MEM-Util[           0.2G/11.7G] Encoder[     0%] Decoder[     0%]

 Device 3 [GeForce GTX 1080 Ti] PCIe GEN 3@16x RX: 26.00 MB/s TX: 6.000 MB/s
 GPU 1657MHz MEM 5005MHz TEMP  89°C FAN  99% POW 183 / 270 W
 GPU-Util[|||||||||||||||||||88%] MEM-Util[|          0.8G/11.7G] Encoder[     0%] Decoder[     0%]

  PID        USER GPU    TYPE            MEM Command
 3296 cgorichanaz   3 Graphic       7Mo 0.1% ./insync
 4887 cgorichanaz   3 Graphic      12Mo 0.1% alacritty
87281        root   1 Compute     177Mo 1.5% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
32858        root   2 Compute     185Mo 1.6% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
72200        root   3 Compute     193Mo 1.7% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
 1669        root   0 Compute     208Mo 1.8% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
 3176 cgorichanaz   3 Graphic     223Mo 1.9% compton
 2919        root   3 Graphic     323Mo 2.8% /usr/lib/Xorg




$  lspci | grep VGA
07:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)
09:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)
42:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)
43:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)



$ grep GP102-A /var/log/Xorg.0.log
[    47.721] (II) NVIDIA(0): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:67:0:0
[    47.888] (II) NVIDIA(GPU-1): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:7:0:0 (GPU-1)
[    47.937] (II) NVIDIA(GPU-2): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:9:0:0 (GPU-2)
[    47.987] (II) NVIDIA(GPU-3): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:66:0:0


    143 [    47.722] (--) NVIDIA(GPU-0): DELL P2415Q (DFP-4): connected
    144 [    47.722] (--) NVIDIA(GPU-0): DELL P2415Q (DFP-4): Internal DisplayPort
    145 [    47.722] (--) NVIDIA(GPU-0): DELL P2415Q (DFP-4): 1440.0 MHz maximum pixel clock


$ nvidia-smi
Sun Nov 11 10:23:51 2018
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 410.66       Driver Version: 410.66       CUDA Version: 10.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 108...  Off  | 00000000:07:00.0 Off |                  N/A |
| 86%   84C    P2   194W / 270W |    205MiB / 11178MiB |     82%      Default |
+-------------------------------+----------------------+----------------------+
|   1  GeForce GTX 108...  Off  | 00000000:09:00.0 Off |                  N/A |
| 61%   76C    P2   205W / 270W |    197MiB / 11178MiB |     70%      Default |
+-------------------------------+----------------------+----------------------+
|   2  GeForce GTX 108...  Off  | 00000000:42:00.0 Off |                  N/A |
| 86%   83C    P2   163W / 270W |    189MiB / 11178MiB |     63%      Default |
+-------------------------------+----------------------+----------------------+
|   3  GeForce GTX 108...  Off  | 00000000:43:00.0  On |                  N/A |
| 88%   86C    P2   191W / 270W |    631MiB / 11175MiB |     65%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0      1937      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   193MiB |
|    1      1872      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   185MiB |
|    2      1860      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   177MiB |
|    3      2100      G   /usr/lib/Xorg                                280MiB |
|    3      2621      G   compton                                      150MiB |
|    3      2725      G   ./insync                                       7MiB |
|    3      8358      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   177MiB |
|    3      9322      G   alacritty                                     12MiB |
+-----------------------------------------------------------------------------+



$ nvidia-smi --query-gpu=pci.bus_id,pci.domain,pci.bus,pci.device,pci.device_id,pci.sub_device_id --format=csv
pci.bus_id, pci.domain, pci.bus, pci.device, pci.device_id, pci.sub_device_id
00000000:07:00.0, 0x0000, 0x07, 0x00, 0x1B0610DE, 0x247119DA
00000000:09:00.0, 0x0000, 0x09, 0x00, 0x1B0610DE, 0x247119DA
00000000:42:00.0, 0x0000, 0x42, 0x00, 0x1B0610DE, 0x247119DA
00000000:43:00.0, 0x0000, 0x43, 0x00, 0x1B0610DE, 0x247119DA


xorg.conf - Configuration File for Xorg
https://www.x.org/archive/X11R6.8.0/doc/xorg.conf.5.html

    Integer     an integer number in decimal, hex or octal
    Real        a floating point number
    String      a string enclosed in double quote marks (")

Note: hex integer values must be prefixed with "0x", and octal values with "0".
```


