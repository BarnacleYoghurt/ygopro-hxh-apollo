-- Raging Contract
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
end
s.listed_series={0xf01}
function s.filter1a(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xf01) and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_EXTRA,0,1,nil,c:GetRace(),c:GetAttribute(),e,tp,c)
end
function s.filter1b(c,rce,att,e,tp,mc)
	return c:IsSetCard(0xf01) and c:IsRace(rce) and c:IsAttribute(att) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.filter1c(c,rce,att)
	return c:IsFaceup() and c:IsSetCard(0xf01) and c:IsRace(rce) and c:IsAttribute(att)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1c(chkc,e:GetLabelObject():GetRace(),e:GetLabelObject():GetAttribute()) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabelObject(g:GetFirst())
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
    local rce=tc:GetRace()
    local att=tc:GetAttribute()
    if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
      local g=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_EXTRA,0,nil,rce,att,e,tp)
      if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        if sg:GetCount()>0 then
          Duel.BreakEffect()
          Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
          sg:GetFirst():CompleteProcedure()
        end
      end
    end
  end
end