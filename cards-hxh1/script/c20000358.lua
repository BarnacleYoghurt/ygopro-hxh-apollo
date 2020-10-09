--Nen Training
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetRange(LOCATION_SZONE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
end
function s.filter1a(c,e,tp,rp)
  return c:IsPreviousSetCard(0x200) and c:IsType(TYPE_MONSTER)
    and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
    and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
    and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
    and c:GetOriginalLevel()>0 and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalLevel())
end
function s.filter1b(c,e,tp,lvl)
  return c:IsSetCard(0x200) and c:GetLevel()<lvl and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local pg=eg:Filter(s.filter1a,nil,e,tp,rp)
  if chkc then return pg:IsContains(chkc) end
  if chk==0 then return pg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local tg=pg:Select(pg,tp,1,1,nil)
  Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetOriginalLevel())
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end