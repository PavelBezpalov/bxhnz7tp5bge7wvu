local addon, bxhnz7tp5bge7wvu = ...

function C_Timer.NewAdvancedTicker(duration, callback, iterations)
  local ticker = setmetatable({}, TickerMetatable);
  ticker._duration = duration;
  ticker._remainingIterations = iterations;
  ticker._callback = function()
    if ( not ticker._cancelled ) then
      callback(ticker);

      --Make sure we weren't cancelled during the callback
      if ( not ticker._cancelled ) then
        if ( ticker._remainingIterations ) then
          ticker._remainingIterations = ticker._remainingIterations - 1;
        end
        if ( not ticker._remainingIterations or ticker._remainingIterations > 0 ) then
          C_Timer.After(ticker._duration, ticker._callback);
        end
      end
    end
  end;

  C_Timer.After(ticker._duration, ticker._callback);
  return ticker;
end

local function hide_block(...)
  StaticPopup1:Hide()
end

bxhnz7tp5bge7wvu.event.register("MACRO_ACTION_FORBIDDEN", hide_block)
bxhnz7tp5bge7wvu.event.register("ADDON_ACTION_FORBIDDEN", hide_block)
bxhnz7tp5bge7wvu.event.register("ADDON_ACTION_BLOCKED", hide_block)
