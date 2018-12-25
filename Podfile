platform :ios, '10.0'

use_frameworks!
# Available pods

def available_pods
    pod 'SwiftyJSON' # License: MIT # Handle Json Response
    pod 'ReachabilitySwift' # License: MIT # Handle Internet connection
    pod 'NotificationBannerSwift' # License: MIT # Show fancy alert on Navigationbar & Status bar
    pod 'Kingfisher' # License: MIT # For Image downloading
end

target 'cards' do
    available_pods
end

target 'cardsTests' do
    inherit! :search_paths
    available_pods
end
