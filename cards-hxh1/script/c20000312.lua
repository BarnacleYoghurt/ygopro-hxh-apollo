--Hunter X Manipulator - Shoot
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_DAMAGE)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Equip
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_EQUIP)
  e2:SetDescription(aux.Stringid(id, 1))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCondition(aux.bdocon)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
  --Negate
  local e3=Effect.CreateEffect(c)
  e3:SetRange(LOCATION_MZONE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_CHAIN_SOLVING)
  e3:SetCondition(s.condition3)
  e3:SetOperation(s.operation3)
  c:RegisterEffect(e3)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return ep==tp
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
  end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
  local tc=e:GetHandler():GetBattleTarget()
  Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    if Duel.Equip(tp,tc,c,false) then
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
      e1:SetCode(EFFECT_EQUIP_LIMIT)
      e1:SetValue(s.value2_1)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e1)
      tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    end
  end
end
function s.value2_1(e,c)
	return e:GetOwner()==c
end
function s.filter3(c,ec,race)
  return c:GetFlagEffect(id)~=0 and c:GetEquipTarget()==ec and c:IsRace(race)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return not c:IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_SZONE,0,1,nil,c,re:GetHandler():GetRace())
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateEffect(ev)
end