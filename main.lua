function love.load()
    windowX = 1200
    windowY = 900
    love.window.setMode(windowX, windowY)

    points = 0

    -- fruit load-in
    --[[
    * load in fruit
    * set fruit at random position
    * if fruit position == player position --> move fruit to new random position and add to point total
    * banana == +1
    * grape == +3
    * orange == +5
    * tomato == -2
    ]]
    bananaPNG = love.graphics.newImage('assets/banana.png')
    grapePNG = love.graphics.newImage('assets/grape.png')
    orangePNG = love.graphics.newImage('assets/orange.png')
    tomatoPNG = love.graphics.newImage('assets/tomato.png')

    -- sound load-in
    eatSound = love.audio.newSource('assets/beep.mp3', 'static')

    -- anim8 load-in
    anim8 = require 'anim8'
    love.graphics.setDefaultFilter('nearest', 'nearest')

    player = {}
    player.x = (windowX / 2) - 30
    player.y = (windowY / 2) - 50
    player.speed = 2
    player.spriteSheet = love.graphics.newImage('assets/player-sheet.png')

    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.1)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.1)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.1)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.1)

    player.anim = player.animations.down
end

function love.update(dt)
    local isMoving = false

    -- game window edge detection
    if player.x >= (windowX - 60) then
        player.x = windowX - 60
    end
    if player.x <= 0 then
        player.x = 0
    end
    if player.y >= (windowY - 90) then
        player.y = windowY - 90
    end
    if player.y <= 0 then
        player.y = 0
    end

    -- wasd controls
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    -- resting animation
    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)
end

function love.draw()
    -- background
    love.graphics.setColor(37/255, 190/255, 126/255)
    love.graphics.rectangle('fill', 0, 0, windowX, windowY)

    love.graphics.setColor(1, 1, 1)

    -- fruit(s)
    love.graphics.draw(bananaPNG, 0, 0, nil, 2.5)
    -- love.graphics.draw(grapePNG, 130, 30, nil, 2.5)
    -- love.graphics.draw(orangePNG, 230, 30, nil, 2.5)
    -- love.graphics.draw(tomatoPNG, 330, 30, nil, 2.5)

    -- player
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5)

    -- number totals
    love.graphics.setColor(0, 0, 0)
    font = love.graphics.newFont(20)
    love.graphics.setFont(font)
    love.graphics.print('score: '..points, 10, 10)
    love.graphics.print('time: '..'PLACEHOLDER', (windowX/2) - 70, 10)
end