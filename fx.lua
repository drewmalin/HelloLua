local M = {}

local bullets = {}
local explosions = {}

local function explode(e)
    for _, v in pairs(e.bits) do
        v.x = v.x + (v.dirx * v.speed)
        v.y = v.y + (v.diry * v.speed)
    end
end

local function drawExplosion(e)
    for _, v in pairs(e.bits) do
        love.graphics.rectangle("fill", v.x, v.y, 2, 2)
    end
end

function M.fireBullet(x, y)
    local bullet = {}
    bullet.x = x
    bullet.y = y
    bullet.width = 2
    bullet.height = 4
    bullet.speed = 5
    table.insert(bullets, bullet)
end

function M.updateBullets()
    for i, v in pairs(bullets) do
        if v.y > 0 then
            v.y = v.y - v.speed
        else
            table.remove(bullets, i)
        end
    end
end

function M.testBulletCollision(v)
    for i, bullet in pairs(bullets) do
        if bullet.y <= v.y + v.height and bullet.y >= v.y then
            if bullet.x >= v.x and bullet.x <= v.x + v.width then
                table.remove(bullets, i)
                return true
            end
        end
    end
    return false
end

function M.drawBullets()
    love.graphics.setColor(0, 255, 0, 255)
    for _, v in pairs(bullets) do
        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    end
end

function M.explosion(x, y)
    local explosion = {}
    explosion.x = x
    explosion.y = y
    explosion.time = math.random(10, 15)
    explosion.bits = {}
    for i = 1, 20, 1 do
        local bit = {}
        bit.dirx = math.random(3) - 2
        bit.diry = math.random(3) - 2
        bit.x = x
        bit.y = y
        bit.speed = math.random(3)
        table.insert(explosion.bits, bit)
    end
    table.insert(explosions, explosion)
end

function M.updateExplosions()
    for i, v in pairs(explosions) do
        v.time = v.time - 1
        if v.time == 0 then
            table.remove(explosions, i)
        else
            explode(v)
        end
    end
end

function M.drawExplosions()
    love.graphics.setColor(255, 0, 0, 255)
    for _, v in pairs(explosions) do
        drawExplosion(v)
    end
end

return M
