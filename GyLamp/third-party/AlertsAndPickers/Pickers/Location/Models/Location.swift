import Foundation
import CoreLocation
import Contacts

// class because protocol
@available(iOS 11.0, *)
public class Location: NSObject {
	public let name: String?
	
	// difference from placemark location is that if location was reverse geocoded,
	// then location point to user selected location
	public let location: CLLocation
	public let placemark: CLPlacemark
	
	public var address: String {
        if let postalAddress = placemark.postalAddress {
            let formatter = CNPostalAddressFormatter()
            formatter.style = .mailingAddress
            return formatter.string(from: postalAddress)
        } else {
            return "\(coordinate.latitude), \(coordinate.longitude)"
        }
	}
	
	public init(name: String?, location: CLLocation? = nil, placemark: CLPlacemark) {
		self.name = name
		self.location = location ?? placemark.location!
		self.placemark = placemark
	}
}

import MapKit

@available(iOS 11.0, *)
extension Location: MKAnnotation {
    
    @objc public var coordinate: CLLocationCoordinate2D {
		return location.coordinate
	}
	
    public var title: String? {
		return address
	}
}
