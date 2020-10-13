--Hunter X Manipulator - Shoot
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_DAMAGE)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Equip (very WIP)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 1))
  e2:SetCategory(CATEGORY_EQUIP)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
  --Negate
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_DISABLE)
  e3:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
  e3:SetTarget(s.target3) --TODO: Only activated effects
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
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetBattleTarget() and eg:IsContains(e:GetHandler():GetBattleTarget())
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=e:GetHandler():GetBattleTarget()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=e:GetHandler():GetBattleTarget()
  if c:IsRelateToEffect(e) and tc then
    Duel.Equip(tp,c,tc)
  end
end
function s.target3(e,c)
  return e:GetHandler():GetEquipGroup():IsExists(Card.IsType,1,nil,c:GetType())
end
