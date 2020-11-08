--Crazy Slots
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_DICE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
end
s.roll_dice=true
s.listed_series={0xf01}
function s.filter1(c)
  return c:IsSetCard(0xf01) and c:IsType(TYPE_MONSTER)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(1-tp,1)
  local gc=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
  if dc>gc then
    Duel.Draw(tp,dc-gc,REASON_EFFECT)
  elseif gc>dc then
    Duel.DiscardHand(tp,aux.TRUE,gc-dc,gc-dc,REASON_EFFECT+REASON_DISCARD,nil)
  end
end