Ball = Class{}

function Ball:init(x,y,radius)
    self.x = x
    self.y = y
    self.dy = math.random(2)==1 and 200 or -200
    self.dx = math.random(-150,150)
    self.radius = radius
end


function Ball:reset()
    self.x = VIRTUAL_WIDTH/2-3
    self.y =  VIRTUAL_HEIGHT/2-3
    self.dx = math.random(2)==1 and 250 or -250
    self.dy = math.random(-150,150)
end

function Ball:update(dt)
    self.x = self.x + self.dx *dt
    self.y = self.y + self.dy *dt
end


function Ball:render()
    love.graphics.circle('fill',self.x,self.y,self.radius)

end


function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x +16 then
        return false
    end 

    if self.y > paddle.y + paddle.height or paddle.y > self.y + 16 then 
        return false
    end

    return true
end