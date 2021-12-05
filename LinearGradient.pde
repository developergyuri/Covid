public class LinearGradient{
    private int height;
    private int width;
    private int xPos;
    private int yPos;
    private color color1;
    private color color2;
    private int axis;

    LinearGradient(int x, int y, int w, int h, color c1, color c2, int a){
        this.xPos = x;
        this.yPos = y;
        this.width = w;
        this.height = h;
        this.color1 = c1;
        this.color2 = c2;
        this.axis = a;
    }

    public void draw(int min, int max) {
        noFill();

        String minStr = str(min);
        String maxStr = str(max);

        if (this.axis == 0) {
            for (int i = this.yPos; i <= this.yPos + this.height; i++) {
                float inter = map(i, this.yPos, this.yPos + this.height, 0, 1);
                color c = lerpColor(this.color1, this.color2, inter);
                stroke(c);
                line(this.xPos, i, this.xPos + this.width, i); 
            }

            fill(0);
            textSize(16);

            pushMatrix();
            translate(this.xPos, this.yPos);
            rotate(-HALF_PI);
            text(maxStr, maxStr.length() * -10, 16);
            popMatrix();

            pushMatrix();
            translate(this.xPos, this.yPos + this.height);
            rotate(-HALF_PI);
            text(minStr, minStr.length() * 10, 16);
            popMatrix();

        }  
        else if (this.axis == 1) {
            for (int i = this.xPos; i <= this.xPos + this.width; i++) {
                float inter = map(i, this.xPos, this.xPos + this.width, 0, 1);
                color c = lerpColor(this.color1, this.color2, inter);
                stroke(c);
                line(i, this.yPos, i, this.yPos + this.height);
            }
        }
    }
}