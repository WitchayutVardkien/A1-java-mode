float W = 190.0;
float H = 106.0;
int[] HUES = { 0, 28, 52, 115, 195, 245, 305 };  
float PULL = 0.01;
float DRAG = 0.9;

float x = 250.0;
float y = 250.0;
float vx = 3.0;
float vy = 2.3;
float fvx = 0.0;
float fvy = 0.0;
int tone = 0;
boolean following = false;
boolean trail = true;
boolean glow = true;
boolean scanlines = true;
PFont bigFont;
PFont smallFont;


void setup() {
    size(500, 500);
    colorMode(HSB, 360, 100, 100, 100);
    textAlign(CENTER, BASELINE);
    bigFont = createFont("Arial Black", 148);
    smallFont = createFont("Arial Black", 22);
    x = width / 2.0;
    y = height / 2.0;
}


void draw() {
    if (trail) {
        noStroke();
        fill(0, 0, 0, 22);
        rect(0, 0, width, height);
    } else {
        background(0);
    }

    if (following) {
        floatToMouse();
    } else {
        bounceAround();
    }

    drawLogo();

    if (scanlines) {
        stroke(0, 0, 0, 45);
        for (int sy = 0; sy < height; sy = sy + 3) {
            line(0, sy, width, sy);
        }
    }
}


void bounceAround() {
    x = x + vx;
    y = y + vy;

    if ((x < W / 2 && vx < 0) || (x > width - W / 2 && vx > 0)) {
        vx = -vx;
        hit();
    }
    if ((y < H / 2 && vy < 0) || (y > height - H / 2 && vy > 0)) {
        vy = -vy;
        hit();
    }
}


void floatToMouse() {
    fvx = (fvx + (mouseX - x) * PULL) * DRAG;
    fvy = (fvy + (mouseY - y) * PULL) * DRAG;
    x = x + fvx;
    y = y + fvy;

    if (x < W / 2 || x > width - W / 2) {
        x = constrain(x, W / 2, width - W / 2);
        fvx = 0.0;
    }
    if (y < H / 2 || y > height - H / 2) {
        y = constrain(y, H / 2, height - H / 2);
        fvy = 0.0;
    }
}


void hit() {
    tone = (tone + 1) % 8;
}


int toneColor() {
    if (tone == 7) {
        return color(frameCount * 1.5 % 360, 90, 100);   // rainbow
    }
    return color(HUES[tone], 95, 100);
}


void drawLogo() {
    int col = toneColor();    // local variable
    pushMatrix();
    translate(x, y);
    scale(W / 300.0);
    noStroke();

    if (glow) {
        fill(col, 6);
        ellipse(0, 0, 340, 200);
    }

    pushMatrix();
    translate(0, 24);
    scale(0.86, 1.0);
    fill(col);
    textFont(bigFont);
    text("DVD", 0, 0);
    popMatrix();

    fill(col);
    ellipse(0, 60, 284, 48);
    fill(0);
    textFont(smallFont);
    text("V I D E O", 0, 68);

    popMatrix();
}


void mousePressed() {
    if (mouseButton == RIGHT) {
        following = !following;
        fvx = 0.0;
        fvy = 0.0;
    } else {
        hit();
    }
}


void keyPressed() {
    if (key == '1') {
        trail = !trail;
    } else if (key == '2') {
        glow = !glow;
    } else if (key == '3') {
        scanlines = !scanlines;
    }
}
