function love.load()
    math.randomseed(os.time())

    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.healt = love.graphics.newImage('sprites/healt.png')
    
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 180
    

    myFont = love.graphics.newFont(30)

    zombies = {}
    bullets = {}
    gameState = 1
    loadVar()
    
end

function loadVar()
    player.vida = 10 
    
    score = 0
    maxTime = 2
    timer = maxTime
    tempColor = 0
end

function love.update(dt)
    if gameState == 2 then
        if love.keyboard.isDown("d") and player.x < love.graphics.getWidth()-sprites.player:getWidth()/2 then
            player.x = player.x + player.speed*dt
        end
        if love.keyboard.isDown("a") and player.x > 0 + sprites.player:getWidth()/2 then
            player.x = player.x - player.speed*dt
        end
        if love.keyboard.isDown("w") and player.y > 0 + sprites.player:getHeight()/2 then
            player.y = player.y - player.speed*dt
        end
        if love.keyboard.isDown("s") and player.y < love.graphics.getWidth()-sprites.player:getHeight()/2 then
            player.y = player.y + player.speed*dt
        end
    end

    for i, z in ipairs(zombies) do
        z.x = z.x + math.cos( ZombiePlayerAngle(z)) * z.speed * dt
        z.y = z.y + math.sin( ZombiePlayerAngle(z)) * z.speed * dt

        if distanciaBetween(z.x, z.y, player.x, player.y) < 30 then
            if player.vida == 1 then 
                for j, z in ipairs(zombies) do
                    zombies[j] = nil
                    gameState = 1
                    player.vida = player.vida - 1
                    player.x = love.graphics.getWidth()/2
                    player.y = love.graphics.getHeight()/2
                end
            elseif player.vida > 1 then
                z.dead = true
                player.vida = player.vida - 1
                tempColor = 0.5
            end

        end
    end

    for i, b in ipairs(bullets) do
        b.x = b.x + math.cos(  b.diretion) * b.speed * dt
        b.y = b.y + math.sin( b.diretion) * b.speed * dt
    end

    for i=#bullets, 1, -1 do
       local b = bullets[i]
       if b.x < 0 or b.y < 0  or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then 
        table.remove(bullets, i)
       end
    end 

    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do
            if distanciaBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                score = score + 1
            end
        end
    end

    for i=#zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end

    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end

    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime 
            timer = maxTime
        end
    end

    if tempColor > 0 then
        tempColor = tempColor - dt
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0,0)
    
    if gameState == 1 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Clique em qualquer lugar para começar!",0 ,50, love.graphics.getWidth(), "center")
    end
    love.graphics.printf("Score: " .. score,0,love.graphics.getHeight()-100, love.graphics.getWidth(), "center")
    
    
    for i,z in ipairs(zombies) do     
        love.graphics.draw(sprites.zombie, z.x, z.y,ZombiePlayerAngle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end
    
    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x,b.y, nil, 0.5, nil, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
    
    if tempColor > 0 then
        love.graphics.setColor(1,0,0)
        love.graphics.draw(sprites.player, player.x,player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
        love.graphics.setColor(1,1,1)
    elseif tempColor <= 0 then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(sprites.player, player.x,player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
    end    
    for  i = player.vida, 1, -1 do
        love.graphics.draw(sprites.healt, 20*i, love.graphics.getHeight()-sprites.healt:getHeight()*2, nil, 2)
    end

end

function love.mousepressed( x, y, button )
    if button == 1  and gameState == 2 then
        spawnBullet()
    elseif button == 1 and gameState == 1 then
        gameState = 2
        loadVar()
    end
end

function playerMouseAngle()
   return math.atan2( love.mouse.getY() - player.y, love.mouse.getX()- player.x)
end

function ZombiePlayerAngle(enemy)
    return math.atan2( player.y-  enemy.y, player.x - enemy.x )
 end

function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 180
    zombie.dead = false

    local side = math.random(1, 4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0,love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0,love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random(0,love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then
        zombie.x = math.random(0,love.graphics.getWidth())
        zombie.y = love.graphics.getWidth() + 30
    end
    table.insert(zombies,zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.dead = false
    bullet.diretion = playerMouseAngle()
    table.insert(bullets, bullet)
end

function distanciaBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2-y1)^2)
end