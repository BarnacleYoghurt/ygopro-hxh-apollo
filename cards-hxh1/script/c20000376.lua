--Scream
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
  --Hand activation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)
end
s.listed_series={0xf01}
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xf01)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xf01) and c:IsLevelAbove(7)
end
function s.condition2(e)
	return Duel.IsExistingMatchingCard(s.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end