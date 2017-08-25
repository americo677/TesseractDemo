//
//  Extensions.swift
//  Mis Regalos
//
//  Created by Américo Cantillo on 30/01/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit
//import GoogleMobileAds
import StoreKit
import CoreData

// Put this piece of code anywhere you like
extension UIViewController {
    
    // MARK: - Procedimiento para ocultar el teclado al tocar la pantalla en cualquier punto
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Para terminar la edición de un UITextField
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Procedimientos para desplazar los controles de la vista al aparecer el teclado
    func keyboardShowUp(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.view.frame.origin = CGPoint(x: 0, y: 0)
            
            //let lowerY = getLowerCoordYForTextField()
            
            // se resta de la vista la altura del teclado y la altura de la toolbar
            //self.view.frame.origin.y -= keyboardFrame.height - (self.navigationController?.toolbar.frame.size.height)!

            //let viewY = self.view.frame.origin.y - ( keyboardFrame.height - (self.navigationController?.toolbar.frame.size.height)!)
            
            //print("Modelo: \(UIDevice().model)")
            //print("Nombre: \(UIDevice().name)")
            //print("Descripcion: \(UIDevice().description)")
            //print("Nivel de batería: \(UIDevice().batteryLevel)")
            
            // Solo aplica para dispositivos iPod y iPhone
            if UIDevice().model.lowercased().contains("phone") || UIDevice().model.lowercased().contains("pod") {
                // se resta de la vista la altura del teclado y la altura de la toolbar
                self.view.frame.origin.y -= keyboardFrame.height - (self.navigationController?.toolbar.frame.size.height)!
            }
            
        }
    }
    
    // MARK: - Procedimientos para desplazar los controles de la vista al desaparecer el teclado
    func keyboardHideUp(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.view.frame.origin = CGPoint(x: 0, y: 0)
        }
    }

    // MARK: - Registra las notificaciones del teclado
    func registerFromKeyboardNotifications() {
        
        // registra las notificaciones del teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowUp(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideUp(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Remueve las notificaciones del teclado
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Alerta personalizada
    func showCustomAlert(_ vcSelf: UIViewController!, titleApp: String, strMensaje: String, toFocus: UITextField?) {
        let alertController = UIAlertController(title: titleApp, message:
            strMensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.cancel,handler: {_ in
            
            if toFocus != nil {
                toFocus!.becomeFirstResponder()
            }
        }
        )
        
        alertController.addAction(action)
        
        vcSelf.present(alertController, animated: true, completion: nil)
        
    }

    func getLowerCoordYForTextField() -> CGFloat {
        var lowerY: CGFloat = 0.0
        
        for v in self.view.subviews {
            if let tf = v as? UITextField {
                if lowerY <= tf.frame.origin.y {
                    lowerY = tf.frame.origin.y
                }
            }
        }
        return lowerY
    }
    
    func getObjectsThatConformToType<T>(type:T.Type) -> [T] {
        var returnArray: [T] = []
        for object in self.view.subviews as [UIView] {
            if let comformantModule = object as? T {
                returnArray.append(comformantModule)
            }
        }
        return returnArray
    }
    
    func initToolBar(toolbarDesign: ToolbarButtonDesign, actions: Array<Selector?>, title: String) {
        
        // Configuración Toolbar
        self.navigationController?.isToolbarHidden = false
        
        // Cambia el color de la navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.toolbarBackgroundColor()
        
        // Cambia el color del texto de la navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.toolbarTitleFontColor(),  NSFontAttributeName: UIFont(name: Global.fuente.FONT_NAME_TITLE_NAVIGATION_BAR, size: Global.fuente.FONT_SIZE_14)!]
        
        self.navigationController?.navigationBar.tintColor = UIColor.toolbarTitleFontColor()
        
        self.navigationItem.title = title
        
        // Status bar white font
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        
        let buttonFont : UIFont = UIFont(name: Global.fuente.FONT_NAME_TITLE_NAVIGATION_BAR, size: Global.fuente.FONT_SIZE_13)!
        
        let attribs = [NSForegroundColorAttributeName : UIColor.toolbarTitleFontColor(),NSFontAttributeName : buttonFont]

        if toolbarDesign == .toLeftMenuToRightEditNewStyle {
            let menuButtonLeft = UIBarButtonItem(title: "Menú", style: UIBarButtonItemStyle.plain, target: self, action: actions[0])
            
            let editButtonRight   = UIBarButtonItem(title: "Editar", style: UIBarButtonItemStyle.plain, target: self, action: actions[1])
            
            editButtonRight.possibleTitles = ["Editar", "Aceptar"]
            
            let newButtonRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: actions[2])
            
            let backButtonLeft = UIBarButtonItem(title: "Regresar", style: UIBarButtonItemStyle.plain, target: self, action: actions[0])

            menuButtonLeft.setTitleTextAttributes(attribs, for: UIControlState.normal)
            editButtonRight.setTitleTextAttributes(attribs, for: UIControlState.normal)
            newButtonRight.setTitleTextAttributes(attribs, for: UIControlState.normal)
            backButtonLeft.setTitleTextAttributes(attribs, for: UIControlState.normal)
            
            navigationItem.rightBarButtonItems = [newButtonRight, editButtonRight]
            
            self.navigationItem.leftBarButtonItem = menuButtonLeft
        
            self.navigationItem.backBarButtonItem = backButtonLeft

        } else if toolbarDesign == .toLeftBackToRightEditNewStyle {
            let backButtonLeft = UIBarButtonItem(title: "Regresar", style: UIBarButtonItemStyle.plain, target: self, action: actions[0])
            
            let editButtonRight = UIBarButtonItem(title: "Editar", style: UIBarButtonItemStyle.plain, target: self, action: actions[1])
            
            editButtonRight.possibleTitles = ["Editar", "Aceptar"]

            let newButtonRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: actions[2])
            
            backButtonLeft.setTitleTextAttributes(attribs, for: UIControlState.normal)
            editButtonRight.setTitleTextAttributes(attribs, for: UIControlState.normal)
            newButtonRight.setTitleTextAttributes(attribs, for: UIControlState.normal)

            navigationItem.rightBarButtonItems = [newButtonRight, editButtonRight]
            
            self.navigationItem.backBarButtonItem = backButtonLeft
        } else if toolbarDesign == .toLeftBackToRightSaveStyle {
            let backButtonLeft = UIBarButtonItem(title: "Regresar", style: UIBarButtonItemStyle.plain, target: self, action: actions[0])

            let saveButtonRight = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.plain, target: self, action: actions[1])

            saveButtonRight.setTitleTextAttributes(attribs, for: UIControlState.normal)
            backButtonLeft.setTitleTextAttributes(attribs, for: UIControlState.normal)

            navigationItem.rightBarButtonItems = [saveButtonRight]

            self.navigationItem.backBarButtonItem = backButtonLeft
        } else if toolbarDesign == .toLeftBackToRightStyle {
            let backButtonLeft = UIBarButtonItem(title: "Regresar", style: UIBarButtonItemStyle.plain, target: self, action: actions[0])
            
            backButtonLeft.setTitleTextAttributes(attribs, for: UIControlState.normal)
            
            self.navigationItem.backBarButtonItem = backButtonLeft
        } else if toolbarDesign == .toLeftBackToRightPDFStyle {
            let backButtonLeft = UIBarButtonItem(title: "Regresar", style: UIBarButtonItemStyle.plain, target: self, action: actions[0])
            
            let pdfButtonRight = UIBarButtonItem(title: "PDF", style: UIBarButtonItemStyle.plain, target: self, action: actions[1])
            
            pdfButtonRight.setTitleTextAttributes(attribs, for: UIControlState.normal)
            backButtonLeft.setTitleTextAttributes(attribs, for: UIControlState.normal)
            
            navigationItem.rightBarButtonItems = [pdfButtonRight]
            self.navigationItem.backBarButtonItem = backButtonLeft
        }
    }
    
    
//    func restrictRotation(restrict: Bool) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.restrictRotation = restrict
//    }
    
//    // MARK: - Consulta a la BD de instituciones y escalas registradas
//    func fetchData(entity: ClassForPreLoading, byIndex index: Double? = nil, orderByIndex order: Bool? = false) -> [AnyObject] {
//        
//        var results = [AnyObject]()
//        
//        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
//        //let sortDescriptor = NSSortDescriptor(key: "secciones.recibos.fecha", ascending: false)
//        
//        
//        // fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        // Initialize Fetch Request
//        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: smModelo.smPresupuesto.entityName)
//        
//        //let fetchRequest: NSFetchRequest<Programa> = Programa.fetchRequest() //
//        //var fecthRequest: NSFetchRequestResult?
//        
//        switch entity {
//        case .institucion:
//            let fetchInstitucion: NSFetchRequest<Institucion> = Institucion.fetchRequest()
//            fetchInstitucion.entity = NSEntityDescription.entity(forEntityName: "Institucion", in: moc)
//            if index != nil {
//                let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
//                //let predicate = NSPredicate(format: " descripcion contains[c] %@ ", "norte" as String)
//                fetchInstitucion.predicate = predicate
//            }
//            do {
//                results = try moc.fetch(fetchInstitucion)
//                
//            } catch {
//                let fetchError = error as NSError
//                print(fetchError)
//            }
//            break
//        case .escala:
//            let fetchEscala: NSFetchRequest<Escala> = Escala.fetchRequest()
//            fetchEscala.entity = NSEntityDescription.entity(forEntityName: "Escala", in: moc)
//            if index != nil {
//                let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
//                fetchEscala.predicate = predicate
//            }
//            do {
//                results = try moc.fetch(fetchEscala)
//                
//            } catch {
//                let fetchError = error as NSError
//                print(fetchError)
//            }
//            break
//        case .programa:
//            let fetchPrograma: NSFetchRequest<Programa> = Programa.fetchRequest()
//            fetchPrograma.entity = NSEntityDescription.entity(forEntityName: "Programa", in: moc)
//            if index != nil {
//                let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
//                fetchPrograma.predicate = predicate
//            }
//            do {
//                let programas = try moc.fetch(fetchPrograma)
//                if order! {
//                    results = programas.sorted { ($0 as Programa).indice < ($1 as Programa).indice }
//                } else {
//                    results = programas
//                }
//                
//            } catch {
//                let fetchError = error as NSError
//                print(fetchError)
//            }
//            break
//        default:
//            break
//        }
//        
//        return results
//    }
    
    
    // MARK: - Configuración del Banner de publicidad
/*
    func configAds() {
     
        self.gadBannerView.adSize = kGADAdSizeBanner
     
        //let frame = CGRect(x:0, y:self.view.frame.size.height - self.gadBannerView.adSize.size.height - (self.navigationController?.toolbar.frame.size.height)!, width:320, height:50)
        
        //self.gadBannerView.frame = frame
        
        let request = GADRequest()
        
        request.testDevices = [kGADSimulatorID]
        
        self.gadBannerView.adUnitID = CGlobal().AD_UNIT_ID_TEST
        //self.gadBannerView.adUnitID = CGlobal().AD_UNIT_ID
        
        self.gadBannerView.delegate = self
        
        self.gadBannerView.rootViewController = self
        
        self.gadBannerView.load(request)
        
        //self.gadBannerView.tag = 1
        
        self.gadBannerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.gadBannerView)
        
        let center = NSLayoutConstraint(item: self.gadBannerView, attribute: .centerX, relatedBy: .lessThanOrEqual, toItem: self.gadBannerView.superview, attribute: .centerX, multiplier: 1, constant: 0)
        
        //let bottom = NSLayoutConstraint(item: self.gadBannerView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant:-((self.navigationController?.toolbar.frame.size.height)!))
        
        let bottom = NSLayoutConstraint(item: self.gadBannerView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant:0)
        
        self.view.addConstraints([center, bottom])
    }
*/
}


extension NSDate {
    
    public func isLessThan(date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }
    
    public func isLessEqualThan(date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending && self.compare(date) == ComparisonResult.orderedSame
    }
    
    public func isGreaterThan(date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }
    
    public func isGreaterEqualThan(date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending && self.compare(date) == ComparisonResult.orderedSame
    }
}


extension UIViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Funciones de los UIPickerViews
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nil
    }

    // MARK: - Carga inicial del pickerView con Array<String>
    func loadPickerView(_ pickerView: inout UIPickerView, indiceSeleccionado: Int, indicePorDefecto: Int = 0, tag: Int, textField tf: UITextField? = nil, opciones: Array<String>, accionDone: Selector?, accionCancel: Selector?) {
        
        // Preparación del Picker de ipo de RegistroT
        pickerView     = UIPickerView(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 220))
        
        pickerView.backgroundColor = UIColor.lightGray
        
        pickerView.tag = tag
        
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let tb         = UIToolbar()
        tb.barStyle    = UIBarStyle.default
        tb.isTranslucent = true
        
        //toolBar.tintColor = UIColor.whiteColor()
        //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        tb.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: accionDone!)
        
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: accionCancel!)
        
        tb.setItems([btnCancel, btnSpace, btnDone], animated: false)
        tb.isUserInteractionEnabled = true
        
        // colocar el valor por default en el picker de un solo componente
        if pickerView.selectedRow(inComponent: 0) == -1 {
            if pickerView.numberOfRows(inComponent: 0) > 0 {
                pickerView.selectRow(indicePorDefecto, inComponent: 0, animated: true)
                
                if tf != nil {
                    tf?.text = opciones[pickerView.selectedRow(inComponent: 0)]
                }
            }
        } else {
            if tf != nil {
                tf?.text = opciones[pickerView.selectedRow(inComponent: 0)]
            }
        }

        if tf != nil {
            tf?.inputView = pickerView
            tf?.inputAccessoryView = tb
        }
        
    }
}

/*
extension UIViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        print("on trigger: \(activeTextField.text!)")
    }
    
}
*/

/*
extension Persona {
    func nombreCompleto(_ apellidoPrimero: Bool = false) -> String {
        var nombre: String?
        if !apellidoPrimero {
            if self.nombre != nil {
                nombre = self.nombre! + (self.apellido != nil ? " " + self.apellido!: "")
            } else {
                nombre = (self.apellido != nil ? " " + self.apellido!: "")
            }
        } else {
            if self.apellido != nil {
                nombre = self.apellido! + (self.nombre != nil ? " " + self.nombre!: "")
            } else {
                nombre = (self.nombre != nil ? " " + self.nombre!: "")
            }
        }
        return nombre!
    }
    
    func addToRegalos(regalo: Regalo) {
        let regalos = self.mutableSetValue(forKey: "regalos")
        regalos.add(regalo)
    }
    
    func removeFromRegalos(regalo: Regalo) {
        let regalos = self.mutableSetValue(forKey: "regalos")
        regalos.remove(regalo)
    }
    
    func ordenaRegalosPorFecha() -> [AnyObject] {
        let regalos = self.mutableSetValue(forKey: "regalos").sorted(by: { (($0 as! Regalo).cuando as! Date) > (($1  as! Regalo).cuando as! Date)}) as [AnyObject]
        
        return regalos
    }
    
    func obtenerUltimoRegalo() -> CRegalo? {
        let regalos = self.mutableSetValue(forKey: "regalos").sorted(by: { (($0 as! Regalo).cuando as! Date) > (($1  as! Regalo).cuando as! Date)}) as [AnyObject]
        
        let regalo = CRegalo()

        if regalos.count > 0 {
            let cdregalo = (regalos.first as! Regalo) as Regalo
            regalo.cuando = cdregalo.cuando! as Date
            regalo.descripcion = cdregalo.descripcion
            regalo.motivo = cdregalo.motivo
            regalo.para = cdregalo.para
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            regalo.cuando = formatter.date(from: "01/01/1000")! as Date?
        }
        
        return regalo
    }
    
    func obtenerFechaMasRecienteDeRegalo() -> Date {
        let regalos = self.mutableSetValue(forKey: "regalos").sorted(by: { (($0 as! Regalo).cuando as! Date) > (($1  as! Regalo).cuando as! Date)}) as [AnyObject]
        
        if regalos.count > 0 {
            let fecha = ((regalos.first as! Regalo).cuando)! as Date
            return fecha
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.date(from: "01/01/1000")!
        }
    }
}
*/
