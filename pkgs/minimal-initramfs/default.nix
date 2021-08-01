{ runCommandNoCC
, writeScript
, writeText
, nukeReferences
, pkgsStatic }:

#
# This is a cheaty initramfs.
# Let's use pkgsStatic so we don't have to actually really care about the
# nix store dependencies.
#

let
  # Console is 50×30
  # Though reminder that the login prompt will take one further line.
  # So line 01 is actually not shown.
  issue = writeText "etc-issue" ''
    ${""/*       12345678901234567890123456789012345678901234567890 */}
    ${""/* 01 */}                                                  ${""/**/}
    ${""/* 02 */}              ::::.    ':::::     ::::'           ${""/**/}
    ${""/* 03 */}              ':::::    ':::::.  ::::'            ${""/**/}
    ${""/* 04 */}                :::::     '::::.:::::             ${""/**/}
    ${""/* 05 */}          .......:::::..... ::::::::              ${""/**/}
    ${""/* 06 */}         ::::::::::::::::::. ::::::    ::::.      ${""/**/}
    ${""/* 07 */}        ::::::::::::::::::::: :::::.  .::::'      ${""/**/}
    ${""/* 08 */}               .....           ::::' :::::'       ${""/**/}
    ${""/* 09 */}              :::::            '::' :::::'        ${""/**/}
    ${""/* 10 */}     ........:::::               ' :::::::::::.   ${""/**/}
    ${""/* 11 */}    :::::::::::::                 :::::::::::::   ${""/**/}
    ${""/* 12 */}     ::::::::::: ..              :::::            ${""/**/}
    ${""/* 13 */}         .::::: .:::            :::::             ${""/**/}
    ${""/* 14 */}        .:::::  :::::          ${"'''''"}              ${""/**/}
    ${""/* 15 */}        :::::   ':::::.  :::::::::::::::::::'     ${""/**/}
    ${""/* 16 */}         :::     ::::::. ':::::::::::::::::'      ${""/**/}
    ${""/* 17 */}                .:::::::: '::::::::::             ${""/**/}
    ${""/* 18 */}               .::::${"''"}::::.     '::::.            ${""/**/}
    ${""/* 19 */}              .::::'   ::::.     '::::.           ${""/**/}
    ${""/* 20 */}             .::::      ::::      '::::.          ${""/**/}
    ${""/* 21 */}                                                  ${""/**/}
    ${""/* 22 */}           (This is not actually NixOS)           ${""/**/}
    ${""/* 23 */}             (But it **IS** on a 3DS)             ${""/**/}
    ${""/* 24 */}                                                  ${""/**/}
    ${""/* 25 */}       +----------------------------------+       ${""/**/}
    ${""/* 26 */}       | Tip of the day                   |       ${""/**/}
    ${""/* 27 */}       | ==============                   |       ${""/**/}
    ${""/* 28 */}       | Login with root and no password. |       ${""/**/}
    ${""/* 29 */}       +----------------------------------+       ${""/**/}
    ${""/* 30 */}                                                  ${""/**/}
  '';

  inittab = writeText "inittab" ''
    tty1::respawn:/bin/getty 0 tty1
    ::restart:/bin/init
    ::ctrlaltdel:/bin/poweroff
    ::shutdown:/etc/shutdown
  '';

  passwd = writeText "passwd" ''
    root::0:0:root:/root:/bin/sh
  '';

  init = writeScript "init" ''
    #!/bin/sh
    PATH="/bin/"
    mount -t proc proc /proc
    mount -t sysfs sys /sys
    mdev -s
    hostname nix3ds
    ip link set lo up
    echo 5 > /proc/sys/kernel/printk
    exec /linuxrc
  '';

  # Let's use a statically built busybox!
  inherit (pkgsStatic) busybox;
in

runCommandNoCC "minimal-initramfs" {
  nativeBuildInputs = [
    nukeReferences
  ];
} ''
  mkdir -p $out

  cp -vr ${busybox}/* $out
  rm $out/default.script

  cp -vr ${init} $out/init

  mkdir -p $out/etc

  cp ${inittab} $out/etc/inittab
  cp ${issue} $out/etc/issue
  cp ${passwd} $out/etc/passwd

  echo ":: Nuking references"
  chmod -R +w $out
  nuke-refs $out/* $out/*/*
  (
  cd $out
  find -type d -printf 'dir   /%h/%f 755 0 0 \n'
  find -type f -printf 'file  /%h/%f '"$out/"'%h/%f %m  0 0 \n'
  find -type l -printf 'slink /%h/%f %l %m  0 0 \n'
  ) > ./files.list
  mv files.list $out/
  sed -i -e 's;/\./;/;g' $out/files.list

  # Add more files to the initramfs
  cat >> $out/files.list <<EOF

  dir /proc 755 0 0
  dir /sys 755 0 0
  dir /mnt 755 0 0
  dir /root 755 0 0

  dir /dev 755 0 0
  nod /dev/console 644 0 0 c 5 1
  nod /dev/loop0 644 0 0 b 7 0
  EOF
''
