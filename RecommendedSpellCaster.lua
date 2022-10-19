local AddOn = {}

function castRecommendedSpell()
    local ability = AddOn.retrieveNextAbility()
    if AddOn.isItem(ability) then
        AddOn.castItem(ability)
    else
        AddOn.castSpell(ability)
    end
end

function AddOn.retrieveNextAbility()
    return Hekili_Primary_B1.Ability
end

function AddOn.isItem(ability)
    return ability.link ~= nil
end

function AddOn.castItem(ability)
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
            UseInventoryItem(slotID)
            break
        end
    end
end

function AddOn.castSpell(ability)
    if _G.GMR then
        GMR.CastSpellByName(ability.name)
    else
        -- NoName unlocker
        Unlock('CastSpellByName', ability.name)
    end
end
