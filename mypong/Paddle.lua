
Paddle = Class{}

function Paddle:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    -- if velocity is negetive than the paddle is moving up and to keep it in bound, we are using max of 0 and the value given by the velocity
    if self.dy < 0 then
        self.y = math.max(0,self.y + self.dy *dt)
    -- if velocity is positive than the paddle in moving down, in that case min funciton is used 
    else
        self.y = math.min(VIRTUAL_HEIGHT- self.height, self.y + self.dy * dt)
    end
end

-- this function is to be called inside love.draw to render the paddle
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    
end