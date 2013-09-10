local gameMod   = require('game')
local playerMod = require('player')
local fxMod     = require('fx')
local M = {}

local badGuys = {}
local spawnDelay = 2
----------------------------------------
-- Local functions
----------------------------------------
local function generateBadGuy(startX)
    local badGuy = {}
    badGuy.x = startX
    badGuy.y = 1
    badGuy.width = 20
    badGuy.height = 10
    badGuy.life = 3
    badGuy.dir = math.random(2) % 2 == 0 and 1 or -1
    table.insert(badGuys, badGuy)
end

----------------------------------------
-- Global functions
----------------------------------------
function M.init()
    if gameMod.difficulty() == "EASY" then
        spawnDelay = 2
    elseif gameMod.difficulty() == "MEDIUM" then
        spawnDelay = 1
    else
        spawnDelay = .25
    end
end

function M.temporary()
    return spawnDelay
end

local function spawn(time)
    if time >= spawnDelay then
        generateBadGuy(math.random(800))
        return true
    else
        return false
    end
end

local function updateMovement()
    local moveX = 0
    if gameMod.difficulty() == "MEDIUM" then
        moveX = 50
    elseif gameMod.difficulty() == "HARD" then
        moveX = 20
    end
    for i, v in pairs(badGuys) do
        if v.life <= 0 then
            playerMod.registerKill(1)
            table.remove(badGuys, i)
            fxMod.explosion(v.x, v.y)
        elseif v.y > 600 then
            playerMod.registerDamage(-1)
            table.remove(badGuys, i)
        elseif playerMod.testCollision(v) then
            playerMod.registerCollision(1)
            table.remove(badGuys, i)
            fxMod.explosion(v.x, v.y)
        else
            v.y = v.y + 2
        end
        if moveX == 0 then
            v.dir = 0
        elseif math.random(moveX) % moveX == 0 then
            v.dir = -1 * v.dir
        end
        v.x = v.x + v.dir
    end
end

local function testBulletCollision()
    for _, v in pairs(badGuys) do
        if fxMod.testBulletCollision(v) then
            v.life = v.life - 1
        end
    end
end

function M.update(dt)
    updateMovement()
    testBulletCollision()
    return spawn(dt)
end

function M.kill(idx)
    table.remove(badGuys, idx)
end

function M.draw()
    for _, v in pairs(badGuys) do
        if v.life == 3 then
            love.graphics.setColor(10, 200, 10, 255)
        elseif v.life == 2 then
            love.graphics.setColor(100, 10, 100, 255)
        else
            love.graphics.setColor(100, 10, 10, 255)
        end
        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    end
end

return M 
