local addOnName, AddOn = ...
RecommendedSpellCaster = RecommendedSpellCaster or {}

function RecommendedSpellCaster.castRecommendedSpell()
  local ability = RecommendedSpellCaster.retrieveNextAbility()
  if RecommendedSpellCaster.isItem(ability) then
    RecommendedSpellCaster.castItem(ability)
  else
    AddOn.castSpell(ability)
  end
end

function RecommendedSpellCaster.isItem(ability)
  return ability.link ~= nil
end

function RecommendedSpellCaster.castItem(ability)
  local slotIDs = {
    INVSLOT_TRINKET1,
    INVSLOT_TRINKET2,
    INVSLOT_FINGER1,
    INVSLOT_FINGER2,
    INVSLOT_MAINHAND,
    INVSLOT_NECK
  }
  local abilityItemID = GetItemInfoInstant(ability.link)
  for _, slotID in ipairs(slotIDs) do
    local itemID = GetInventoryItemID('player', slotID)
    if itemID == abilityItemID then
      AddOn.useInventoryItem(slotID)
      break
    end
  end
end

function RecommendedSpellCaster.retrieveNextAbility()
  return Hekili_Primary_B1.Ability
end

function AddOn.castSpell(ability)
  if AddOn.isHWTPresent() then
    CastSpellByName(ability.name)
  elseif AddOn.isGMRPresent() then
    GMR.CastSpellByName(ability.name)
  elseif AddOn.isNoNamePresent() then
    Unlock('CastSpellByName', ability.name)
  else
    error('No supported unlocker found.')
  end
end

function RecommendedSpellCaster.canBeCasted(spellId)
  return (
    IsUsableSpell(spellId) and
      GetSpellCooldown(spellId) == 0
  )
end

function AddOn.useInventoryItem(slotID)
  if AddOn.isHWTPresent() or AddOn.isGMRPresent() then
    UseInventoryItem(slotID)
  elseif AddOn.isNoNamePresent() then
    Unlock('UseInventoryItem', slotID)
  else
    error('No supported unlocker found.')
  end
end

function AddOn.isHWTPresent()
  return _G.HWT ~= nil
end

function AddOn.isGMRPresent()
  return _G.GMR ~= nil
end

function AddOn.isNoNamePresent()
  -- NoName unlocker
  return _G.Unlock ~= nil
end
