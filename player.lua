local gameMod = require('game')
local M = {}

local player = {}
-------------------------------------------
-- Local functions
-------------------------------------------

-------------------------------------------
-- Global functions
-------------------------------------------
function M.init()
    player.x = 300
    player.y = 450
    player.width = 10
    player.height = 10
    player.collisions = 0
    player.kills = 0

    -- Base life on difficulty
    if gameMod.difficulty() == "EASY" then
        player.life = 100
    elseif gameMod.difficulty() == "MEDIUM" then
        player.life = 30
    else
        player.life = 10
    end
    -- Base speed on godmode
    if gameMod.godMode() then
        player.speed = 6
    else
        player.speed = 3
    end
end

function M.printData()
    love.graphics.print("Health: "..player.life, 10, 25)
    love.graphics.print("Kills: "..player.kills, 10, 40)
end

function M.life()
    return player.life
end

function M.collisions()
    return player.collisions
end

function M.speed()
    return player.speed
end

function M.setSpeed(s)
    player.speed = s
end

function M.position()
    return player.x, player.y
end

function M.dimensions()
    return player.width, player.height
end

function M.registerKill(c)
    player.kills = player.kills + c
end

function M.registerCollision(c)
    player.collisions = player.collisions + c
end

function M.registerDamage(c)
    player.life = player.life + c
end

function M.move(dx, dy)
    player.x = player.x + (player.speed * dx)
    player.y = player.y + (player.speed * dy)
end

function M.setDimension(w, h)
    player.w = w
    player.h = h
end

function M.draw()
    if player.collisions == 0 then
        love.graphics.setColor(0, 0, 255, 255)
    elseif player.collisions == 1 then
        love.graphics.setColor(255, 255, 0, 255)
    else
        love.graphics.setColor(255, 0, 0, 255)
    end
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end

function M.testCollision(badGuy)
    if player.y <= badGuy.y + badGuy.height and player.y >= badGuy.y then
        if player.x >= badGuy.x and player.x <= badGuy.x + badGuy.width then
            return true
        end
    end
    return false
end

return M
