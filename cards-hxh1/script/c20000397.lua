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
  --Direct attack (by making opponent's monsters transparent so it's forced)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(0,LOCATION_MZONE)
  e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
  e2:SetCondition(s.condition2)
  c:RegisterEffect(e2)
	--Damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(s.condition3)
	e3:SetValue(s.value3)
	c:RegisterEffect(e3)
  --No target
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e4:SetTarget(s.target4)
  e4:SetValue(aux.tgoval)
  c:RegisterEffect(e4)
  --Indestructible
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD)
  e5:SetRange(LOCATION_MZONE)
  e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e5:SetTarget(s.target4)
  e5:SetValue(aux.indoval)
  c:RegisterEffect(e5)
  --Indestructible once
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf01))
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
s.listed_series={0xf01}
s.listed_names={20000367}
function s.condition2(e)
  return Duel.GetAttacker()==e:GetHandler() and e:GetHandler():IsDefensePos()
end
function s.condition3(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 
    and (Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 or e:GetHandler():IsDefensePos()) --important to check both because another effect might allow direct defense attack on empty field
end
function s.value3(e,damp)
	if damp==1-e:GetHandlerPlayer() then
		return e:GetHandler():GetBaseAttack()
	else
		return -1
	end
end
function s.target4(e,c)
  return c:IsFaceup() and c:IsSetCard(0xf01) and c~=e:GetHandler()
end