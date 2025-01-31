local addon, bxhnz7tp5bge7wvu = ...

bxhnz7tp5bge7wvu.console = {
  debugLevel = 0,
  file = '',
  line = ''
}

local consoleFrame = CreateFrame('ScrollingMessageFrame', 'bxhnz7tp5bge7wvu_console', UIParent)

consoleFrame:SetFont('Interface\\AddOns\\bxhnz7tp5bge7wvu\\media\\Consolas.ttf', 12, "")

-- position and setup
consoleFrame:SetPoint('CENTER', UIParent)
consoleFrame:SetMaxLines(1000)
consoleFrame:SetInsertMode('BOTTOM')
consoleFrame:SetWidth(500)
consoleFrame:SetHeight(145)
consoleFrame:SetJustifyH('LEFT')
consoleFrame:SetFading(false)
consoleFrame:SetClampedToScreen(true)
consoleFrame:Hide()

-- setup background
consoleFrame.background = consoleFrame:CreateTexture('background')
consoleFrame.background:SetPoint('TOPLEFT', consoleFrame, 'TOPLEFT', -5, 5)
consoleFrame.background:SetPoint('BOTTOMRIGHT', consoleFrame, 'BOTTOMRIGHT', 5, -5)
consoleFrame.background:SetColorTexture(0, 0, 0, 0.75)

consoleFrame.background2 = consoleFrame:CreateTexture('background')
consoleFrame.background2:SetPoint('TOPLEFT', consoleFrame, 'TOPLEFT', -7, 7)
consoleFrame.background2:SetPoint('BOTTOMRIGHT', consoleFrame, 'BOTTOMRIGHT', 7, -7)
consoleFrame.background2:SetColorTexture(20/255, 20/255, 20/255, 0.4)

-- make draggable
consoleFrame:SetMovable(true)
consoleFrame:EnableMouse(true)
consoleFrame:RegisterForDrag('LeftButton')
consoleFrame:SetScript('OnDragStart', consoleFrame.StartMoving)
consoleFrame:SetScript('OnDragStop', consoleFrame.StopMovingOrSizing)

-- scrolling
consoleFrame:SetScript('OnMouseWheel', function(self, delta)
    if delta > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        else
            self:ScrollUp()
        end
    else
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        else
            self:ScrollDown()
        end
    end
end)

-- display frame
function bxhnz7tp5bge7wvu.console.set_level(level)
  level = tonumber(level) or 0
  bxhnz7tp5bge7wvu.console.debugLevel = level
  bxhnz7tp5bge7wvu.settings.store('debug_level', level)
end

function bxhnz7tp5bge7wvu.console.toggle(show)
  show = show
  bxhnz7tp5bge7wvu.settings.store('debug_show', show)
  if show then
    consoleFrame:Show()
  else
    consoleFrame:Hide()
  end
end

local function join(...)
    local ret = ''
    for n = 1, select('#', ...) do
        ret = ret .. ', ' .. tostring(select(n, ...))
    end
    return ret:sub(3)
end

local colorize = bxhnz7tp5bge7wvu.interface.colorize

local last = false
function bxhnz7tp5bge7wvu.console.log_time(str)
  local at = date('%H:%M:%S', time())
  local joined = string.format('%s %s', at, str)
  if last ~= joined then
    bxhnz7tp5bge7wvu.console.log(joined)
    last = joined
  end
end

function bxhnz7tp5bge7wvu.console.log(...)
    consoleFrame:AddMessage(...)
end

function bxhnz7tp5bge7wvu.console.notice(...)
  bxhnz7tp5bge7wvu.console.log(date('%H:%M:%S', time())..'|cff91FF00[notice]|r ' .. join(...))
end

function bxhnz7tp5bge7wvu.console.debug(level, section, color, ...)
  if bxhnz7tp5bge7wvu.console.debugLevel >= level then
    bxhnz7tp5bge7wvu.console.log_time(
      string.format(
        '%s %s',
        colorize(color, '[' .. section .. ']'),
        join(...)
      )
    )
  end
end

function bxhnz7tp5bge7wvu.log(string, ...)
  local formatted = string.format(string, ...)
  print('|cff' .. bxhnz7tp5bge7wvu.color .. '[bxhnz7tp5bge7wvu]|r ' .. formatted)
end

function bxhnz7tp5bge7wvu.error(...)
  print('|cff' .. bxhnz7tp5bge7wvu.color .. '[bxhnz7tp5bge7wvu]|r |cffc32425' .. join(...) .. '|r')
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function bxhnz7tp5bge7wvu.format(value)
  if tonumber(value) then
    return round(value, 2)
  else
    return tostring(value)
  end
end

bxhnz7tp5bge7wvu.on_ready(function()
  local debug_level = bxhnz7tp5bge7wvu.settings.fetch('debug_level', nil)
  bxhnz7tp5bge7wvu.console.set_level(debug_level)
  local toggle = bxhnz7tp5bge7wvu.settings.fetch('debug_show', false)
  bxhnz7tp5bge7wvu.console.toggle(toggle)
end)
