
function love.load()
    
    alvo = {}
    alvo.x = 200
    alvo.y = 400
    alvo.raio = 50
    
    score = 0
    timer = 0
    
    gameState = 1

    gameFonte = love.graphics.newFont(40)
    
    love.mouse.setVisible(false)
    
    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.alvo = love.graphics.newImage('sprites/target.png')
    sprites.mira = love.graphics.newImage('sprites/crosshairs.png')

end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = 1
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0,0)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(gameFonte)
    love.graphics.print("Score: " .. score, 5, 5)
    love.graphics.print("Timer: " .. math.ceil(timer), 300,5)

    if gameState == 1 then 
        love.graphics.printf("Clique em qualquer lugar para começar!",0 ,250, love.graphics.getWidth(), "center")
    end

    if gameState == 2 then 
        love.graphics.draw(sprites.alvo, alvo.x-alvo.raio,alvo.y-alvo.raio)
    end
    love.graphics.draw(sprites.mira, love.mouse.getX()-20,love.mouse.getY()-20)
end

function love.mousepressed( x, y, button, istouch, presses)
    if button == 1 and gameState == 2 then
        if distanciaAlvo(x, y) then    
            score = score + 1
            alvo.x = math.random(alvo.raio,love.graphics.getWidth() - alvo.raio)
            alvo.y = math.random(alvo.raio,love.graphics.getHeight()- alvo.raio)
        elseif score >= 1 then
            score = score - 1 
        end
    elseif button == 1 and gameState == 1 then
        gameState = 2
        timer = 10
        score = 0
    elseif button == 3 then
        timer = timer + 20
    elseif button == 2 and gameState == 2 then
        if distanciaAlvo(x, y) then    
            score = score + 2
            timer = timer - 1
            alvo.x = math.random(alvo.raio,love.graphics.getWidth() - alvo.raio)
            alvo.y = math.random(alvo.raio,love.graphics.getHeight()- alvo.raio)
        elseif score >= 1 then
            score = score - 1 
        end
    end
end

function distanciaAlvo(x, y)
    
    local pontoX1 = alvo.x+alvo.raio
    local pontoX2 = alvo.x-alvo.raio
    local pontoY1 = alvo.y+alvo.raio
    local pontoY2 = alvo.y-alvo.raio

    if pontoX1 >= x and pontoX2 <= x then
        if pontoY1 >= y and pontoY2 <= y then
            return true
        end
    end
end