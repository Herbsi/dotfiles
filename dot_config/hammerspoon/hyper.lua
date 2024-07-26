-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, nil)

-- Enter Hyper Mode when F19 (Hyper/Capslock) is pressed
local function enterHyperMode()
    hyper.triggered = false
    hyper:enter()
end

-- Leave Hyper Mode when F19 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
local function exitHyperMode()
    hyper:exit()
    if not hyper.triggered then
        hs.eventtap.keyStroke({}, "ESCAPE")
    end
end

-- Bind the Hyper key
hs.hotkey.bind({}, "F19", enterHyperMode, exitHyperMode)

-- Bind these hyper+`letter` combinations to CMD-ALT-SHIFT-CTRL-`letter` for Keyboard Maestro
local keyboardMaestorKeys = {'s'}
for _, key in pairs(keyboardMaestorKeys) do
    hyper:bind(
        {},
        key,
        function()
            hyper.triggered = true
            hs.eventtap.keyStroke({"cmd", "alt", "shift", "ctrl"}, key)
        end
    )
end

-- Bind Hyper Key Shortcuts
-- Capture
hyper:bind(
    {},
    "c",
    function()
      hyper.triggered = true
      local o, s, t, r = hs.execute("org-capture", true)
    end
)

-- Bring Emacs to the front
hyper:bind(
    {},
    "e",
    function()
        hyper.triggered = true
        hs.application.launchOrFocus("/Applications/MacPorts/EmacsMac.app")
    end
)

-- Bring iTerm to the front
hyper:bind(
    {},
    "t",
    function()
        hyper.triggered = true
        hs.application.launchOrFocus("/Applications/iTerm.app")
    end
)
