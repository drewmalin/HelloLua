local M = {}

local moon = {}
local nearStars = {}
local farStars = {}

-------------------------------------------------------
-- Local functions
-------------------------------------------------------
local function generateStars(count)
    for i = 1, count, 1 do
        local star = {}
        star.x = math.random(800)
        star.y = math.random(1200) - 600
        star.r = math.random(3)
        table.insert(nearStars, star)
    end
    for i = 1, count * 2, 1 do
        local star = {}
        star.x = math.random(800)
        star.y = math.random(1200) - 600
        star.r = math.random(2)
        table.insert(farStars, star)
    end
end

local function drawStars()
    love.graphics.setColor(255, 255, 204, 255)
    for _, v in pairs(nearStars) do
        love.graphics.circle("fill", v.x, v.y, v.r, 100)
    end
    for _, v in pairs(farStars) do
        love.graphics.circle("fill", v.x, v.y, v.r, 100)
    end
end

local function drawMoon()
    local x = moon.x
    local y = moon.y
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.circle("fill", 300+x, 300+y, 50, 100)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.circle("fill", 311+x, 321+y, 16, 100)
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.circle("fill", 310+x, 320+y, 15, 100)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.circle("fill", 301+x, 276+y, 11, 100)
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.circle("fill", 300+x, 275+y, 10, 100)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.circle("fill", 266+x, 286+y, 9, 100)
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.circle("fill", 265+x, 285+y, 8, 100)
end

------------------------------------------------------
-- Global functions
------------------------------------------------------
function M.init(starCount)
    moon.x = 0
    moon.y = 0
    generateStars(starCount)
end

function M.update(x, y)
    moon.x = moon.x - (x * .25)
    moon.y = moon.y - (y * .25)
    for _, v in pairs(nearStars) do
        v.x = v.x - (x * .1)
        v.y = v.y - (y * .1)
    end
    for _, v in pairs(farStars) do
        v.x = v.x - (x * .015)
        v.y = v.y - (y * .015)
    end
end

function M.draw()
    drawStars()
    drawMoon()
end

return M    -- Return the 'module'
