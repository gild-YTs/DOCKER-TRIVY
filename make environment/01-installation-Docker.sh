#!/bin/bash
############################################
# 01-installation-Docker.sh
# contexte :
# installation de Docker sur ubuntu 24.04.3 LTS
# Etapes :
############################################
# ---------------------------------------------------------------
# 1. supprimer les anciennes versions (si elles existent)
# ---------------------------------------------------------------
 sudo apt-get remove docker docker-engine docker.io containerd runc
  #Les noms listés sont les anciens noms possibles de Docker
  #Si rien n’est installé, la commande le dira 

# ---------------------------------------------------------------
# 2. installer les outils necessaires pour communiquer en HTTPS
# ---------------------------------------------------------------
  #Pour que le système puisse télécharger des paquets depuis Internet en toute sécurité.
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg
#  Explication :
# . ca-certificates : vérifie les certificats HTTPS
# · curl : télécharge des fichiers depuis Internet
# · gnupg : gère les clés de sécurité (indispensable)

# ---------------------------------------------------------------
# 3. ajouter la clé officielle de Docker (sécurité)
# ---------------------------------------------------------------
 sudo install -m 0755 -d /etc/apt/keyrings
  #créer un dossier /etc/apt/keyrings 
   #On veut stocker la clé de confiance (la clé GPG) .
   # C’est une bonne pratique (organisation + sécurité).
   #install : commande utile pour créer des fichiers ou dossiers en définissant tout de suite des permissions.
   # On peut aussi utiliser mkdir,
   # mais install permet de définir les droits en une seule fois.
   #  -m 0755 : indique les permissions (mode) à appliquer au dossier créé.
   # 7 = rwx (4 + 2 + 1 = 7) root
   # 5 = rx (4 + 1 = 5) sudo
   # 5 = rx (4 + 1 = 5) autres
   # Pour un dossier, "exécution" signifie pouvoir entrer dedans (cd) et traverser.
   #la lecture signifie pouvoir Voir la liste des fichiers et sous-dossiers qu’il contient.
   # -d : indique qu’on veut créer un dossier (directory).
 
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   #-f / --fail : si la réponse HTTP est une erreur (ex : 404, 500), curl sort avec une erreur au lieu d’enregistrer du HTML d’erreur.
   # Utile pour ne pas continuer si le téléchargement a échoué.
   #-s / --silent : mode silencieux (pas d’affichage de la barre de progression).
   #-S permet d’afficher l’erreur
   #-L / --location : suit automatiquement les redirections HTTP (si l’URL redirige vers une autre adresse).
   #L’URL https://download.docker.com/linux/ubuntu/gpg : c’est l’emplacement public de la clé GPG fournie par Docker
   #la cle est un texte en "ASCII-armored"
   #ASCII-armored est un encodage de données binaires en texte ASCII pour pouvoir les transmettre facilement par e-mail ou les copier/coller
   #le pipe | prend la sortie de curl et le donne á la commande suivante
   #gpg : l’outil de gestion de clés GPG/OpenPGP.
   # --dearmor : convertit une clé ASCII-armored en format binaire.
   # apt préfère un fichier .gpg binaire au lieu du texte. Le binaire est plus simple à charger .
   # -o /etc/apt/keyrings/docker.gpg : -o indique le fichier de sortie .

 sudo chmod a+r /etc/apt/keyrings/docker.gpg
   #chmod : change les permissions (mode) d’un fichier.
   # a+r : a = all (tout le monde ); +r = ajouter le droit lecture.
   # Cela donne lecture à tous.
   #verifié Que le fichier existe et ses permissions :
     ls -l /etc/apt/keyrings/docker.gpg
   #creer le dossier .gnupg  
    sudo mkdir -p /root/.gnupg
    sudo chmod 700 /root/.gnupg
      #.gnupg stock les clés personnelles du compte root --rien á voir avec docker en particulier
      #docker.gpg contient la clé utiliser par apt pour vérifier le fichier docker

   #Lister les clés dans ce fichier GPG (pour confirmer contenu) :
     sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/docker.gpg --list-keys 
     #si vous avez une erreur comme sur l'image ./resultats/3a.png
     
# ---------------------------------------------------------------
# 4. ajouter la source officielle où se trouve Docker
# ---------------------------------------------------------------
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  # echo sert juste à afficher du texte dans le terminal.
  #deb veut dire Ceci est un dépôt APT contenant des paquets .deb

  # arch=$(dpkg --print-architecture) 
  # demande à dpkg quel type de machine on est .
  # Docker fournit des paquets différents selon l’architecture.

  # signed-by=/etc/apt/keyrings/docker.gpg
  # indique à apt d'utiliser la clé /etc/apt/keyrings/docker.gpg pour verifier le fichier docker
  # C’est là que le fichier docker.gpg est utilisé.
  #APT refusera tout paquet Docker qui n’est pas signé par cette clé.
 
  #https://download.docker.com/linux/ubuntu
  #C’est l’adresse du serveur officiel de Docker.

  #$(. /etc/os-release && echo $VERSION_CODENAME)
  #Lire . /etc/os-release pour trouver le nom de version (exemple : jammy, noble, focal)
  #echo $VERSION_CODENAME --et le mettre automatiquement le bon nom ici
  #Docker fournit des paquets différents selon la version Ubuntu.

  # stable
  #On demande la version "stable" du dépôt Docker, pas :

  # sudo tee /etc/apt/sources.list.d/docker.list
  #tee écrit dans le fichier /etc/apt/sources.list.d/docker.list
  #le fichier qui dit à APT  où aller pour trouver Docker.

  # > /dev/null
  #Ça supprime la sortie affichée par tee.
  #Sans ça, tee réafficherait tout dans le terminal.
  #C’est seulement pour faire propre.

# ---------------------------------------------------------------
# 5. mettre à jour la liste des paquets
# ---------------------------------------------------------------
#metter vous en root 
 sudo -i
 apt-get update 
 exit
# ---------------------------------------------------------------
# 6. installer Docker
# ---------------------------------------------------------------
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Explication :
 # docker-ce : le moteur Docker
 # docker-ce-cli : les commandes Docker
 # containerd.io : gestion interne des conteneurs
 # docker-buildx-plugin : pour construire des images avancées
 # docker-compose-plugin : pour utiliser docker compose

# ---------------------------------------------------------------
#7. Tester Docker
# ---------------------------------------------------------------
    # vérifier la version installée,
      docker --version
    # tester l’exécution d’un conteneur,
      sudo docker run hello-world
    # confirmer que le daemon Docker fonctionne correctement.
      sudo systemctl status docker
 #Si tout va bien, Docker télécharge une petite image et affiche un message de succès.
