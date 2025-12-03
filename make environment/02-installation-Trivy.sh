#!/bin/bash
############################################
# 02-installation-Trivy.sh
# contexte :
# installation de Trivy sur ubuntu 24.04.3 LTS
# Etapes :
############################################
#Mettre à jour la liste des paquets
sudo apt update

#S’assurer que les outils nécessaires sont installés
sudo apt install curl gnupg apt-transport-https

#  Explication :
# curl -> télécharge la clé depuis Internet
# gnupg ->convertit la clé en format binaire que APT comprend
# apt-transport-https → permet à APT d’accéder aux dépôts HTTPS


# Créer le dossier /etc/apt/keyrings (si absent)
sudo mkdir -p /etc/apt/keyrings


#Télécharger la clé Trivy et la convertir en .gpg
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key \
 | sudo gpg --dearmor -o /etc/apt/keyrings/trivy.gpg

 #Ajouter le dépôt Trivy dans APT avec "signed-by="
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb         $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
  #lsb_release -sc = donne le “codename” de Ubuntu
  #Rafraîchir les sources
   sudo apt update

   #Installer Trivy
  sudo apt install trivy

  #Vérifier l’installation
  trivy --version