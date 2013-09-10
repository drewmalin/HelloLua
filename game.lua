local M = {}

local difficulty = "EASY"
local godMode = false
local paused = false
local gameOver = false
local timeElapsed = 0
---------------------------------------
-- Local functions
---------------------------------------

---------------------------------------
-- Global functions
---------------------------------------
function M.setDifficulty(diff)
    difficulty = diff
end

function M.setGodMode(gm)
    godMode = gm
end

function M.setPaused(p)
    paused = p
end

function M.setGameOver(go)
    gameOver = go
end

function M.incTimeElapsed(dt)
    timeElapsed = timeElapsed + dt
end

function M.resetTimeElapsed()
    timeElapsed = 0
end

function M.difficulty()
    return difficulty
end

function M.godMode()
    return godMode
end

function M.paused()
    return paused
end

function M.gameOver()
    return gameOver
end

function M.timeElapsed()
    return timeElapsed
end

return M
