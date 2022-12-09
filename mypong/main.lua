--[[
    update 3 - "adding rectangle and ball movement"
    using a library called push to make the game virtually low resulotion
    to give the game a retro asthetic feel 
]]


-- adding the push library (like importing)
--https://github.com/Ulydev/push
push = require 'push'

-- setting an height and width values for the screen for using it in all code
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 720

-- virtual height and width values for the game 
VIRTUAL_WIDTH = 680
VIRTUAL_HEIGHT = 420


-- speed at which our paddle will move
PADDLE_SPEED = 200

--variables for score tracking
player1score = 0
player2score = 0

--variable Y values for the paddles
player1Y = 30
player2Y = VIRTUAL_HEIGHT-80


-- the love.load() function is like a constructor of a class, it runs only once at the start of the game and loads up initial conditions and screen
function love.load()
    -- a new font which is more retro looking
    oldFont = love.graphics.newFont('font.ttf',20)
    scoreFont = love.graphics.newFont('font.ttf',40)

    --this is just a filter so that text is still readable
    love.graphics.setDefaultFilter('nearest','nearest')
    
    -- replacing love.window.setMode() with the following underwritten function from push library for 
    -- keeping the external screen size  same but lower internal resulotion for old like effect
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

--function for terminating the game on press of escape button
function love.keypressed(key)
    -- the parameter key is of type string and will have its value equal to string value of that key
    if key == 'escape' then
        love.event.quit()
    end
end



--function for update which runs every frame and updates the screen 
function love.update(dt)
    if love.keyboard.isDown("a") then
        player1Y = math.max(0,player1Y - PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown(";") then
        player1Y = math.min(VIRTUAL_HEIGHT-50 ,player1Y + PADDLE_SPEED * dt)
    end
    
    if love.keyboard.isDown("-") then
        player2Y = math.max(0,player2Y - PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown("z") then
        player2Y = math.min(VIRTUAL_HEIGHT-50, player2Y + PADDLE_SPEED * dt)
    end
    
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

    -- for right paddle parameters of rectangle function are (type string(fill or line),starnig y coordinate, starting x coordinate,width, height)
    love.graphics.rectangle('fill',10,player1Y,5,50)

    --for ball
    love.graphics.circle('fill',VIRTUAL_WIDTH/2-3,VIRTUAL_HEIGHT/2-3,8)
    --for left paddle

    love.graphics.rectangle('fill',VIRTUAL_WIDTH -15,player2Y,5,50)
    
    -- for score display
    love.graphics.setFont(scoreFont)
    love.graphics.printf(player1score,0,20,VIRTUAL_WIDTH/2,'center')
    love.graphics.printf(player2score,VIRTUAL_WIDTH/2,20,VIRTUAL_WIDTH/2,'center')
    


    --end of rendering
    push:apply('end')

end

