--Hunter XX - Scarlet Eyes Specialist
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
  --LIGHT
  local e1=Effect.CreateEffect(c)
  e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetCondition(s.condition1)
	c:RegisterEffect(e1)
  --DARK
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BATTLE_START)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
  --EARTH
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e3:SetCondition(s.condition3)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  --WATER
  local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
  e4:SetDescription(aux.Stringid(id,1))
  e4:SetRange(LOCATION_MZONE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(s.condition4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
  e4:SetCountLimit(1)
	c:RegisterEffect(e4)
  --FIRE
  local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
  e5:SetDescription(aux.Stringid(id,2))
  e5:SetRange(LOCATION_MZONE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(s.condition5)
	e5:SetTarget(s.target5)
	e5:SetOperation(s.operation5)
  e5:SetCountLimit(1)
	c:RegisterEffect(e5)
  --WIND
  local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e6:SetRange(LOCATION_MZONE)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetTargetRange(0,1)
	e6:SetCondition(s.condition6)
	e6:SetTarget(s.target6)
	e6:SetCost(s.costchk6)
	e6:SetOperation(s.operation6)
	c:RegisterEffect(e6)
end
function s.filter(c,attr)
  return c:IsFaceup() and c:IsAttribute(attr)
end
function s.condition1(e)
  return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_LIGHT)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_DARK) then return false end
  
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil and d:IsControler(1-tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
function s.condition3(e)
  return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_EARTH)
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
	end
end
function s.condition5(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE)
end
function s.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.operation5(e,tp,eg,ep,ev,re,r,rp)
  Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function s.condition6(e)
  return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WIND)
end
function s.target6(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL)
end
function s.costchk6(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function s.operation6(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end