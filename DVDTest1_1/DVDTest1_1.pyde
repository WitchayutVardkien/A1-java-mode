W, H = 190.0, 106.0                              
HUES = [0, 28, 52, 115, 195, 245, 305]          
PULL, DRAG = 0.01, 0.9                        

x = y = 250.0       
vx, vy = 3.0, 2.3    
fvx = fvy = 0.0      
tone = 0
following = False
trail, glow, scanlines = True, True, True
bigFont = smallFont = None


def setup():
    global x, y, bigFont, smallFont
    size(500, 500)
    colorMode(HSB, 360, 100, 100, 100)
    textAlign(CENTER, BASELINE)   
    bigFont = createFont("Arial Black", 148)
    smallFont = createFont("Arial Black", 22)
    x, y = width / 2.0, height / 2.0


def draw():
    if trail:                     
        noStroke()
        fill(0, 0, 0, 22)
        rect(0, 0, width, height)
    else:
        background(0)

    if following:
        floatToMouse()
    else:
        bounceAround()

    drawLogo()

    if scanlines:                 
        stroke(0, 0, 0, 45)
        for sy in range(0, height, 3):
            line(0, sy, width, sy)


def bounceAround():
    global x, y, vx, vy
    x, y = x + vx, y + vy


    if (x < W / 2 and vx < 0) or (x > width - W / 2 and vx > 0):
        vx = -vx
        hit()
    if (y < H / 2 and vy < 0) or (y > height - H / 2 and vy > 0):
        vy = -vy
        hit()


def floatToMouse():
    global x, y, fvx, fvy
    fvx = (fvx + (mouseX - x) * PULL) * DRAG
    fvy = (fvy + (mouseY - y) * PULL) * DRAG
    x, y = x + fvx, y + fvy


    if x < W / 2 or x > width - W / 2:
        x = constrain(x, W / 2, width - W / 2)
        fvx = 0.0
    if y < H / 2 or y > height - H / 2:
        y = constrain(y, H / 2, height - H / 2)
        fvy = 0.0


def hit():
    global tone
    tone = (tone + 1) % 8


def toneColor():
    if tone == 7:
        return color(frameCount * 1.5 % 360, 90, 100)   # rainbow
    return color(HUES[tone], 95, 100)


def drawLogo():
    col = toneColor()
    pushMatrix()
    translate(x, y)
    scale(W / 300.0)              
    noStroke()

    if glow:                      
        fill(col, 6)
        ellipse(0, 0, 340, 200)

    pushMatrix()                 
    translate(0, 24)             
    scale(0.86, 1.0)
    fill(col)
    textFont(bigFont)
    text("DVD", 0, 0)
    popMatrix()

    fill(col)                    
    ellipse(0, 60, 284, 48)
    fill(0)                       
    textFont(smallFont)
    text("V I D E O", 0, 68)

    popMatrix()


def mousePressed():
    global following, fvx, fvy
    if mouseButton == RIGHT:
        following = not following
        fvx = fvy = 0.0
    else:
        hit()


def keyPressed():
    global trail, glow, scanlines
    if key == '1':
        trail = not trail
    elif key == '2':
        glow = not glow
    elif key == '3':
        scanlines = not scanlines
