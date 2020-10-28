--Hunter X Conjurator - Scythe Dancer
local s,id=GetID()
function s.initial_effect(c)
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xf01),2)
	c:EnableReviveLimit()
  --Roll
  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
  --Search
  local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
s.roll_dice=true
function s.filter1(c)
  local function IsSeriesListed(c,...)
    if not c.listed_series then return false end
    local setcodes={...}
    for _,setcode in ipairs(setcodes) do
      for _,lsetcode in ipairs(c.listed_series) do
        if setcode==lsetcode then return true end
      end
    end
    return false
  end
  
	return ((c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf01)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and IsSeriesListed(c,0xf01))) and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	local g=Duel.GetDecktopGroup(tp,dc)
	Duel.ConfirmCards(tp,g)
  if g:IsExists(s.filter1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:FilterSelect(tp,s.filter1,1,1,nil,e,tp)
    Duel.DisableShuffleCheck()
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
    Duel.ShuffleHand(tp)
    Duel.SortDecktop(tp,tp,dc-1)
  else 
    Duel.SortDecktop(tp,tp,dc) 
  end
end

function s.filter2(c)
	return c:IsCode(20000367) and c:IsAbleToHand()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end