#!/bin/bash

# Ask for password
sudo echo "Start"

# Check if it is Linux
echo "Checking for operating system information"
if [ `uname -o` = "GNU/Linux" ]
   then
      echo `uname -o`
         if [ `uname -s` = "Linux" ]
            then
               echo `uname -s`
            else
               echo "Error: Not a Linux distribution"
               echo "This script will be terminated."
               read
               exit
         fi
   else
      echo "Error: Not a Linux distribution"
      echo "This script will be terminated."
      read
      exit
fi

# Read and export variables with OS info and silence error output
export $( cat -v /etc/*release ) 2> /dev/null
echo "Detected OS: $NAME $VERSION_ID $VARIANT"

case $ID in

   fedora)
      # Version check
      if (( "$VERSION_ID" < "37" ))
         then
            echo "$NAME version $VERSION_ID detected"
            echo "Only version 37 and newer are supported"

            while true;
            do
               read -p $'Do you wish to proceed?\n' yn
               case $yn in
                  [Yy]* )
                     echo "Proceeding..."
                     break
                  ;;

                  [Nn]* )
                     echo "This script will be terminated."
                        read
                        exit
                  ;;

                  * ) echo "Please answer \"yes\" or \"no\".";;
               esac
            done
         else
            echo "$NAME version $VERSION_ID detected"
   
      fi
   
      # Variant check
      if [ "$VARIANT_ID" == "silverblue" ]
         then
            echo "Variant $VARIANT detected"
         else
            echo "Variant $VARIANT detected"
            echo "Your Fedora variant is not supported."
            echo "This script will be terminated."
            read
            exit
      fi
   ;;

   ubuntu)
      echo "$NAME detected"
      echo "I express you my deepest condolences"
      echo "This script will be terminated."
      read
      exit
   ;;

   *)
      echo "Your distribution is not supported. Please check the list of supported distributions."
      echo "This script will be terminated."
      read
      exit
   ;;
esac

# Install "Dash to Dock" by @michele_g
# busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s dash-to-dock@micxgx.gmail.com
# Disable "Dash to Dock" by @michele_g
# sudo gnome-extensions disable "dash-to-dock@micxgx.gmail.com"

# Install "Dash to Panel" by @charlesg99 and @jderose9
# busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s dash-to-panel@jderose9.github.com
# Enable "Dash to Panel" by @charlesg99 and @jderose9
# sudo gnome-extensions enable "dash-to-panel@jderose9.github.com"

# Enable minimize and maximize buttons
echo "Enabling minimize and maximize buttons"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
if [ $? -eq 0 ];
   then
      echo "[✓] SUCCESS"
   else
      echo "[✗] FAIL"
fi

# Add Flathub repository:
echo "Adding Flathub repository"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if [ $? -eq 0 ];
   then
      echo "[✓] SUCCESS"
   else
      echo "[✗] FAIL"
fi

# Enable Flathub repository:
echo "Enabling Flathub repository"
sudo flatpak remote-modify --enable flathub
if [ $? -eq 0 ];
   then
      echo "[✓] SUCCESS"
   else
      echo "[✗] FAIL"
fi

# Disable Fedora repository:
echo "Disabling Fedora repository"
sudo flatpak remote-modify --disable fedora
if [ $? -eq 0 ];
   then
      echo "[✓] SUCCESS"
   else
      echo "[✗] FAIL"
fi

# Remove all applications and runtimes:
echo "Removing all apps and runtimes"
sudo flatpak uninstall --all -y
if [ $? -eq 0 ];
   then
      echo "[✓] SUCCESS"
   else
      echo "[✗] FAIL"
fi

# Install back Fedora default applications from Flathub:
echo "Installing back default apps from Flathub"
flatpak install flathub -y org.fedoraproject.MediaWriter &&
flatpak install flathub -y org.gnome.Calculator &&
flatpak install flathub -y org.gnome.Calendar &&
flatpak install flathub -y org.gnome.Characters &&
flatpak install flathub -y org.gnome.Connections &&
flatpak install flathub -y org.gnome.Contacts &&
flatpak install flathub -y org.gnome.Evince &&
flatpak install flathub -y org.gnome.Extensions &&
flatpak install flathub -y org.gnome.FileRoller &&
flatpak install flathub -y org.gnome.Logs &&
flatpak install flathub -y org.gnome.Maps &&
flatpak install flathub -y org.gnome.NautilusPreviewer &&
flatpak install flathub -y org.gnome.TextEditor &&
flatpak install flathub -y org.gnome.Weather &&
flatpak install flathub -y org.gnome.baobab &&
flatpak install flathub -y org.gnome.clocks &&
flatpak install flathub -y org.gnome.eog &&
flatpak install flathub -y org.gnome.font-viewer &&

# Install Flatpak apps
echo "Installing Flatpak apps"
flatpak install flathub -y com.google.Chrome &&
flatpak install flathub -y com.parsecgaming.parsec &&
flatpak install flathub -y com.anydesk.Anydesk &&
flatpak install flathub -y com.transmissionbt.Transmission &&
flatpak install flathub -y org.videolan.VLC &&
flatpak install flathub -y com.obsproject.Studio &&
flatpak install flathub -y org.libreoffice.LibreOffice &&
flatpak install flathub -y org.gnome.Firmware &&
flatpak install flathub -y org.gnome.Connections &&
flatpak install flathub -y org.gnome.Boxes &&
flatpak install flathub -y org.gnome.Extensions &&
flatpak install flathub -y com.mattjakeman.ExtensionManager &&
flatpak install flathub -y io.github.realmazharhussain.GdmSettings &&
flatpak install flathub -y com.github.tchx84.Flatseal &&
flatpak install flathub -y com.usebottles.bottles &&
flatpak install flathub -y io.github.prateekmedia.appimagepool &&
flatpak install flathub -y org.telegram.desktop &&
flatpak install flathub -y com.visualstudio.code &&
flatpak install flathub -y io.podman_desktop.PodmanDesktop

# Enable PWA support in Google Chrome
echo "Enabling PWA support in Google Chrome"
flatpak override --user \
  --filesystem=~/.local/share/applications \
  --filesystem=~/.local/share/icons \
 com.google.Chrome
if [ $? -eq 0 ];
   then
      echo "[✓] SUCCESS"
   else
      echo "[✗] FAIL"
fi

# Set up templates
touch ~/Templates/new.txt
if [ $? -eq 0 ];
   then
      echo "[✓] SUCCESS"
   else
      echo "[✗] FAIL"
fi

# Apply latest updates
if [[ "$VARIANT_ID" == "silverblue" || "kinoite" ]]
   then
      echo "Applying latest updates"
      sudo rpm-ostree update
      echo "Updates will be applied on next reboot"
   else
      echo "Your Fedora variant is not supported."
      echo "This script will be terminated."
      read
      exit
fi

# Keep terminal open after completion
echo "✂✂✂   Script ended   ✂✂✂"
read