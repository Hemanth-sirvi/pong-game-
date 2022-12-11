---@diagnostic disable: lowercase-global


--[[
    update 4 - "implimenting object orineted programming"
    using class library to implement classes and object
]]


-- adding the push library (like importing)
--https://github.com/Ulydev/push
push = require 'push'

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- adding our paddle class
require 'Paddle'

--adding our ball class 
require 'Ball'

-- setting an height and width values for the screen for using it in all code
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual height and width values for the game 
VIRTUAL_WIDTH = 680
VIRTUAL_HEIGHT = 420


-- speed at which our paddle will move
PADDLE_SPEED = 250




-- the love.load() function is like a constructor of a class, it runs only once at the start of the game and loads up initial conditions and screen
function love.load()
    -- a new font which is more retro looking
    oldFont = love.graphics.newFont('font.ttf',20)
    scoreFont = love.graphics.newFont('font.ttf',40)
    winFont = love.graphics.newFont('font.ttf',30)
    --this is just a filter so that text is still readable
    love.graphics.setDefaultFilter('nearest','nearest')
   
    --title for the game window
    love.window.setTitle('Pong')

    --the ramdom function takes a number and after manipulating it generates a sudo random number 
    --if seed remains same than a ramdom output is not really random and to avoid this we set seed to os.time() which is new number every time
    math.randomseed(os.time())
    
    --importing sounds and storing them in a table
    sounds = {
        ['paddle'] = love.audio.newSource('sounds/wall.wav','static'),
        ['wall'] = love.audio.newSource("sounds/paddle.wav",'static'),
        ['score'] = love.audio.newSource('sounds/jump.wav','static')
    }
    
    -- replacing love.window.setMode() with the following underwritten function from push library for 
    -- keeping the external screen size  same but lower internal resulotion for old like effect
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    --paddle object for both players
    player1 = Paddle(10,30,5,420)
    player2 = Paddle(VIRTUAL_WIDTH -15,VIRTUAL_HEIGHT-80,5,420)

    --ball object decleration
    ball = Ball(VIRTUAL_WIDTH/2-3,VIRTUAL_HEIGHT/2-3,8)


    --variables for score tracking
    player1score = 0
    player2score = 0
    gameState = 'start'


end

function love.resize(w,h)
    push:resize(w,h)
    
end

--function for terminating the game on press of escape button
function love.keypressed(key)
    -- the parameter key is of type string and will have its value equal to string value of that key
    if key == 'escape' then
        love.event.quit()
    elseif key == 'return' or key == 'space' then
        if gameState =='start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
             --variable for ball position initilize to initial value
        elseif gameState == 'done' then

            ball:reset()
            if WinnigPlayer == 1 then
                servingPlayer = 2
            else 
                servingPlayer = 1
            end

            player1score = 0
            player2score = 0 
            gameState = 'serve'
        end
    end
end




--function for update which runs every frame and updates the screen 
function love.update(dt)

    if gameState == 'serve' then
        ball.dy = math.random(-200,200)

        if servingPlayer == 1 then
            ball.dx = math.random(200,250)
        else
            ball.dx = -math.random(200,250)
        end
    elseif gameState == 'play' then
        -- collision is detected with the paddle than invert the x velocity and increase speed by 5%
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.1
            ball.x = player1.x +5
            if ball.dy < 0 then
                ball.dy = -math.random(50,100)
            else 
                ball.dy = math.random(50,100)
            end

            sounds['paddle']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx *1.1
            ball.x = player2.x - 14
            if ball.dy < 0 then
                ball.dy = -math.random(50,100)
            else 
                ball.dy = math.random(50,100)
            end

            sounds['paddle']:play()
        end

        --for inverting the ball velocity when it collides from the top edge of screen
        if ball.y <=0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall']:play()
        end

        --for inverting the ball velocity when it collides from bottom edge
        if ball.y >= VIRTUAL_HEIGHT then
            ball.y = VIRTUAL_HEIGHT-16
            ball.dy = -ball.dy
            sounds['wall']:play()
        end
        if ball.x < 0 then
            servingPlayer = 1
            player2score = player2score+1
            sounds['score']:play()
            
            if player2score == 10 then
                WinnigPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1score = player1score +1
            sounds['score']:play()
            
            if player1score == 10 then
                WinnigPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    --for controling the paddles 
    --for player 1 the keys are a and ; since i am using dvorak keyboard layout
    if love.keyboard.isDown("a") then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown(";") then
        player1.dy = PADDLE_SPEED
    else
        player1.dy =0
    end

    --and for payer2 the keys are - and z
    if love.keyboard.isDown("-") then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("z") then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState =='play' then
        ball:update(dt)
    end


    player1:update(dt)
    player2:update(dt)

end





-- the love.draw() function is called after update by love2d,used to draw anything on the screen
function love.draw()
    -- start of rendering virtual resolution 
    push:apply('start')

    -- for adding a grey background
    love.graphics.clear(42/255, 45/255, 52/255, 255/255)
    
    -- this function is a text printing function which takes the text , starting x , starting y, ending x and allignment 
    player1:render()
    player2:render()
    
    --for ball
    ball:render()

    
    -- for score display
    love.graphics.setFont(scoreFont)
    love.graphics.printf(player1score,0,20,VIRTUAL_WIDTH/2,'center')
    love.graphics.printf(player2score,VIRTUAL_WIDTH/2,20,VIRTUAL_WIDTH/2,'center')
    
    displayFPS()

    if gameState == 'start' then
        love.graphics.setFont(oldFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 40, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(oldFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 40, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then
        love.graphics.setFont(winFont)
        love.graphics.printf('player'..tostring(WinnigPlayer)..' won',0, 100, VIRTUAL_WIDTH,'center')
        love.graphics.printf('press Enter or space to restart!',0,140,VIRTUAL_WIDTH,'center')
    elseif gameState == 'play' then
    end

    --end of rendering
    push:apply('end')

end

function displayFPS()
    love.graphics.setFont(oldFont)
    love.graphics.setNewFont(10)
    love.graphics.setColor(0,1.0,0,1.0)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()))
end