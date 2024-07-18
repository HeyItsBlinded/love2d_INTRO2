local game = require("game")

function love.load()
    fruits.banana = love.graphics.newImage('assets/banana.png')
    fruits.grape = love.graphics.newImage('assets/grape.png')
    fruits.orange = love.graphics.newImage('assets/orange.png')
    fruits.tomato = love.graphics.newImage('assets/tomato.png')

    -- Load sounds
    game.eatSound = love.audio.newSource('assets/beep.mp3', 'static')

    -- Set default filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    game.load()
end

function love.update(dt)
    local isMoving = false

    -- Game window edge detection
    if player.x >= (windowX - 60) then player.x = windowX - 60 end
    if player.x <= 0 then player.x = 0 end
    if player.y >= (windowY - 90) then player.y = windowY - 90 end
    if player.y <= 0 then player.y = 0 end

    -- WASD/arrow key controls - allows only one direction at a time
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        player.x = player.x - player.speed
        player.anim = player.animations.left 
        isMoving = true
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    elseif love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    -- Resting animation
    if not isMoving then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)
    game.checkCollision()
end

function love.draw()
    game.draw()
end