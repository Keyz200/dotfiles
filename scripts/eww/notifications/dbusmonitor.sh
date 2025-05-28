#!/bin/sh
processcheck=$(pgrep -f "dbusmonitor.sh")
if [ "$processcheck" == "" ]; then
  exit 1
fi

dbus-monitor "interface='org.freedesktop.Notifications',member='Notify'" |
  awk '/member=Notify/{f=1; i=0; next} 
      f && /^   string / {i++; 
        if(i==1) s0=$0;
        if(i==3) s1=$0; 
        if(i==4) {s2=$0; f=0; 
          gsub(/^   string "/, "", s0);
          gsub(/"$/, "", s0);
          gsub(/^   string "/, "", s1); 
          gsub(/"$/, "", s1);
          gsub(/^   string "/, "", s2); 
          gsub(/"$/, "", s2);
          
          file = "/tmp/eww/notifications/.notification";
          filedummy = "/tmp/eww/notifications/.dummy";
          
          if (system("test -f " file) == 0) {
            system("sed -i \"1i" s2 "\" " file);
            system("sed -i \"1i" s1 "\" " file);
            system("sed -i \"1i" s0 "\" " file);
          } else {
            print s0 > file;
            print s1 >> file;
            print s2 >> file;
          }
          system("chmod 644 " file);
          system("sed -i \"1s/.*/" s0 "/;2,\\$d\" " filedummy);
        }
      }'
