
import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var trType = 0
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapStyle: UISegmentedControl!
    
    var resultSearchController:UISearchController? = nil

    @IBOutlet weak var transportType: DropMenuButton!
    
    let locman = CLLocationManager()
    public static var pinNr = -1
    var boo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locman.delegate = self
        self.mapView.delegate = self
        
        self.transportType.initMenu(["car", "walk", "bus"], actions: [
            ({ () -> (Void) in
                print("Car")
                self.trType = 0
            }),
            ({ () -> (Void) in
                print("Walk")
                self.trType = 1
            }),
            ({ () -> (Void) in
                print("BUS")
                self.trType = 2
            })
        ])
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.displayPins), userInfo: nil, repeats: true)
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        locationSearchTable.mapView = mapView
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Locations"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        self.locman.desiredAccuracy = kCLLocationAccuracyBest
        self.locman.requestWhenInUseAuthorization()
        self.locman.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.displayPins()
    }

    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began
        {
            let loc = sender.location(in: self.mapView)
            let mapPoint = self.mapView.convert(loc, toCoordinateFrom: self.mapView)
            let myCL = CLLocation(latitude: mapPoint.latitude, longitude: mapPoint.longitude)
            
            CLGeocoder().reverseGeocodeLocation(myCL) { (placemark, error) in
                if error != nil
                {
                    print("Error")
                }
                else
                {
                    if let p = placemark?[0]
                    {
                        AppDelegate.pins.append(Pin(name: p.administrativeArea!, title: "\(p.country!), \(p.name ?? "Unknown")", x: mapPoint.latitude , y: mapPoint.longitude))
                        FirstViewController.pinNr = AppDelegate.pins.count
                    }
                    self.displayPins()
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func MyLocation(_ sender: Any) {
        boo = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        tabBarController?.tabBar.items?[1].badgeValue = String(AppDelegate.pins.count)
        if boo
        {
            boo = false
            
            let location = locations.last
            let center = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            
            if AppDelegate.boo {
                self.mapView.removeOverlays(self.mapView.overlays)
                self.drawRouter(point1: center, point2: AppDelegate.FirstLocation!)
            }
            AppDelegate.boo = false
            self.mapView.setRegion(region, animated: true)
        }
        boo = AppDelegate.boo
    }
    
    func displayPins()
    {
        if (AppDelegate.FirstLocation != nil && AppDelegate.SecondLocation != nil && AppDelegate.notDrawed)
        {
            self.mapView.removeOverlays(self.mapView.overlays)
            self.drawRouter(point1: AppDelegate.FirstLocation!, point2: AppDelegate.SecondLocation!)
            AppDelegate.notDrawed = false
        }
        if FirstViewController.pinNr >= 0
        {
            self.mapView.removeAnnotations(self.mapView.annotations)
            if AppDelegate.pins.count > 0
            {
                for i in 0 ... (AppDelegate.pins.count - 1)
                {
                    let pin = AppDelegate.pins[i]
                    let annotation = MKPointAnnotation()
                    let location = CLLocationCoordinate2DMake(pin.coordinate_x, pin.coordinate_y)
                    annotation.coordinate = location
                    annotation.title = pin.name
                    annotation.subtitle = pin.title
                    if i == FirstViewController.pinNr
                    {
                        let span = MKCoordinateSpanMake(0.09, 0.09)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapView.setRegion(region, animated: true)
                    }
                    self.mapView.addAnnotation(annotation)
                }
            }
            FirstViewController.pinNr = -1
        }
    }

    @IBAction func mapStyleChange(_ sender: Any) {
        if self.mapStyle.selectedSegmentIndex == 0 {
            self.mapView.mapType = .standard
        }
        else if self.mapStyle.selectedSegmentIndex == 1 {
            self.mapView.mapType = .satellite
        }
        else if self.mapStyle.selectedSegmentIndex == 2 {
            self.mapView.mapType = .hybrid
        }

    }

    func drawRouter(point1 : CLLocationCoordinate2D, point2 : CLLocationCoordinate2D) {
        
        let request = MKDirectionsRequest()
 
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: point1))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: point2))
        request.requestsAlternateRoutes = true
        switch self.trType {
        case 0:
            request.transportType = .automobile
            break
        case 1:
            request.transportType = .walking
            break
        case 2:
            request.transportType = .transit
            break
        default:
            request.transportType = .automobile
        }
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { print(error ?? "Error"); return }
            
            if (unwrappedResponse.routes.count > 0) {
                let route = unwrappedResponse.routes[0]
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRendere = MKPolylineRenderer(overlay: overlay)
        polylineRendere.strokeColor = UIColor.blue
        polylineRendere.lineWidth = 5
        return polylineRendere
    }

}

