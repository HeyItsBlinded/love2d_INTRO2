--[[
    SCREEN DIMENSIONS
    * top left == 0, 0
    * top right == windowX - 65, 0
    * bottom left == 0, windowY - 65
    * bottom right == windowX - 65, windowY - 65
]]

game = {}

windowX, windowY = 1200, 900
local points = 0
player = {}
fruits = {}
local anim8 = require "anim8"

local bananaX, bananaY
local grapeX, grapeY
local orangeX, orangeY
local tomatoX, tomatoY

function game.load()
    love.window.setMode(windowX, windowY)

    -- Initialize player
    player.x = (windowX / 2) - 30
    player.y = (windowY / 2) - 50
    player.width = 60
    player.height = 90
    player.speed = 2
    player.spriteSheet = love.graphics.newImage('assets/player-sheet.png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animations = {
        down = anim8.newAnimation(player.grid('1-4', 1), 0.1),
        left = anim8.newAnimation(player.grid('1-4', 2), 0.1),
        right = anim8.newAnimation(player.grid('1-4', 3), 0.1),
        up = anim8.newAnimation(player.grid('1-4', 4), 0.1)
    }
    player.anim = player.animations.down

    -- Initialize fruitX, fruitY
    game.resetBanana()
    game.resetGrape()
    game.resetOrange()
    game.resetTomato()
end

function game.checkCollision()
    local playerLeft = player.x 
    local playerRight = player.x + player.width 
    local playerTop = player.y 
    local playerBottom = player.y + player.height 

    local bananaLeft = bananaX + 35
    local bananaRight = bananaX + 35
    local bananaTop = bananaY + 35
    local bananaBottom = bananaY + 35

    if (playerRight > bananaLeft) and (playerLeft < bananaRight) and (playerBottom > bananaTop) and (playerTop < bananaBottom) then 
        points = points + 1
        game.eatSound:play()
        game.resetBanana()
    end

    local grapeLeft = grapeX + 35
    local grapeRight = grapeX + 35
    local grapeTop = grapeY + 35
    local grapeBottom = grapeY + 35

    if (playerRight > grapeLeft) and (playerLeft < grapeRight) and (playerBottom > grapeTop) and (playerTop < grapeBottom) then 
        points = points + 3
        game.eatSound:play()
        game.resetGrape()
    end

    local orangeLeft = orangeX + 35
    local orangeRight = orangeX + 35
    local orangeTop = orangeY + 35
    local orangeBottom = orangeY + 35

    if (playerRight > orangeLeft) and (playerLeft < orangeRight) and (playerBottom > orangeTop) and (playerTop < orangeBottom) then 
        points = points + 5
        game.eatSound:play()
        game.resetOrange()
    end

    local tomatoLeft = tomatoX + 35
    local tomatoRight = tomatoX + 35
    local tomatoTop = tomatoY + 35
    local tomatoBottom = tomatoY + 35

    if (playerRight > tomatoLeft) and (playerLeft < tomatoRight) and (playerBottom > tomatoTop) and (playerTop < tomatoBottom) then 
        points = points - 4
        game.squishSound:play()
        game.resetTomato()
    end
end

function game.resetBanana()
    bananaX = love.math.random(0, windowX - 65)
    bananaY = love.math.random(0, windowY - 65)
end

function game.resetGrape()
    grapeX = love.math.random(0, windowX - 65)
    grapeY = love.math.random(0, windowY - 65)
end

function game.resetOrange()
    orangeX = love.math.random(0, windowX - 65)
    orangeY = love.math.random(0, windowY - 65)
end

function game.resetTomato()
    tomatoX = love.math.random(0, windowX - 65)
    tomatoY = love.math.random(0, windowY - 65)
end

function game.draw()
    -- Background
    love.graphics.setColor(37/255, 190/255, 126/255)
    love.graphics.rectangle('fill', 0, 0, windowX, windowY)

    love.graphics.setColor(1, 1, 1)

    -- Draw fruits
    love.graphics.draw(fruits.banana, bananaX, bananaY, nil, 2.5)
    love.graphics.draw(fruits.grape, grapeX, grapeY, nil, 2.5)
    love.graphics.draw(fruits.orange, orangeX, orangeY, nil, 2.5)
    love.graphics.draw(fruits.tomato, tomatoX, tomatoY, nil, 2.5)

    -- Draw player
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5)

    -- Draw score and time
    love.graphics.setColor(0, 0, 0)
    local font = love.graphics.newFont(20)
    love.graphics.setFont(font)
    love.graphics.print('score: ' .. points, 10, 10)
    -- love.graphics.print('time: ' .. 'PLACEHOLDER', (windowX / 2) - 70, 10)
end

return game