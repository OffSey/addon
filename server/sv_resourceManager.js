const fs = require("fs");
const path = require("path");

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

function manifestHasACFG(manifest) {
  if (!manifest) return false;
  return manifest.includes("ac 'fg'");
}

function manifesthasOffSey(manifest) {
  if (!manifest) return false;
  return manifest.includes("author 'Offsey & Jeakels discord.gg/fiveguard'");
}

function escapeRegExp(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function getAllResources() {
  const count = GetNumResources();
  const out = [];
  for (let i = 0; i < count; i++) {
    const name = GetResourceByFindIndex(i);
    if (name) out.push(name);
  }
  return out;
}

function installInResource(targetResource, currentResource) {
  const manifest = readManifest(targetResource);
  if (manifest === null) {
    return { changed: false, skippedReason: "no fxmanifest.lua" };
  }
  if (manifestHasACFG(manifest)) {
    return { changed: false, skippedReason: "fiveguard ressource" };
  }
  if (manifesthasOffSey(manifest)) {
    return { changed: false, skippedReason: "addon ressource"}
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
    "m"
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

function printHelp() {
  console.log('fiveguard documentation: https://docs.fiveguard.net')
  console.log("FIVEGUARD ADDON COMMANDS");
  console.log("         fgAddon help");
  console.log("         fgAddon bypass-native [uninstall/install] [optional > resourceName]");
}

RegisterCommand("fgAddon", async (source, args, raw) => {
    if (source !== 0) {
      return;
    }
    const currentResource = GetCurrentResourceName();
    const [sub, action, maybeTarget] = args;
    if (!sub) {
      log(
        "Specified command does not exists, use command fgAddon help to get more information"
      );
      return;
    }
    if (sub === "help") {
      printHelp();
      return;
    }
    if (sub !== "bypass-native" || !action) {
      log(
        "Specified command does not exists, use command fgAddon help to get more information"
      );
      return;
    }
    let targets = [];
    if (maybeTarget) {
      targets = [maybeTarget];
    } else {
      targets = getAllResources();
    }
    let changedCount = 0;
    let skippedCount = 0;
    if (action === "install") {
      for (const res of targets) {
        const { changed } = installInResource(res, currentResource);
        if (changed) {
          log(`Installed bypassNative.lua to ${res} successfully.`);
          changedCount++;
        } else {
          skippedCount++;
        }
        await sleep(Math.floor(Math.random() * (50 - 25 + 1)) + 25);
      }
      log(
        `Installed Bypass Native to (${changedCount}), ${skippedCount} skipped (already installed, failed installing or resources shouldn't have the installation file)`
      );
      console.log("\x1b[31mRestart Server\x1b[0m");
      return;
    }
    if (action === "uninstall") {
      for (const res of targets) {
        const { changed } = uninstallInResource(res, currentResource);
        if (changed) {
          log(`Removed bypassNative.lua reference from ${res}.`);
          changedCount++;
        } else {
          skippedCount++;
        }
      }
      log(`Uninstalled Bypass Native from (${changedCount}), ${skippedCount} skipped.`);
      console.log("\x1b[31mRestart Server\x1b[0m");
      return;
    }
    log(
      "Specified command does not exists, use command fgAddon help to get more information"
    );
  },true);
