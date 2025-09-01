const fs = require("fs");
const path = require("path");
let FiveguardName = null;
let imBusy = false;
const log = (...args) => console.log("[fiveguard addon]", ...args);

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function readManifest(resourceName) {
  try {
    const resourcePath = GetResourcePath(resourceName);
    if (!resourcePath) return null;
    const filePath = path.join(resourcePath, "fxmanifest.lua");
    if (!fs.existsSync(filePath)) return null;
    return fs.readFileSync(filePath, "utf8");
  } catch (e) {
    return null;
  }
}

function saveManifest(resourceName, content) {
  try {
    const resourcePath = GetResourcePath(resourceName);
    if (!resourcePath) return false;
    const filePath = path.join(resourcePath, "fxmanifest.lua");
    fs.writeFileSync(filePath, content, "utf8");
    return true;
  } catch (e) {
    return false;
  }
}

function manifestHasBypassLine(manifest, currentResource) {
  if (!manifest) return false;
  const pattern = new RegExp(
    String.raw`^\s*shared_script\s+["']@${escapeRegExp(currentResource)}\/bypassNative\.lua["']\s*$`,
    "m"
  );
  return pattern.test(manifest);
}

function escapeRegExp(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function readBans(resourceName) {
  try {
    const resourcePath = GetResourcePath(resourceName);
    if (!resourcePath) return null;
    const filePath = path.join(resourcePath, "bans.json");
    if (!fs.existsSync(filePath)) return null;
    const content = fs.readFileSync(filePath, "utf8");
    try { return JSON.parse(content); }
    catch (e) { log("bans.json parse error:", e.message); return null; }
  } catch (e) {
    return null;
  }
}

function getAllResources() {
  const count = GetNumResources();
  const out = [];
  for (let i = 0; i < count; i++) {
    const name = GetResourceByFindIndex(i);
    if (name) {
      out.push(name);
      if (FiveguardName === null) {
        const ac = GetResourceMetadata(name, "ac");
        if (ac === "fg") { FiveguardName = name; }
      }
    }
  }
  return out;
}

function installInResource(targetResource, currentResource) {
  const manifest = readManifest(targetResource);
  if (manifest === null) {
    return { changed: false, skippedReason: "no fxmanifest.lua" };
  }
  if (/\bac\s*['"]fg['"]/.test(manifest)) {
    return { changed: false, skippedReason: "fiveguard resource", ignoreMe: true };
  }
  if (manifest.includes("author 'Offsey & Jeakels discord.gg/fiveguard'")) {
    return { changed: false, skippedReason: "addon resource", ignoreMe: true }
  }
  if (manifestHasBypassLine(manifest, currentResource)) {
    return { changed: false, skippedReason: "already installed" };
  }
  const insertion = `shared_script "@${currentResource}/bypassNative.lua"\n`;
  let newContent;
  if (manifest.startsWith("\uFEFF")) {
    newContent = "\uFEFF" + insertion + manifest.slice(1);
  } else {
    newContent = insertion + manifest;
  }
  const ok = saveManifest(targetResource, newContent);
  if (!ok) {
    return { changed: false, skippedReason: "failed to write" };
  }
  return { changed: true };
}

function uninstallInResource(targetResource, currentResource) {
  const manifest = readManifest(targetResource);
  if (manifest === null) {
    return { changed: false, skippedReason: "no fxmanifest.lua" };
  }
  const lineRegex = new RegExp(
    String.raw`^\s*shared_script\s+["']@${escapeRegExp(currentResource)}\/bypassNative\.lua["']\s*\r?\n?`,
    "mg"
  );
  if (!lineRegex.test(manifest)) {
    return { changed: false, skippedReason: "not installed" };
  }
  const newContent = manifest.replace(lineRegex, "");
  const ok = saveManifest(targetResource, newContent);
  if (!ok) {
    return { changed: false, skippedReason: "failed to write" };
  }
  return { changed: true };
}

RegisterCommand("fgAddon", async (source, args, raw) => {
  if (source !== 0) return;
  if (imBusy) { log("Command already running, please wait..."); return; }
  imBusy = true;
  try {
    const currentResource = GetCurrentResourceName();
    switch (args[0]) {
      case "help": {
        console.log('fiveguard documentation: https://docs.fiveguard.net')
        console.log("FIVEGUARD ADDON COMMANDS");
        console.log("         fgAddon help");
        console.log("         fgAddon unban <all/range> [range: <minId> <maxId>]");
        console.log("         fgAddon bypass-native <uninstall/install> [optional: resourceName]");
        break;
      }
      case "bypass-native": {
        let targets = [];
        if (args[2]) {
          targets = [args[2]];
        } else {
          targets = getAllResources();
        }
        let changedCount = 0;
        let skippedCount = 0;
        switch (args[1]) {
          case "install":
            for (const res of targets) {
              const { changed, skippedReason, ignoreMe } = installInResource(res, currentResource);
              if (changed) {
                log(`Installed bypassNative.lua to ${res} successfully.`);
                changedCount++;
              } else {
                if (!ignoreMe) {
                  log(`Can not install bypassNative.lua to ${res} Reason: ${skippedReason}.`);
                  skippedCount++;
                }
              }
              await sleep(Math.floor(Math.random() * (50 - 25 + 1)) + 25);
            }
            log(`Installed Bypass Native to (${changedCount}), ${skippedCount} skipped (already installed, failed installing or resources shouldn't have the installation file)`);
            console.log("\x1b[31mRestart Server\x1b[0m");
            break;
          case "uninstall":
            for (const res of targets) {
              const { changed } = uninstallInResource(res, currentResource);
              if (changed) {
                log(`Removed bypassNative.lua reference from ${res}.`);
                changedCount++;
              } else { skippedCount++; }
              await sleep(Math.floor(Math.random() * (50 - 25 + 1)) + 25);
            }
            if (skippedCount > 1) { skippedCount = skippedCount - 2 }
            log(`Uninstalled Bypass Native from (${changedCount}), ${skippedCount} skipped.`);
            console.log("\x1b[31mRestart Server\x1b[0m");
            break;
          default:
            log("Specified subcommand does not exist, use fgAddon install or fgAddon uninstall");
        }
        break;
      }
      case "unban": {
        if (FiveguardName === null) getAllResources();
        if (FiveguardName === null) { console.log("Fiveguard resource not found"); return; }
        const bans = readBans(FiveguardName);
        if (!bans) {
          console.log("No bans found!");
          return;
        }
        switch (args[1]) {
          case "all": {
            let executed = 0;
            for (const banId in bans) {
              if (Number.isInteger(Number(banId))) {
                ExecuteCommand(`fg unban ${banId}`);
                executed++;
              }
            }
            console.log(`Successfully unbanned all users (${executed})`);
            break;
          }
          case "range": {
            if (args.length < 4) {
              console.log("Usage: fgAddon unban range <minId> <maxId>");
              return;
            }

            const a = Number(args[2]);
            const b = Number(args[3]);
            if (!Number.isFinite(a) || !Number.isFinite(b)) {
              console.log("Invalid range. Use integers: fgAddon unban range <minId> <maxId>");
              return;
            }

            const min = Math.min(a, b);
            const max = Math.max(a, b);

            let executed = 0;
            for (const key in bans) {
              const id = Number(key);
              if (Number.isInteger(id) && id >= min && id <= max) {
                ExecuteCommand(`fg unban ${id}`);
                executed++;
              }
            }
            console.log(`Successfully unbanned ${executed} users`);
            break;
          }
          default:
            log("Specified command does not exists, use command fgAddon help to get more information");
            break;
        }
        break;
      }
      default:
        log("Specified command does not exists, use command fgAddon help to get more information");
        break;
    }
  } finally {
    imBusy = false;
  }
}, true);
