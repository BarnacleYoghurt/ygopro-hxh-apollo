--Hunter X Manipulator - Morel
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_HAND)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Token
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetRange(LOCATION_MZONE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
  --No damage
  local e3a=Effect.CreateEffect(c)
  e3a:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3a:SetRange(LOCATION_MZONE)
  e3a:SetType(EFFECT_TYPE_FIELD)
  e3a:SetCode(EFFECT_CHANGE_DAMAGE)
  e3a:SetTargetRange(1,0)
  e3a:SetCondition(s.condition3)
  e3a:SetValue(0)
  c:RegisterEffect(e3a)
  local e3b=e3a:Clone()
  e3b:SetCode(EFFECT_NO_EFFECT_DAMAGE)
  c:RegisterEffect(e3b)
  --Destroy replace
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EFFECT_DESTROY_REPLACE)
  e4:SetTarget(s.target4)
  e4:SetOperation(s.operation4)
  c:RegisterEffect(e4)
end
function s.filter1(c,tp)
  return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0xf01) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
    and not c:IsCode(id) and not (c:IsReason(REASON_EFFECT) and Duel.GetCurrentPhase()==PHASE_DAMAGE)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter1,1,nil,tp)
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
	return Duel.GetTurnPlayer()~=tp
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,20010370,0,0x4011,1000,500,1,RACE_FAIRY,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,20010370,0,0x4011,1000,500,1,RACE_FAIRY,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,20010370)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.filter3(c)
  return c:IsFaceup() and c:IsCode(20010370)
end
function s.condition3(e)
	return Duel.IsExistingMatchingCard(s.filter3,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.filter4(c,e)
	return c:IsFaceup() and c:IsCode(20010370) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_ONFIELD,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_ONFIELD,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end