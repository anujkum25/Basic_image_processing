# clear environment varibales
rm(list=ls())

#Set the working directory
setwd("E:/publish/Image Analysis")

#Install package
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("EBImage")

# Load the librray to current R session
library("EBImage")

# Read image file
Image=readImage("E:/publish/Image Analysis/panda.jpg")
display(Image)

# get details of image file like pixel value, colormode etc
print(Image)


# Adjust brightness
Image1=Image+0.4
Image2=Image-0.4
display(Image1)
display(Image2)

#to write image file
writeImage(Image1, "Image1.jpg")

#Adjusting Contrast
Image3=Image*0.7
Image4=Image*1.5
display(Image3)
display(Image4)

writeImage(Image4, "Image4.jpg")

# gamma correction
Image5=Image^2
Image6=Image^0.5
display(Image5)
display(Image6)


#Cropping
Image7=Image[806:2686,788:2725,]
display(Image7)
writeImage(Image7, "Image7.jpg")

#Spatial Transformation
Image8=translate(rotate(Image7,45),c(100,0))
display(Image8)
writeImage(Image8, "Image8.jpg")

#Color Management
colorMode(Image)=Grayscale
print(Image)
display(Image)
writeImage(Image, "Image_gray.jpg")

#revert the color change
colorMode(Image)=Color

#Combine Images .... here combining images means having several frames in one image. no of frames
# being equal to number of images being combined.
Imagecomb=combine( Image7, Image8)
display(Imagecomb)

# Morph Image.... 
## Image morph can only be done for binary image.
## A binary image is the one which have only two pixel value, 0 for background and 1 for object.
Image9=readImage("E:/publish/Image Analysis/BinaryImage.png")
kern=makeBrush(11, shape='diamond')
Imageerode=erode(Image9, kern)
Imagedilat=dilate(Image9, kern)
print(Image9)
display(Imageerode)
display(Imagedilat)
writeImage(Imageerode, "Imageerode.jpg")
writeImage(Imagedilat, "Imagedilat.jpg")

#Segmentation
## for a binary image, segmentation counts no of objects. 

Imagelabel=bwlabel(Image9)
cat('Number of objects=', max(Imagelabel),'\n')

# Filteration
## low pass filter
## low pass filter can remove noise or blur images

flow=makeBrush(19, shape='diamond', step=FALSE)^2
flow=flow/sum(flow)
imageflow=filter2(Image, flow)
display(imageflow)

## High pass filter
## high pass filter can detact edges or make images sharper.
fhi=matrix(1, nc=3, nr=3)
fhi[2,2]=-8
imagefhi=filter2(Image, fhi)
display(imagefhi)
writeImage(imagefhi,'highpassfilterImage.jpg')
