//
//  ViewController.swift
//  TesseractDemo
//
//  Created by Américo Cantillo on 11/07/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import TesseractOCR
import CoreImage
import EVGPUImage2

class ViewController: UIViewController, G8TesseractDelegate {

    @IBOutlet weak var tvText: UITextView!
    
    @IBOutlet weak var ivImage: UIImageView!
    
    var viImagen: UIImageView!
    
    var filterBlur: UIImage!
    var filterGrayScale : UIImage!
    
    var ipcControlador: UIImagePickerController!
    
    var context: CIContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //var copied: Bool = copyFileFromBundleToDirectory(dest: .libraryDirectory, directory: "Caches/data/tessdata", file: "spa.traineddata")
        
        //if copied {
        //    print("el tessdata file spa fue copiado a la carpeta documentos de la app con éxito.")
        //}
        
        //copied = copyFileFromBundleToDirectory(dest: .libraryDirectory, directory: "Caches/data/tessdata", file: "eng.traineddata")

        //if copied {
        //    print("el tessdata file eng fue copiado a la carpeta documentos de la app con éxito.")
        //}

        //_ = copyFileFromBundleToDirectory(directory: "tessdata", file: "fra", ext: "traineddata")
        
        let pathForBundle = Bundle.main.resourcePath!
        
        do {
            let contenido: [String] = try FileManager.default.contentsOfDirectory(atPath: pathForBundle).filter({$0.getFileExtension() == "traineddata"})
            var iter = 1
            for item in contenido {
                let file = item as String
                print("Item \(iter): \(file)")
                iter += 1
            }
        } catch {
            //print("Error al recperar el contenido del bundle \(error.localizedDescription)")
            NSLog("Error al recperar el contenido del bundle: %@", error.localizedDescription)
        }
        
        hideKeyboardWhenTappedAround()
        
        ivImage.image = UIImage.init(named: "IMG_0653.JPG")

    }
    
    func textRecognition(image: UIImage? = nil) {
        //let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //let path = paths.appendingPathComponent("tessdata")
        
        //if let tesseract = G8Tesseract.init(language: "spa") {

        if let tesseract = G8Tesseract.init(language: "spa+eng", configDictionary: nil, configFileNames: nil, cachesRelatedDataPath: "data", engineMode: .tesseractOnly) {
        //if let tesseract = G8Tesseract(language: "spa+eng") {
        
            tesseract.delegate = self
            
            //[tesseract setVariableValue:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" forKey:@"tessedit_char_whitelist"];
            //[tesseract setVariableValue:@".,:;'" forKey:@"tessedit_char_blacklist"];
            
            //tesseract.setVariableValue("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", forKey: "tessedit_char_whitelist")
            
            //tesseract.setVariableValue(".,:;'", forKey: "tessedit_char_blacklist")
            if image == nil {

                // Grab the image you want to preprocess
                //UIImage *inputImage = [UIImage imageNamed:@"my_test_image.jpg"];
                
                let inputImage = UIImage(named: "IMG_0653.JPG")
                
                // Initialize our adaptive threshold filter
                //GPUImageAdaptiveThresholdFilter *stillImageFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
                //stillImageFilter.blurRadiusInPixels = 4.0 // adjust this to tweak the blur radius of the filter, defaults to 4.0
                
                //let toonFilter = SmoothToonFilter()
                //let testImage = UIImage(named:"WID-small.jpg")!
                //let pictureInput = PictureInput(image:testImage)
                //let pictureOutput = PictureOutput()
                //pictureOutput.imageAvailableCallback = {image in
                //    // Do something with image
                //}
                //pictureInput --> toonFilter --> pictureOutput
                //pictureInput.processImage(synchronously:true)
                
                //let testImage = UIImage(named:"WID-small.jpg")!
                //let toonFilter = SmoothToonFilter()
                //let filteredImage = testImage.filterWithOperation(toonFilter)
                
                let filter = AdaptiveThreshold()
                filter.blurRadiusInPixels = 4.0
                
                let filteredImage = UIImage.init(cgImage: (inputImage?.filterWithOperation(filter).cgImage)!, scale: (inputImage!.scale), orientation: inputImage!.imageOrientation)
                
                
                
                //let filteredImage = inputImage?.filterWithOperation(filter).
                
                //let thresholdFilter = AdaptiveThreshold()
                //let pictureToProcess = PictureInput(image: inputImage)
                //let pictureOutput = PictureOutput()
                
                //pictureInput --> thresholdFilter --> pictureOutput
                //pictureInput.processImage(synchronously: true)
                
                
                //let stillImageFilter: GPUImageAdaptiveThresholdFilter = GPUImageAdaptiveThresholdFilter.init()
                //stillImageFilter.blurRadiusInPixels = 4.0
                
                // Retrieve the filtered image from the filter
                //UIImage *filteredImage = [stillImageFilter imageByFilteringImage:inputImage];
                
                //let filteredImage = stillImageFilter.image(byFilteringImage: inputImage)
                //let filteredImage = pictureOutput
                self.filterBlur = filteredImage
                // Give Tesseract the filtered image
                let imageGray = filteredImage.g8_grayScale() ;//let imageGray = applyFilterToImage(original: UIImage(named: "IMG_0653.JPG")!, filter: "CIPhotoEffectNoir")
                
                self.filterGrayScale = imageGray
                //let imageGray = applyFilterToImage(original: UIImage(named: "IMG_0653.JPG")!, filter: "CIPhotoEffectMono")

                //var imageGray = UIImage(named: "IMG_0653.JPG")?.g8_grayScale()
                
                //imageGray = applyFilterToImage(original: imageGray!, filter: "CIBoxBlur")

                //testingImageView.image = newImage
                
                
                //tesseract.image = UIImage(named: "IMG_0653.JPG")?.g8_grayScale()
                tesseract.image = imageGray
            } else {
                tesseract.image = image?.g8_grayScale()
            }
            
            tesseract.recognize()
            
            tvText.text = tesseract.recognizedText
        }
    }
    
    @IBAction func btnFilterOnTouchUpInside(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.ivImage.image = UIImage(named: "IMG_0653.JPG")
        } else if sender.tag == 1 {
            self.ivImage.image = self.filterBlur
        } else if sender.tag == 2 {
            self.ivImage.image = self.filterGrayScale
        }
        
    }
    
    func applyFilterToImage(original originalImage: UIImage, filter: String) -> UIImage {
        let currentFilter = CIFilter(name: filter)
        currentFilter!.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        self.context = CIContext(options: nil)
        let cgimg = context?.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        NSLog("Progreso de reconocimiento: \(tesseract.progress)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Acciones de los botones de la vista
    @IBAction func btnTomarFotoOnTouchUpInside(_ sender: UIButton) {
        ipcControlador = UIImagePickerController()
        ipcControlador.delegate = self
        ipcControlador.sourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(ipcControlador, animated: true, completion: nil)
        } else {
            //print("No se ha detectado la presencia de cámara!")
            
            showCustomAlert(self, titleApp: "Mi App", strMensaje: "No se ha detectado cámara en el dispositivo.  No es posible hacer la captura.", toFocus: nil)
        }
        
    }
    
    @IBAction func btnLibreriaFotosOnTouchUpInside(_ sender: UIButton) {
        ipcControlador = UIImagePickerController()
        ipcControlador.delegate = self
        ipcControlador.sourceType = .savedPhotosAlbum
        present(ipcControlador, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var iImagenParaReconocer: UIImage!
        
        ipcControlador.dismiss(animated: true, completion: nil)
        
        //self.ivCompra.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        iImagenParaReconocer = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // Si se utilizó la cámara, se procede con la compresión y guardado.
        if picker.sourceType == .camera {
            
            //let resultado = guardarImagen(imagen: iImagenParaGuardar)
            
            //self.nombreArchivoImagen = ""
            
            //let resultado = saveImageIn(directory: Global.Path.imagenes, image: iImagenParaGuardar, fullFileName: &self.nombreArchivoImagen!)
            
            //self.ivCompra.image = iImagenParaGuardar!
            
            //if !resultado {
            
            //    showCustomAlert(self, titleApp: "Mi App", strMensaje: "La imagen no pudo ser capturada", toFocus: nil)
            //} else {
            textRecognition(image: iImagenParaReconocer!)
            //textRecognition(image: nil)
            //}
            // obtiene la data de la imagen con compresión al 0.6
            //let imageDataCompressed = UIImageJPEGRepresentation(iImagenParaGuardar!, 0.6)
            //let compressedJPEGImage = UIImage(data: imageDataCompressed!)!
            //UIImageWriteToSavedPhotosAlbum(compressedJPEGImage, nil, nil, nil)
        } else {
            //let copiado = guardarImagen(imagen: iImagenParaGuardar)
            //if self.nombreArchivoImagen == nil {
            //self.nombreArchivoImagen = ""
            //}
            
            //let copiado = saveImageIn(directory: Global.Path.imagenes, image: iImagenParaGuardar, fullFileName: &self.nombreArchivoImagen!)
            //textRecognition(image: iImagenParaReconocer!)
            textRecognition(image: nil)
            //if !copiado {
            //    self.nombreArchivoImagen = nil
            //    showCustomAlert(self, titleApp: "Mi App", strMensaje: "La imagen no pudo ser guardada", toFocus: nil)
            //} else {
            //    _ = guardar()
            //}
        }
    }
    
}


