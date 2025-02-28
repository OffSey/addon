SVConfig = {}
------------ ANTI CARRY WEBHOOK ------------
SVConfig.WebhookURLAntiCarry = "https://discord.com/api/webhooks/URL" -- | Not useful if "Config.RecordPlayer" is false| FOR ANTI CARRY

------------ ANTI MODEL DETECTOR ------------
-- AutoCheck
SVConfig.ModelCheck = 10000  -- 10 seconds
-- Test mode
SVConfig.TestMode = false  -- Set to true for testing without banning players
-- languages
SVConfig.Messages = {
    en = "Forbidden model detected: ",
    ko = "금지된 모델이 감지되었습니다: ",
    fr = "Modèle interdit détecté: ",
    de = "Verbotenes Modell entdeckt: ",
    es = "Modelo prohibido detectado: ",
    ru = "Обнаружена запрещенная модель: ",
    zh = "检测到禁用模型: ",
    jp = "禁止されたモデルが検出されました: ",
    it = "Modello proibito rilevato: ",
    pt = "Modelo proibido detectado: ", 
    pl = "Wykryto model z blacklisty: ",
}
-- Default language
SVConfig.Language = "en"
-- List of models
SVConfig.ForbiddenModels = {
    "a_c_fish",
    "a_c_chickenhawk",
    "a_c_rat"
}
