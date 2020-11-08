--Hunter X Emitter - Leorio
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_BATTLE_START)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --No target
  local e2=Effect.CreateEffect(c)
  e2:SetRange(LOCATION_MZONE)
  e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2:SetTarget(s.target2)
  e2:SetValue(aux.tgoval)
  c:RegisterEffect(e2)
  --Indestructible
  local e3=Effect.CreateEffect(c)
  e3:SetRange(LOCATION_MZONE)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e3:SetTarget(s.target2)
  e3:SetValue(aux.indoval)
  c:RegisterEffect(e3)
end
s.listed_series={0xf01}
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
  e:SetLabelObject(a)
	return a:IsSetCard(0xf01) and a:IsFaceup()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then 
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=e:GetLabelObject()
  if c:IsRelateToEffect(e) then
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToBattle() then
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
      e1:SetValue(1)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
      tc:RegisterEffect(e1)
    end
  end
end
function s.target2(e,c)
  return c:IsFaceup() and c:IsSetCard(0xf01) and c~=e:GetHandler()
end