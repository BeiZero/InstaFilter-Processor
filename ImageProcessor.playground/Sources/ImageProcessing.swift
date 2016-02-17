import Foundation
import UIKit

public class ImageProcessing {
    private(set) var image:RGBAImage
    public static let RED = "RED"
    public static let GREEN = "GREEN"
    public static let BLUE = "BLUE"
    public static let INVERT = "INVERT"
    public static let MONOCHROME = "MONOCHROME"
    public static let BRIGHTNESS = "BRIGHTNESS"

    public func getUIImage()->UIImage {
        return image.toUIImage()!
    }

    public init(img: UIImage){
        image = RGBAImage(image: img)!
    }

    public func red(var intensity: Double) -> ImageProcessing{
        intensity = 255*min(1,max(intensity,0))
        return filter {(red,green,blue) -> (Int,Int,Int) in
            return (red+Int(intensity),green,blue)
        }
    }

    public func green(var intensity: Double) -> ImageProcessing{
        intensity = 255*min(1,max(intensity,0))
        return filter {(red,green,blue) -> (Int,Int,Int) in
            (red,Int(intensity)+green,blue)
        }
    }

    public func blue(var intensity: Double) -> ImageProcessing{
        intensity = 255*min(1,max(intensity,0))
        return filter {(red,green,blue) -> (Int,Int,Int) in
            (red,green,Int(intensity)+blue)
        }
    }

    public func invert() -> ImageProcessing{
        return filter {(red,green,blue) -> (Int,Int,Int) in
            (255-red,255-green,255-blue)
        }
    }

    public func monochrome(var intensity: Double) -> ImageProcessing {
        intensity = 1-min(1,max(intensity,0))
        return filter {(red,_,_) -> (Int,Int,Int) in
            (Int(intensity*Double(red)),Int(intensity*Double(red)),Int(intensity*Double(red)))
        }
    }

    public func brightness(intensity: Double) -> ImageProcessing {
        return filter {(red,green,blue) -> (Int,Int,Int) in
            (Int(intensity*Double(red)),Int(intensity*Double(green)),Int(intensity*Double(blue)))
        }
    }

    public func filter(filter: String, intensity:Double = 1) -> ImageProcessing{
        switch filter {
            case ImageProcessing.RED: return red(intensity)
            case ImageProcessing.GREEN: return green(intensity)
            case ImageProcessing.BLUE: return blue(intensity)
            case ImageProcessing.BRIGHTNESS: return brightness(intensity)
            case ImageProcessing.MONOCHROME: return monochrome(intensity)
            case ImageProcessing.INVERT: return invert()
            default: return self;
        }
    }

    public func filter(filters:[String]) -> ImageProcessing{
        filters.forEach{(x:String) in filter(x)}
        return self
    }

    public func filter(f:(red:Int,green:Int,blue:Int) -> (Int,Int,Int))-> ImageProcessing {
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                let pixel = image.pixels[index]
                let (nred,ngreen,nblue) = f(red: Int(pixel.red),green: Int(pixel.green),blue: Int(pixel.blue))
                image.pixels[index].red = UInt8(min(255,max(nred,0)))
                image.pixels[index].green = UInt8(min(255,max(ngreen,0)))
                image.pixels[index].blue = UInt8(min(255,max(nblue,0)))
            }
        }
        return self
    }
}
