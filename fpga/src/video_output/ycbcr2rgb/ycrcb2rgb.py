# Script to check how different the popper way of doing YCrCB to RGB colorspace conversion 
# stacks up agains my version with no floats/fixed math
# needs limiters at the top and bottom of the range to stop overflow/underflow 

def ycrcb2rgb(y, cr,cb):
    r = ((298.082 * y) / 256)  + ((405.583 * cr) / 256) -222.921
    g = ((298.082 * y) / 256) - ((100.291 * cb) / 256)  - ((208.120 * cr) / 256) +135.576
    b = ((298.082 * y) / 256)  + ((516.422 * cb) / 256) -276.836

    RGB_out = [r,g,b]
    return RGB_out

def ycrcb2rgb_nofloat(y, cr,cb):
    r = round (((298 * y) / 256)  + ((405 * cr) / 256) -222)
    g = round (((298 * y) / 256) - ((100 * cb) / 256)  - ((208* cr) / 256) +135)
    b = round(((298 * y) / 256)  + ((516 * cb) / 256) -276)

    RGB_out = [r,g,b]
    return RGB_out

col1 = ycrcb2rgb(250,10,10)
col2 = ycrcb2rgb_nofloat(250,10,10)
col = ycrcb2rgb(100,100,100)