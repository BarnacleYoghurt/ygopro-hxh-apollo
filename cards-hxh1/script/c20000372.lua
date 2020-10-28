--Hunter X Conjurator - Knov
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetRange(LOCATION_HAND)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_TO_HAND)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Banish/Draw
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
s.listed_series={0xf01}
function s.filter1(c,tp)
  return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.filter1,1,nil,tp)
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
	return c:IsFaceup() and c:IsSetCard(0xf01) and c:IsAbleToRemove()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCanBeEffectTarget(e) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
  Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and tc:IsLocation(LOCATION_REMOVED) then
    local ct=(Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY) and 2 or 1
		local val=(Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY) and Duel.GetTurnCount() or (Duel.GetTurnCount()-1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(s.condition2_1)
		e1:SetOperation(s.operation2_1)
		e1:SetLabel(val)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,ct)
		Duel.RegisterEffect(e1,tp)
		tc:CreateEffectRelation(e1)
		
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
	end
end
function s.condition2_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetLabel() then return false end
	local tc=e:GetLabelObject()
	return tc:IsRelateToEffect(e)
end
function s.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end