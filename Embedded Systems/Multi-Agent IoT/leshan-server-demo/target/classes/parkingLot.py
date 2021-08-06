from sense_hat import SenseHat
import fileinput

sense = SenseHat()
sense.clear()  # Blank the LED matrix

# 0, 0 = Top left
# 7, 7 = Bottom right

status=2

vehicleX=3
vehicleY=0
vehiclePixel=[vehicleX, vehicleY]


def set_pixels(pixels, col):
        sense.set_pixel(pixels[0],pixels[1], col)


green = [90, 204, 41]
orange = [230, 170, 5]
red = [209, 18, 4]

running = True

while running:

     for line in fileinput.input():
         line=line.rstrip("\n")
         data=line.split(",");
         if(len(data)>1):
             vehicleX = int(data[0])
             vehicleY = int(data[1])
             vehiclePixel = [vehicleX, vehicleY]
             status=int(data[2])
             if status == 0:
                set_pixels(vehiclePixel, green)

             if status == 1:
                set_pixels(vehiclePixel, orange)

             if status == 2:
                set_pixels(vehiclePixel, red)


# sending the status?!! here or in Java