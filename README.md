# CronosKernel
- Exynos 7420 Custom Kernel designed for [FloydRom](https://forum.xda-developers.com/note5/development/rom-floyd-n7fe-port-v1-0-t3882804)

![alt text](https://img.xda-cdn.com/ytrk97JCqO29cB7oDUz608P3lg8=/http%3A%2F%2Fi68.tinypic.com%2F2dgkpz5.png) 

#### Supports

- Noblelte (Galaxy Note5)
- Zenlte (Galaxy S6 Edge+)
- Zeroflte (Galaxy S6 Flat)
- Zerolte (Galaxy S6 Edge)

- International and Audience e-codec varaints (T/W8)

#### Does not support
- QCOM QMUX variants (P/00)
- NXP NFC Variants

#### How to compile

* Adjust your toolchain in [Cronos Build script](../cronos/cronos.sh#L22)
* install dependencies `sudo apt-get install gcc python ccache`
* Run builds `./cronos.sh`

#### Codenames
- intl : International variants (C/F/G etc) 
- us : Variants that rely on audience e-codecs (T/W8/P/R*)
- N920X : Noble         (N5)
- G920F : Zero Flat     (S6)
- G925F : Zero Edge     (S6+)
- G928X : Zen Edge Plus (S6E+)
