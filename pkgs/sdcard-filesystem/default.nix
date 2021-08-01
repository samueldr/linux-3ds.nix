{ lib
, runCommandNoCC
, ctr-packages
, initramfs ? null
}:

# Paths:
#  - https://github.com/linux-3ds/firm_linux_loader/blob/4098b022833bb794383cbf269d6e39a887fc3354/common/linux_config.h#L8-L11
runCommandNoCC "sdcard-filesystem" { } ''
  mkdir -p $out/linux
  cp -vt $out/linux \
    ${ctr-packages.linux}/zImage \
    ${ctr-packages.linux}/dtbs/* \
    ${ctr-packages.arm9linuxfw}/arm9linuxfw.bin
  ${lib.optionalString (initramfs != null) "cp -v ${initramfs} $out/linux/initramfs.cpio.gz"}
  mkdir -p $out/luma/payloads/
  cp -vt $out/luma/payloads/ \
    ${ctr-packages.firm_linux_loader}/firm_linux_loader.firm
''
