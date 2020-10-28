--Hunter X Enhancer - Gon
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1a=Effect.CreateEffect(c)
  e1a:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1a:SetDescription(aux.Stringid(id,0))
  e1a:SetRange(LOCATION_HAND)
  e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1a:SetCode(EVENT_SUMMON_SUCCESS)
  e1a:SetCondition(s.condition1)
  e1a:SetTarget(s.target1)
  e1a:SetOperation(s.operation1)
  e1a:SetCountLimit(1,id)
  c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e1b)
  --Gain ATK/DEF
  local e2a=Effect.CreateEffect(c)
  e2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2a:SetRange(LOCATION_MZONE)
  e2a:SetType(EFFECT_TYPE_SINGLE)
  e2a:SetCode(EFFECT_UPDATE_ATTACK)
  e2a:SetValue(s.value2)
  c:RegisterEffect(e2a)
  local e2b=e2a:Clone()
  e2b:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2b)
end
s.listed_series={0xf01}
function s.filter1(c,sp)
  return c:GetSummonPlayer()==sp
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter1,1,nil,1-tp)
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
function s.filter2(c)
  return c:IsFaceup() and c:IsSetCard(0xf01)
end
function s.value2(e,c)
  return Duel.GetMatchingGroupCount(s.filter2,c:GetControler(),LOCATION_MZONE,0,nil)*500
end