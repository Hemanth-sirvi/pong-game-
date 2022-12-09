-- setting an height and width values for the screen for using it in all code
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 720

-- the love.load() function is like a constructor of a class, it runs only once at the start of the game and loads up initial conditions and screen
function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- the love.draw() function is called after update by love2d,used to draw anything on the screen
function love.draw()
    -- this function is a text printing function which takes the text , starting x , starting y, ending x and allignment 
    love.graphics.printf(
        'Hello Pong!',
        0,
        WINDOW_HEIGHT /2 -6,
        WINDOW_WIDTH,
        'center')
end