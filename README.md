# Fiveguard Addon

This resource extends **Fiveguard** by allowing you to manage permissions, bypasses, and advanced security checks for your FiveM server.  

---

## 📑 Index
- [Installation](#-installation)
- [Main Features](#%EF%B8%8F-main-features)
  - [Permissions Management](#-permissions-management)
  - [Security Systems](#-security-systems)
  - [Bypasses & Temporary Permissions](#%EF%B8%8F-bypasses--temporary-permissions)
  - [Natives with bypass](#-natives-with-integrated-bypass)
  - [Nickname Management](#-nickname-management)
  - [Logging & Media Evidence](#-logging--media-evidence)
- [Credits](#-credits)
Test
---

## 📥 Installation
1. [Download](https://github.com/OffSey/addon/archive/refs/heads/main.zip) the script  
2. Extract and remove the `-main` suffix from the folder name  
3. Configure the `config.lua` file as needed  

---

## ⚙️ Main Features

### 🔒 Permissions Management
Supports:  
- **Ace Permissions** (FiveM native)  
- **Framework Permissions** (ESX, QBCore, QBox, vRP – also custom)  
- **txAdmin** (automatic permissions for admins)  

---

### 🚨 Security Systems
- **Heartbeat** → prevents client-side stop attempts  
- **Anti Stopper** → prevents resource stopping exploits  
- **Anti Carry** → blocks carry exploit (safe zones supported)  
- **Anti Ped Manipulation** → prevents ped manipulation  
- **Anti Safe Spawn** → safe vehicle spawn checks  
- **Anti Spawn Vehicle** → prevents unauthorized spawns (resource whitelist)  
- **Weapon Protection** → AntiGiveWeapon & AntiDistanceDamage (range check)  
- **Anti Explosions** → blocks unauthorized explosions  
- **Blacklisted Models** → prevents banned ped/animal models  

---

### 🛡️ Bypasses & Temporary Permissions
Preconfigured for:  
- **rcore_clothing**
- **lsrp_lunapark**
- **rtx_themepark**  
- **ik-jobgarage**
- **jg-advancedgarages**
- **jg-dealerships**  
- **rcore_prison**
- **wasabi_police**  

---

### 🧰 Natives with integrated bypass
- `exports["addon"]:SafeSetEntityCoords` → replaces `SetEntityCoords`
- `exports["addon"]:SafeSetEntityVisible` → replaces `SetEntityVisible`

or using the commands:
- `fgAddon help` → shows available commands  
- `fgAddon bypass-native [install/uninstall] [resourceName]`  

---

### 📜 Nickname Management
- Maximum length (default: 25)  
- Configurable allowed characters  

---

### 📡 Logging & Media Evidence
- **Discord Webhook** support (screenshots or video proofs)  
- Configurable `RecordTime` (default: 5s)  

---

## 🙌 Credits
Addon developed by **OffSey** and **Jeakels** with the support of the comunity and powered by fiveguard, the best anticheat in the market!  

- 🌐 [fiveguard.net](https://fiveguard.net)  
- 💬 [Fiveguard Discord](https://discord.gg/fiveguard)

Supporter:
- Elite Scripts
  - 🌐 [Elite Tebex](https://elitedevelopment.tebex.io/)
  - 💬 [Elite Discord](https://discord.gg/b8jpP82MqJ)
