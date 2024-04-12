

player = world:newRectangleCollider(0,0, 40, 100, {collision_class = "Player"})
player:setFixedRotation(true)
player.speed = 240
player.animation = animations.idle
player.isMovie = false
player.direction = 1
player.grounded = true

function playerUpdate(dt)
    if player.body then
        local collliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 40, 2, {'Platform', 'Piso'})
        if #collliders > 0 then
            player.grounded = true
        else
            player.grounded = false
        end

        player.isMovie = false
        local px, py = player:getPosition()
        if love.keyboard.isDown('right') then
            player:setX(px + player.speed * dt)
            player.isMovie = true
            player.direction = 1
        end
        if love.keyboard.isDown('left') then
            player:setX(px - player.speed * dt)
            player.isMovie = true
            player.direction = -1
        end

        if player:enter('Danger') then
            SpawnPlayer()
        end
    end

    if player.grounded then
        if player.isMovie then
            player.animation = animations.run
        else 
            player.animation = animations.idle
        end
    else
        player.animation = animations.jump
    end
    player.animation:update(dt)
end

function playerDraw()
    if player:getPosition() then
        local px, py = player:getPosition()
        player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)            
    end
end