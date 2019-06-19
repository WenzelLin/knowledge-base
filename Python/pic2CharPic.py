from PIL import Image
import os

 

color = 'MNHQ$OC?7>!:-;.'

 
def make_char_img(img):

    pix = img.load()

    pic_str = ''

    width, height = img.size

    for h in xrange(height):

        for w in xrange(width):

            pic_str += color[int(pix[w, h]) * 14 / 255]

        pic_str += '\n'

    return pic_str

 

def preprocess(img_name, scaling_rate):

    img = Image.open(img_name)

 

    w, h = img.size

    m = max(img.size)

    delta = m / scaling_rate

    w, h = int(w / delta), int(h / delta)

    img = img.resize((w, h))

    img = img.convert('L')

 

    return img

 

def save_to_file(filename, pic_str):

    outfile = open(filename, 'w')

    outfile.write(pic_str)

    outfile.close()

 


def text2Pic(filename,text,font_size):

    from PIL import ImageFont,ImageDraw

    font = ImageFont.truetype("Monaco.ttf", font_size)

    lines = text.split('\n')

    line_width,line_height = font.getsize(lines[0])

    img_height = line_height*len(lines)


    im = Image.new("RGB", (line_width, img_height), (255,255,255))

    dr = ImageDraw.Draw(im)

    x,y=5,5

    for line in lines:

        dr.text((x,y),line, font=font,fill="#000000")

        y += line_height


    im.save(filename)
    



def main(source_pic='./me.jpg',target_pic='me_char.jpg',scaling_rate=500.0,font_size=5):

    img = preprocess(source_pic,scaling_rate)

    pic_str = make_char_img(img)

    # save_to_file('me_char.html', pic_str)

    text2Pic(target_pic,pic_str,font_size)


 
if __name__ == '__main__':


    default_source_pic = './me.jpg'

    source_pic = raw_input("The default source image path is '"+default_source_pic+"'. Enter nothing that will use the default value or enter a new value: ")

    if source_pic is None or source_pic == "":

        source_pic = default_source_pic



    source_pic_text = os.path.splitext(source_pic)

    default_target_pic = source_pic_text[0]+'_char'+source_pic_text[1]

    target_pic = raw_input("The default image save path is '"+default_target_pic+"'. Enter nothing that will use the default value or enter a new value: ")
    
    if target_pic is None or target_pic == "":

        target_pic = default_target_pic



    default_scaling_rate = 500.0
    
    scaling_rate = raw_input("The default image scaling rate is '"+str(default_scaling_rate)+"'. Enter nothing that will use the default value or enter a new value: ")
      
    if scaling_rate is None or scaling_rate == "":

        scaling_rate = default_scaling_rate
    
    else:

        scaling_rate = float(scaling_rate)
  


    default_font_size = 5
    
    font_size = raw_input("The default image font size is '"+str(default_font_size)+"'. Enter nothing that will use the default value or enter a new value: ")
    
    if font_size is None or font_size == "":

        font_size = default_font_size

    else:

        font_size = int(font_size)

    print 'Converting...'

    main(source_pic,target_pic,scaling_rate,font_size)

    print 'Finished.'

    print "The source file is '", source_pic, "'."

    print "The target file is '", target_pic, "'."