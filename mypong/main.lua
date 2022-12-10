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
WINDOW_WIDTH = 1080
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

    --this is just a filter so that text is still readable
    love.graphics.setDefaultFilter('nearest','nearest')
   
    math.randomseed(os.time())
    -- replacing love.window.setMode() with the following underwritten function from push library for 
    -- keeping the external screen size  same but lower internal resulotion for old like effect
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    --paddle object for both players
    player1 = Paddle(10,30,5,50)
    player2 = Paddle(VIRTUAL_WIDTH -15,VIRTUAL_HEIGHT-80,5,50)

    --ball object decleration
    ball = Ball(VIRTUAL_WIDTH/2-3,VIRTUAL_HEIGHT/2-3,8)


    --variables for score tracking
    player1score = 0
    player2score = 0
    gameState = 'start'


end

--function for terminating the game on press of escape button
function love.keypressed(key)
    -- the parameter key is of type string and will have its value equal to string value of that key
    if key == 'escape' then
        love.event.quit()
    elseif key == 'return' or key == 'space' then
        if gameState =='start' then
            gameState = 'play'
        else
            gameState = 'start'

             --variable for ball position initilize to initial value
            ball:reset()
        end
    end
end



--function for update which runs every frame and updates the screen 
function love.update(dt)
    if love.keyboard.isDown("a") then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown(";") then
        player1.dy = PADDLE_SPEED
    else
        player1.dy =0
    end

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
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    -- this function is a text printing function which takes the text , starting x , starting y, ending x and allignment 
    love.graphics.setFont(oldFont)
    love.graphics.printf('Hello Pong!',0, 20,VIRTUAL_WIDTH,'center')

    player1:render()
    player2:render()
    
    --for ball
    ball:render()

    
    -- for score display
    love.graphics.setFont(scoreFont)
    love.graphics.printf(player1score,0,20,VIRTUAL_WIDTH/2,'center')
    love.graphics.printf(player2score,VIRTUAL_WIDTH/2,20,VIRTUAL_WIDTH/2,'center')
    


    --end of rendering
    push:apply('end')

end

