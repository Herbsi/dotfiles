require "hyper"

-- Keybindings for German Quotes
-- Opening Double Quote
hs.hotkey.bind({"ctrl", "shift"}, '[', function() hs.eventtap.keyStrokes("„") end, nil, nil)

-- Opening Single Quote
hs.hotkey.bind({"ctrl", "shift"}, ']', function() hs.eventtap.keyStrokes("‚") end, nil, nil)
