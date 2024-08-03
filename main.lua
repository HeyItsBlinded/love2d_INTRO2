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

    -- Cooldown functionality
    cooldownTime = 5
    cooldown = 0
    isCooldown = false

     -- Tomato functionality
     tomatoPositions = {}
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

    -- Cooldown functionality
    if isCooldown then
        cooldown = cooldown - dt
        if cooldown <= 0 then
            isCooldown = false
            cooldown = 0
        end
    end
end

tomatoBool = false

function love.keypressed(key)
    if key == 'space' and not isCooldown then
        -- tomatoBool = true

        table.insert(tomatoPositions, {x = tractor.x + 18, y = tractor.y + 20})

        isCooldown = true
        cooldown = cooldownTime
    end
end

function love.draw()
    game.draw()

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(string.format('time: %.2f', elapsedTime), (windowX / 2) - 70, 10)

    -- TEMP Tomato generation
    love.graphics.setColor(1, 1, 1)
    for _, pos in ipairs(tomatoPositions) do
        love.graphics.draw(fruits.tomato, pos.x, pos.y, nil, 2.5)
    end
    -- if tomatoBool then
    --     love.graphics.setColor(1, 1, 1)
    --     love.graphics.draw(fruits.tomato, tractor.x, tractor.y, nil, 2.5)
    -- end
    
    -- Cooldown functionality
    if isCooldown then
        love.graphics.setColor(0, 0, 0)
        love.graphics.print('cooldown: ' .. string.format("%.2f", cooldown), 800, 10)
    else
        love.graphics.print('action ready', 800, 10)
    end
end