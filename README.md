Разрешить подключаться к экрану пользоватлея другому пользователю от имени которого запускается графическое приложение "Иконка в трее"
Для этого добавить в файл .bashrc пользователя  
```bash
/usr/bin/xhost +SI:localuser:marat
```

Не запрашивать пароль при выполнении пользователем sudo для этого добавить в файл
sudo visudo
```bash
marat ALL=(ALL) NOPASSWD: ALL
```

Добавить правило udev при подключении и отключеии USB в /etc/udev/rules/10-usb.rules
Изменить имя пользователя и расположение скриптов на свои
```bash
# Rule for attachement of USB flash drive
ACTION=="add", KERNEL=="sd*[!0-9]|sr*", SUBSYSTEMS=="usb", ENV{DISPLAY}=":0" ENV{XAUTHORITY}="/home/marat/.Xauthority" RUN+="/usr/bin/sudo -u marat /home/marat/tray/attach-usb.sh"
# Rule for detachement of USB flash drive
ACTION=="remove", KERNEL=="sd*[!0-9]|sr*", SUBSYSTEMS=="usb", ENV{DISPLAY}=":0" ENV{XAUTHORITY}="/home/marat/.Xauthority" RUN+="/usr/bin/sudo -u marat /home/marat/tray/remove-usb.sh"
```

Правила udev исполняются от root, если не указать явно от какого пользователя. Так как скрипты запускают python, использующий графику, пользователь должен быть не рутовым.

Сделать скрипты <b>attach-usb.sh</b>,<b>remove-usb.sh</b> и <b>tray.py</b> исполняемыми 
```bash
chmod +x attach-usb.sh remove-usb.sh tray.py
```
Внутри скриптов запускается python скрипт от имени пользователя указанного в переменной domainUser

Установить глобальную переменную в /etc/environment для пользователя, под которым предполагается использовать АРМ
```bash
domainUser="ivan.ivanov"
``` 
Предполагается, что пользоваться АРМ будет 1 пользователь, так как невозможно использовать переменную $USER (Определяется после открытия сеанса пользователя) НИ В ОДНОМ ИЗ МЕСТ:
1) Правило udev (из правила возможно запустить скрипт только явно указав пользователя с графикой)
2) Bash скрипт (так как он принимает значение $USER от правила udev, а нам нужно для пользователя, который будет использовать АРМ). 
Использование переменной domainUser внутри скриптов позволяет сделать скрипты универсальными при распространении, но появляется ограничение в в виде 1 пользователь = 1 АРМ
