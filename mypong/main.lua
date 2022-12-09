--[[
    update 1 - "making it low resulotion"
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
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


-- the love.load() function is like a constructor of a class, it runs only once at the start of the game and loads up initial conditions and screen
function love.load()

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

-- the love.draw() function is called after update by love2d,used to draw anything on the screen
function love.draw()
    -- start of rendering virtual resolution 
    push:apply('start')

    -- this function is a text printing function which takes the text , starting x , starting y, ending x and allignment 
    love.graphics.printf('Hello Pong!',0,VIRTUAL_HEIGHT /2 -6,VIRTUAL_WIDTH,'center')

    --end of rendering
    push:apply('end')

end