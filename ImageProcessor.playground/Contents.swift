//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")


var imageProcessing = ImageProcessing(img: image!)
imageProcessing.filter(["BLUE","GREEN","INVERT"]).getUIImage()