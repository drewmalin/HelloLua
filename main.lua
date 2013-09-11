local worldMod  = require('world')
local enemyMod  = require('enemy')
local gameMod   = require('game')
local playerMod = require('player')
local fxMod     = require('fx')

gameMod.setDifficulty("EASY")   -- "EASY", "MEDIUM", or "HARD"
gameMod.setGodMode(false)        -- true or false

konamiCode = {"up", "up", "down", "down", "left", "right", "left", "right", 'b', 'a', "return"}
konamiCounter = 1

----------------------------------------------------------- 
--  Load Callback
--  Invoked at the start of the game. Place the loading of 
--  resources, initialization of variables, and setup of
--  game properties here.
-----------------------------------------------------------
function love.load()
    playerMod.init()
    worldMod.init(100)
    enemyMod.init()
end

-----------------------------------------------------------
--  Update Callback
--  Invoked continuously. Put calculations based on gametime 
--  here.
-----------------------------------------------------------
function love.update(dt)
    if gameMod.paused() or gameMod.gameOver() then
        -- do nothing
    else
        local x, y = playerMod.position()
        local w, h = playerMod.dimensions()
        local s = playerMod.speed()
        local life = playerMod.life()
        local collisions = playerMod.collisions()

        -- Fire bullets
        if gameMod.godMode() and love.keyboard.isDown(' ') then
            fxMod.fireBullet(x - 1, y)
            fxMod.fireBullet(x + w + 1, y)
            fxMod.fireBullet(x + (w / 2), y)
        end

        -- Move left/right
        if love.keyboard.isDown('a') and x > 0 then
            playerMod.move(-1, 0)
            worldMod.update(-1, 0)
        elseif love.keyboard.isDown('d') and x < 800 - w then
            playerMod.move(1, 0)
            worldMod.update(1, 0)
        end

        -- Move up/down
        if love.keyboard.isDown('s') and y < 600 - h then
            playerMod.move(0, 1)
            worldMod.update(1, 0)
        elseif love.keyboard.isDown('w') and y > 0 then
            playerMod.move(0, -1)
            worldMod.update(0, -1)
        end

        -- Perform updates based on above input
        if enemyMod.update(gameMod.timeElapsed()) then
            gameMod.resetTimeElapsed()
        else
            gameMod.incTimeElapsed(dt)
        end
        fxMod.updateBullets()
        fxMod.updateExplosions()
        worldMod.update(0, -.75)

        -- Game over!
        if life == 0 or collisions >= 3 then
            gameMod.setGameOver(true)
        end
    end
end

-----------------------------------------------------------
--  Render Callback
--  Invoked continuously. All calls to love.graphics are 
--  done here.
-----------------------------------------------------------
function love.draw()
    local fps = love.timer.getFPS()
    if gameMod.paused() then
        pause()
    elseif gameMod.gameOver() then
        renderGameOver()
    end
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("FPS: "..fps, 10, 10)
    playerMod.printData()
    worldMod.draw()
    playerMod.draw()
    enemyMod.draw()
    fxMod.drawBullets()
    fxMod.drawExplosions()
end

-----------------------------------------------------------
--  Keyboard Callbacks
-----------------------------------------------------------
function love.mousepressed(x, y, button)
    if button == 'l' then
        print('left mouse down!')
    elseif button == 'r' then
        print('right mouse down!')
    end
end

function love.mousereleased(x, y, button)
    if button == 'l' then
        print('left mouse up!')
    elseif button == 'r' then
        print('right mouse up!')
    end
end

function love.keypressed(key, unicode)
    local x, y = playerMod.position()
    local w, h = playerMod.dimensions()
    if not gameMod.paused() and not gameMod.gameOver() and key == ' ' then
        if gameMod.difficulty() == "HARD" then
            fxMod.fireBullet(x + (w / 2), y)
        elseif gameMod.difficulty() == "MEDIUM" then
            fxMod.fireBullet(x, y)
            fxMod.fireBullet(x + w, y)
        else
            fxMod.fireBullet(x - 1, y)
            fxMod.fireBullet(x + w + 1, y)
            fxMod.fireBullet(x + (w / 2), y)
        end
    elseif key == 'p' then
        gameMod.setPaused(not gameMod.paused())
    elseif key == 'escape' then
        love.event.quit()
    end
    if not gameMod.paused() and not gameMod.gameOver() and key == konamiCode[konamiCounter] then
        konamiCounter = konamiCounter + 1
        print('Konami Counter: ' .. konamiCounter)
        if konamiCounter == 12 then
            gameMod.setGodMode(true)
        end
    else
        konamiCounter = 1
    end
end

function love.keyreleased(key, unicode)
end

-- Invoked when the game window goes into and out of context
function love.focus(f)
    if not f then
        gameMod.setPaused(true)
    end
end

-- Shutdown hook
function love.quit()
    print('Bye!')
end

function pause()
    love.graphics.print("PAUSED", 80, 50, 0, 5, 5)
end

function renderGameOver()
    love.graphics.print("GAME OVER", 80, 50, 0, 5, 5)
end
