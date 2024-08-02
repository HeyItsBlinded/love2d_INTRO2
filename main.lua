local game = require("game")

function love.load()
    -- Set default filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    fruits.banana = love.graphics.newImage('assets/banana.png')
    fruits.grape = love.graphics.newImage('assets/grape.png')
    fruits.orange = love.graphics.newImage('assets/orange.png')

    fruits.tomato = love.graphics.newImage('assets/tomato.png')

    -- Load sounds
    game.eatSound = love.audio.newSource('assets/beep.mp3', 'static')
    game.squishSound = love.audio.newSource('assets/squish.mov', 'static')

    game.load()

    startTime = love.timer.getTime()
end

function love.update(dt)
    local isMoving = false

    -- Game window edge detection
    if player.x >= (windowX - 60) then player.x = windowX - 60 end
    if player.x <= 0 then player.x = 0 end
    if player.y >= (windowY - 90) then player.y = windowY - 90 end
    if player.y <= 0 then player.y = 0 end

    -- WASD/arrow key controls - allows only one direction at a time
    if love.keyboard.isDown('d') then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    elseif love.keyboard.isDown('a') then
        player.x = player.x - player.speed
        player.anim = player.animations.left 
        isMoving = true
    elseif love.keyboard.isDown('s') then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    elseif love.keyboard.isDown('w') then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    -- Resting animation
    if not isMoving then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)
    game.update(dt)
    game.checkCollision()

    elapsedTime = love.timer.getTime() - startTime

    -- Game window edge detection
    if tractor.x >= (windowX - 100) then tractor.x = windowX - 100 end
    if tractor.x <= 0 then tractor.x = 0 end
    if tractor.y >= (windowY - 90) then tractor.y = windowY - 90 end
    if tractor.y <= -10 then tractor.y = -10 end

    -- Tractor arrow movement
    if love.keyboard.isDown('up') then
        tractor.y = tractor.y - tractor.speed * dt
        tractor.currentImg = tractorImg.up
    elseif love.keyboard.isDown('down') then
        tractor.y = tractor.y + tractor.speed * dt
        tractor.currentImg = tractorImg.down
    elseif love.keyboard.isDown('left') then
        tractor.x = tractor.x - tractor.speed * dt
        tractor.currentImg = tractorImg.left
    elseif love.keyboard.isDown('right') then
        tractor.x = tractor.x + tractor.speed * dt
        tractor.currentImg = tractorImg.right
    end

    -- TEMP Tomato generation
    -- tomatoBool = false
    -- if love.keyboard.isDown('space') then
    --     tomatoBool = true
    -- end
end

tomatoBool = false

function love.keypressed(key)
    if key == 'space' then
        tomatoBool = true
    end
end

function love.draw()
    game.draw()

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(string.format('time: %.2f', elapsedTime), (windowX / 2) - 70, 10)

    -- TEMP Tomato generation
    if tomatoBool then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(fruits.tomato, 400, 400, nil, 2.5)
    end
    -- if tomatoBool == true then
    --     love.graphics.setColor(1, 1, 1)
    --     love.graphics.draw(fruits.tomato, 400, 400, nil, 2.5)
    -- end
end