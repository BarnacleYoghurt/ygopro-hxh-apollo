--Jajanken
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e1 = Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function s.filter1a(c)
  return c:IsFaceup() and c:IsSetCard(0x200)
end
function s.filter1b(c)
  return c:IsFaceup() and c:IsCode(20000354)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsCanBeEffectTarget(e) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1a(chkc) end
  if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil)
  e:SetLabel(Duel.GetMatchingGroupCount(s.filter1b,tp,LOCATION_MZONE,0,nil)) --Number of Gons at activation
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetRange(LOCATION_MZONE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCondition(s.condition1_1)
    e1:SetOperation(s.operation1_1)
    e1:SetLabelObject(e)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
function s.condition1_1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return e:GetOwnerPlayer()==tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and c:GetBattleTarget() 
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
  local se=e:GetLabelObject()
  
  local sel
  if se:GetLabel()>0 then
    sel=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
  else
    sel=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
  end
  
  if sel==0 or sel==3 then
    local e1=Effect.CreateEffect(se:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetCondition(s.condition1_1_1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
    e:GetHandler():RegisterEffect(e1)
  end
  if sel==1 or sel==3 then
    local e2=Effect.CreateEffect(se:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e2:SetCondition(s.condition1_1_1)
    e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
    e:GetHandler():RegisterEffect(e2)
  end
  if sel==2 or sel==3 then
    local e2=Effect.CreateEffect(se:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DAMAGE_STEP_END)
		e2:SetCondition(s.condition1_1_3)
		e2:SetOperation(s.operation1_1_3)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
    e:GetHandler():RegisterEffect(e2)
  end
end
function s.condition1_1_1(e)
	local tc=e:GetHandler():GetBattleTarget()
  local tp=e:GetHandlerPlayer()
	return tc and tc:GetControler()==1-tp and e:GetOwnerPlayer()==tp
end
function s.condition1_1_3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsRelateToBattle() and tc:GetControler()==1-tp and e:GetOwnerPlayer()==tp
end
function s.operation1_1_3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,id)
	Duel.Destroy(tc,REASON_EFFECT)
end