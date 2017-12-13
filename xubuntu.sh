#!/bin/bash

# Stéphane Deluce
# 12 Décembre 2017
# <stephane@deluce.fr>

# ----------------------------------------------------------------------------------------
# paquets disponnibles dans les dépots ubuntu
# ----------------------------------------------------------------------------------------
compilateur="build-essential gcc"

devtoolbox="git zsh htop nodejs curl wget" #composer, npm

editeur="vim-gnome poedit"

securite="gnupg tor deb.torproject.org-keyring" #Seahorse

video="vlc mozilla-plugin-vlc cheese"

graphisme="gimp inkscape"

divers="filezilla caffeine bleachbit" #ngrok, transfer.sh,

style="" #La Capitaine icons
#https://github.com/LinxGem33/OSX-Arc-White/releases
#https://github.com/keeferrourke/la-capitaine-icon-theme

# paquets à installer
paquets="$compilateur $devtoolbox $editeur $video $son $graphisme $divers $style"

# ----------------------------------------------------------------------------------------
# Options de apt-get pour l'installation des paquets
# ----------------------------------------------------------------------------------------
options="--auto-remove --yes -q"

# ----------------------------------------------------------------------------------------
# Test des droits administrateur
# ----------------------------------------------------------------------------------------
if [ $USER != "root" -o $UID != 0 ]
then
  echo "Ce script doit être exécuté en tant qu'administrateur (root)."
  echo "Placez sudo devant votre commande :"
  echo "sudo $0"
  echo "Abandon"
  exit 1
fi

echo "Assurez-vous d'avoir lu et compris le script avant de l'exécuter."
echo -n "Êtes-vous sûr de savoir ce que vous faites ? (y/n) "
read rep
if [ $rep != "o" ] && [ $rep != "oui" ] &&
   [ $rep != "y" ] && [ $rep != "yes" ]
then
  echo "Pour lire le script, entrez la commande suivante :"
  echo "gedit $0 &"
  exit 1
fi

# version d'ubuntu
version=`lsb_release -cs`
echo "* Ajout des dépots pour Ubuntu $version"

# ----------------------------------------------------------------------------------------
# ajouts de dépots
# ----------------------------------------------------------------------------------------

# partenaires
echo -e "\n* Canonical partners"
cp -v /etc/apt/sources.list /etc/apt/sources.list.bak
echo "sed \"s/# deb http\:\/\/archive.canonical.com/deb http\:\/\/archive.canonical.com/\" /etc/apt/sources.list > sources.list.new"
sed "s/# deb http\:\/\/archive.canonical.com/deb http\:\/\/archive.canonical.com/" /etc/apt/sources.list > sources.list.new
cp -v sources.list.new /etc/apt/sources.list

codecs="non-free-codecs"

# virtual box
echo "deb http://download.virtualbox.org/virtualbox/debian $version contrib" | sudo tee -a /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 98AB5139
virtualbox=" virtualbox"

# Androif file transfer
add-apt-repository -y ppa:samoilov-lex/aftl-stable
mtp=" android-file-transfer"

# Java oracle
add-apt-repositoryS -y ppa:webupd8team/java
java=" oracle-java8-installer"

# RedShift
add-apt-repository -y ppa:nathan-renniewaldock/flux
redshift=" redshift"

add-apt-repository -y ppa:upubuntu-com/xampp
xampp=" xampp"

#Spotify
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
spotify=" spotify-client"

paquets="$paquets $virtualbox $java $spotify $xampp $redshift"

# ----------------------------------------------------------------------------------------
# mise à jour des sources de logiciels
# ----------------------------------------------------------------------------------------
echo -e "\napt-get -q clean"
apt-get -q clean
echo -e "\napt-get -q update"
apt-get -q update
echo -e "\napt-get -q --yes upgrade"
apt-get -q --yes upgrade

# ----------------------------------------------------------------------------------------
# installation des paquets
# ----------------------------------------------------------------------------------------
for paquet in $paquets
do
    echo -e "\n----------------------------------------------------------------"
    echo " INSTALLATION DE : $paquet"
    echo -e "----------------------------------------------------------------\n"
    apt-get $options install $paquet
done

# ----------------------------------------------------------------------------------------
# nettoyage
# ----------------------------------------------------------------------------------------
echo -e "\n----------------------------------------------------------------"
echo " PURGE : apt-get -q --yes autoremove"
echo -e "----------------------------------------------------------------\n"
apt-get -q --yes autoremove
