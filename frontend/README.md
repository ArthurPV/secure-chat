# Documentation du Frontend Chat Sécurisé

## Vue d'ensemble
Ce projet est une application de chat sécurisé pour Android construite avec Flutter. Il utilise Firebase Authentication (via vérification par téléphone) et Firestore pour le stockage des données, tout en fournissant un chiffrement de bout en bout utilisant une approche hybride RSA + AES. L'interface est structurée en composants modulaires qui gèrent l'authentification, la gestion du profil, la messagerie, les contacts et les paramètres. Cette documentation offre un aperçu de l'architecture, détaille les responsabilités de chaque composant, et explique comment utiliser et étendre le frontend.

## Table des matières
- [Vue d'ensemble de l'architecture](#vue-densemble-de-larchitecture)
- [Composants clés](#composants-clés)
  - [Local Storage](#local-storage)
  - [Secure Store](#secure-store)
  - [Crypto Utilities](#crypto-utilities)
  - [Data Repository](#data-repository)
  - [Authentication & Profile](#authentication--profile)
  - [Chats and Messaging](#chats-and-messaging)
  - [Contacts](#contacts)
  - [Settings](#settings)
- [Utilisation du frontend](#utilisation-du-frontend)
- [Extension du frontend](#extension-du-frontend)
- [Résumé](#résumé)

## Vue d'ensemble de l'architecture

Le frontend est construit autour des domaines clés suivants :

### Gestion de l'authentification et du profil :
- **Firebase Phone Authentication :** L'application vérifie les utilisateurs en envoyant un code SMS.
- **Configuration du profil :** Après vérification, l'utilisateur est invité à définir un nom d'utilisateur et une phrase de passe. Si aucune paire de clés RSA n'existe localement, une nouvelle paire est générée. La clé privée est chiffrée avec la phrase de passe et stockée sur l'appareil, tandis que la clé publique est sauvegardée dans Firestore.

### Stockage des données :
- **Stockage distant :** Firestore est utilisé pour stocker les profils utilisateur, les messages de chat et les contacts.
- **Local Storage :** SharedPreferences est utilisé pour stocker les données spécifiques à l'utilisateur telles que les clés privées chiffrées, les noms d'utilisateur et les numéros de téléphone.
- **Secure Storage :** Flutter Secure Storage est utilisé pour stocker de manière sécurisée les données sensibles (la phrase de passe).

### Chiffrement :
- **Chiffrement hybride :** Chaque message est chiffré avec une clé AES générée aléatoirement (en utilisant AES-GCM), et la clé AES est ensuite chiffrée avec les clés publiques RSA de l'expéditeur et du destinataire. Cela permet aux deux parties de déchiffrer le message.
- **Crypto Utilities :** La logique de chiffrement, de déchiffrement et de génération de clés est fournie par des fonctions utilitaires utilisant la bibliothèque PointyCastle.

### Écrans de l'interface :
- **Écran de vérification par code :** Gère la vérification du code SMS.
- **Écran de profil :** Configure les détails de l'utilisateur et gère la génération de la paire de clés RSA.
- **Écran des chats :** Affiche une liste de conversations avec des aperçus déchiffrés et des horodatages.
- **Écran de détail du chat :** Affiche la conversation complète, les messages déchiffrés, et permet l'envoi de nouveaux messages.
- **Écran des contacts :** Permet la gestion des contacts.
- **Écran des paramètres :** Offre des options pour modifier le profil ou se déconnecter.

### Abstraction du dépôt de données :
- **Interface DataRepository :** Abstrait les opérations de données (mise à jour du profil, messagerie, gestion des contacts) de sorte que l'interface utilisateur soit découplée de l'implémentation Firebase sous-jacente.

## Composants clés

### Local Storage
- **Fichier :** `lib/utils/local_storage.dart`
- **But :** Utilise SharedPreferences pour stocker et récupérer des données spécifiques à l'utilisateur (par exemple, les clés privées chiffrées, noms d'utilisateur, numéros de téléphone et photos de profil).
- **Fonctions clés :**
  - `savePrivateKeyForUid(uid, encryptedPrivateKeyJson)`
  - `getPrivateKeyForUid(uid)`
  - `saveUsername(username)`
  - `getUsername()`

### Secure Store
- **Fichier :** `lib/utils/sercure_store.dart`
- **But :** Utilise Flutter Secure Storage pour stocker de manière sécurisée les données sensibles telles que la phrase de passe pour déchiffrer la clé privée.
- **Fonctions clés :**
  - `savePassphraseForUid(uid, passphrase)`
  - `getPassphraseForUid(uid)`
  - `clearPassphraseForUid(uid)`

### Crypto Utilities
- **Fichier :** `lib/utils/crypto_utils.dart`
- **But :** Fournit des fonctions cryptographiques incluant la génération de paires de clés RSA, le chiffrement/déchiffrement utilisant AES-GCM, et le chiffrement/déchiffrement RSA.
- **Fonctions clés :**
  - `generateRSAKeyPair()`
  - `encryptPrivateKey(privateKeyPem, passphrase)`
  - `decryptPrivateKey(encryptedBase64, ivBase64, passphrase)`
  - `rsaEncrypt(plaintext, publicKey)`
  - `rsaDecrypt(ciphertextBase64, privateKey)`
  - `aesEncrypt(plaintext, aesKey)`
  - `aesDecrypt(ciphertextBase64, ivBase64, aesKey)`

### Data Repository
- **Fichier :** `lib/repositories/data_repository.dart`
- **But :** Définit l'interface DataRepository et fournit une implémentation Firebase qui gère :
  - Les opérations de profil utilisateur (récupération et mise à jour des données)
  - Les opérations de chat (création de chats, envoi et déchiffrement des messages)
  - Les opérations de contact (ajout, récupération et suppression de contacts)
- **Avantage :** Découple la logique des données du code de l'interface, rendant le frontend plus modulaire et plus facile à étendre.

### Authentication & Profile

#### Écran de vérification par code :
- **Fichier :** `lib/screens/verification_code.dart`
- **But :** Gère la vérification par SMS via Firebase et redirige l'utilisateur vers l'écran de chat ou de profil en fonction de l'existence d'une clé locale valide.

#### Écran de profil :
- **Fichier :** `lib/screens/profile.dart`
- **But :** Invite l'utilisateur à saisir un nom d'utilisateur et une phrase de passe. Génère et chiffre une nouvelle paire de clés RSA si aucune n'existe, ou réenregistre la phrase de passe si la clé existe déjà. Met à jour le profil utilisateur (y compris la clé publique) dans Firestore.

### Chats and Messaging

#### Écran des chats :
- **Fichier :** `lib/screens/chats.dart`
- **But :** Affiche une liste de conversations, montrant :
  - Le nom de la conversation (dérivé du nom d'utilisateur de l'autre participant)
  - Un aperçu déchiffré du dernier message (en utilisant la mise en cache pour fluidifier)
  - L'horodatage du dernier message
- **Navigation :** Permet de naviguer vers l'écran de détail du chat.

#### Écran de détail du chat :
- **Fichier :** `lib/screens/chat_detail.dart`
- **But :** Affiche la conversation complète avec les messages déchiffrés et les horodatages.
  - Utilise une stratégie de mise en cache et un indicateur de chargement global pour minimiser les affichages "Déchiffrement…".
  - Fournit un champ de saisie pour envoyer de nouveaux messages chiffrés.

### Contacts
- **Fichier :** `lib/screens/contacts.dart`
- **But :** Permet aux utilisateurs de visualiser, ajouter, modifier ou supprimer des contacts. Les contacts sont stockés par utilisateur dans Firestore.

### Settings
- **Fichier :** `lib/screens/settings.dart`
- **But :** Affiche les informations de l'utilisateur (nom d'utilisateur, numéro de téléphone, photo de profil) et fournit des options pour modifier le profil ou se déconnecter.
  - La fonctionnalité de déconnexion peut effacer certaines données locales (comme la phrase de passe) tout en conservant éventuellement la clé privée.

## Utilisation du frontend

### Installation :
1. Clonez le dépôt et installez Flutter.
2. Exécutez `flutter pub get` pour installer toutes les dépendances.
3. Configurez votre projet Firebase (activez Firebase Authentication, Firestore, etc.) et configurez votre projet Flutter avec le fichier approprié `google-services.json` (Android) ou `GoogleService-Info.plist` (iOS).

### Authentification :
- Lancez l'application. L'utilisateur est présenté avec un écran de vérification par téléphone.
- Après la vérification SMS réussie, l'application vérifie l'existence d'une paire de clés RSA.
- Si aucune clé n'est trouvée, l'écran de profil invite l'utilisateur à saisir un nom d'utilisateur et une phrase de passe pour générer et stocker de nouvelles clés.

### Messagerie :
- L'écran des chats affiche toutes les conversations actives.
- Chaque conversation montre le nom de l'autre participant, un aperçu déchiffré du dernier message, et l'horodatage du message.
- En appuyant sur une conversation, l'écran de détail du chat s'ouvre, affichant la conversation complète et permettant l'envoi de nouveaux messages. Tous les messages sont chiffrés de bout en bout.

### Gestion des contacts et du profil :
- Utilisez l'écran des contacts pour gérer vos contacts.
- L'écran des paramètres permet de modifier votre profil ou de vous déconnecter.
  - La déconnexion efface les données sensibles (comme la phrase de passe) et vous renvoie vers le flux d'authentification.

## Extension du frontend

### Ajout de nouvelles fonctionnalités :
Avec l'abstraction du dépôt en place, vous pouvez facilement ajouter de nouvelles fonctionnalités telles que des chats de groupe, des messages multimédias, ou des notifications améliorées en étendant les classes existantes et en mettant à jour l'interface.

### Amélioration de l'UI/UX :
Envisagez d'intégrer des solutions de gestion d'état (par exemple, Provider, Riverpod, Bloc) pour une architecture d'application plus évolutive, et personnalisez les composants UI pour améliorer l'apparence et l'ergonomie.

### Renforcement du chiffrement :
Les fonctions cryptographiques dans `crypto_utils.dart` peuvent être modifiées ou étendues si vous décidez de supporter des algorithmes de chiffrement supplémentaires ou des stratégies de gestion de clés.

## Résumé
Cette documentation décrit la structure et la fonctionnalité du frontend de chat sécurisé. En comprenant les rôles de chaque composant — de l'authentification et du chiffrement au stockage des données et à l'interface — le projet devient plus facile à utiliser, à maintenir et à étendre. Les développeurs peuvent s'appuyer sur ce guide pour se familiariser rapidement avec la base de code et commencer à ajouter de nouvelles fonctionnalités ou modifier celles existantes.
