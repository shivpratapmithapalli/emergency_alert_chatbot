// api/webhook.js
const axios = require("axios");

// Helper: Calculate distance using Haversine formula (if needed)
function haversineDistance(lat1, lon1, lat2, lon2) {
  const toRadians = (deg) => (deg * Math.PI) / 180;
  const R = 6371000; // meters
  const dLat = toRadians(lat2 - lat1);
  const dLon = toRadians(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(lat1)) * Math.cos(toRadians(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Helper: Fetch nearest police station using Overpass API, with fallback radii
async function fetchNearestPolice(latitude, longitude) {
  const fallbackRadii = [1000, 2000, 3000, 4000, 5000];
  for (const radius of fallbackRadii) {
    const overpassUrl = `https://overpass-api.de/api/interpreter?data=[out:json];node["amenity"="police"](around:${radius},${latitude},${longitude});out;`;
    console.log(`Calling Overpass API with radius ${radius}: ${overpassUrl}`);
    try {
      const apiResponse = await axios.get(overpassUrl, {
        headers: { "User-Agent": "EmergencyAlertApp/1.0" }
      });
      if (apiResponse.data && apiResponse.data.elements && apiResponse.data.elements.length > 0) {
        const station = apiResponse.data.elements[0];
        // Calculate the distance from the user to the station
        const distance = Math.round(
          haversineDistance(latitude, longitude, station.lat, station.lon)
        );
        return {
          name: (station.tags && station.tags.name) || station.display_name,
          lat: station.lat,
          lon: station.lon,
          distance: distance,
          radiusUsed: radius
        };
      }
    } catch (error) {
      console.error(`Error with radius ${radius}:`, error.message);
    }
  }
  return null;
}

module.exports = async (req, res) => {
  console.log("Webhook called with body:", JSON.stringify(req.body));
  
  // Get query text from the request
  const queryText = req.body.queryInput?.text?.text?.toLowerCase() || "";
  // For simplicity, we assume the location is auto-detected in the app
  // and sent to this function as queryParams.payload (if you want to use that)
  const geo = req.body.queryParams?.payload || {};
  const latitude = geo.latitude;
  const longitude = geo.longitude;

  // Simple rule-based intent detection
  if (queryText.includes("police") || queryText.includes("police help") || queryText.includes("police station") || queryText.includes("nearby police")) {
    if (latitude && longitude) {
      // Call the Overpass API logic to fetch the nearest police station
      const station = await fetchNearestPolice(latitude, longitude);
      if (station) {
        const responseText = `The nearest police station is ${station.name}. It is approximately ${station.distance} meters away (found within ${station.radiusUsed}m radius), located at latitude ${station.lat} and longitude ${station.lon}.`;
        return res.json({ fulfillmentText: responseText });
      } else {
        return res.json({ fulfillmentText: "I couldn't find a nearby police station." });
      }
    } else {
      // If location is missing, prompt for it
      return res.json({ fulfillmentText: "I'm missing your location. Please enable location services." });
    }
  } else {
    // Fallback for any other queries
    return res.json({ fulfillmentText: "Sorry, I didn't understand that." });
  }
};
