--Hunter XX - Raging Emisor
local s,id=GetID()
function s.initial_effect(c)
  c:EnableReviveLimit()
	--Special Summon Condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
  --Defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e1)
  --Direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
  e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
  e3:SetValue(s.value3)
  c:RegisterEffect(e3)
	--Damage reduce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(s.condition4)
	e4:SetValue(s.value4)
	c:RegisterEffect(e4)
end
function s.condition2(e)
  return e:GetHandler():IsDefensePos()
end
function s.value3(e,c)
	return false --Idea: Force direct attack; Reality: Just prevents attacking altogether
end
function s.condition4(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 
    and (Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 or e:GetHandler():IsDefensePos()) --important to check both because another effect might allow direct defense attack on empty field
end
function s.value4(e,damp)
	if damp==1-e:GetHandlerPlayer() then
		return e:GetHandler():GetBaseAttack()
	else
		return -1
	end
end