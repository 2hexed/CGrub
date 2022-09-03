#!/usr/bin/bash

clear
prtfun(){
	echo '  ___         ___  ____  __  __  ____ '
	echo ' / __) ___   / __)(  _ \(  )(  )(  _ \'
	echo '( (__ (___) ( (_-. )   / )(__)(  ) _ <'
	echo ' \___)       \___/(_)\_)(______)(____/ - 2hexed'
}

prtfun

if [[ $EUID = 0 ]];
then
	echo ""
else
	echo ""
	echo -e "[ \033[91m?\033[0m ] Please provide root privileges!"
	exit
fi

echo ""
echo -e "[ \033[93m!!\033[0m ] Press ENTER to keep the default value.\n[ \033[93m!!\033[0m ] Input none to remove the value."
echo ""
read -p "[ > ] NEW GRUB IMAGE PATH? " BACKGROUND_PATH
read -p "[ > ] NEW GRUB TIMEOUT IN SECONDS? " NEW_TIMEOUT

if [[ ! $NEW_TIMEOUT ]];
then
	NEW_TIMEOUT=5
	echo "`sed '/GRUB_TIMEOUT/d' /etc/default/grub`" > /etc/default/grub
	echo "GRUB_TIMEOUT=$NEW_TIMEOUT" >> /etc/default/grub
	echo -e "[ \033[33;32m✔\033[0m ] Default value for timeout was set to $NEW_TIMEOUT."
elif [[ $NEW_TIMEOUT == "none" ]];
then
	echo -e "[ \033[93m!\033[0m ] Timeout value cannot be set to none, if you still wish to do so, set it to 0 instead."
	echo "[ \033[93m!\033[0m ] Obtaining the default value."
	exit
else
	if [[ $NEW_TIMEOUT =~ ^-?[0-9]+$ ]];
	then
		echo "`sed '/GRUB_TIMEOUT/d' /etc/default/grub`" > /etc/default/grub
		echo "GRUB_TIMEOUT=$NEW_TIMEOUT" >> /etc/default/grub
		echo -e "[ \033[33;32m✔\033[0m ] Timeout was set to $NEW_TIMEOUT."
	else
		echo -e "[ \033[91m?\033[0m ] Invalid timeout value."
		exit
	fi
fi

if [[ ! $BACKGROUND_PATH ]];
then
	echo "`sed '/GRUB_BACKGROUND/d' /etc/default/grub`" > /etc/default/grub
	echo ""
	echo -e "[ \033[33;32m✔\033[0m ] Default value of background set to none."
elif [[ $BACKGROUND_PATH == "none" ]];
then
	echo "`sed '/GRUB_BACKGROUND/d' /etc/default/grub`" > /etc/default/grub
	echo -e "[ \033[33;32m✔\033[0m ] Background image was set to none."
else
	if [[ $BACKGROUND_PATH == *".png" || $BACKGROUND_PATH == *".jpg" || $BACKGROUND_PATH == *".jpeg" ]];
	then
		if [[ -f $BACKGROUND_PATH ]];
		then
			echo "`sed '/GRUB_BACKGROUND/d' /etc/default/grub`" > /etc/default/grub
			echo "GRUB_BACKGROUND=$BACKGROUND_PATH" >> /etc/default/grub
			echo -e "[ \033[33;32m✔\033[0m ] Background image was set to $BACKGROUND_PATH."
		else
			echo -e "[ \033[91m?\033[0m ] File does not exists, hence not changed."
			exit
		fi
	else
		echo -e "[ \033[91m?\033[0m ] Invalid filename value."
		exit
	fi
fi

echo -e "[ \033[93m!\033[0m ] Please wait, generating grub configuration file..."

sudo grub-mkconfig -o /boot/grub/grub.cfg 1>/dev/null

clear

prtfun
echo ""
echo ""

echo -e "[ \033[33;32m✔\033[0m ] SUCCESS!"
