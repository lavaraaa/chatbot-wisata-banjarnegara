import { AppError } from "../utils/appError.js";

export class DistanceService {
    constructor(tourismService) {
        this.tourismService = tourismService;
        this.baseUrl = "https://api.tomtom.com/routing/1/calculateRoute";
        const apiKey = process.env.TOMTOM_API_KEY;
        if (!apiKey) {
            throw new AppError(500, "TOMTOM_API_KEY is not configured");
        }
        this.apiKey = apiKey;
    }

    async getDistanceFromLocations(query) {
        try {
            console.log(`[DistanceService] Finding distance for query: "${query}"`);

            // Query vector DB to find 2 most relevant locations
            const results = await this.tourismService.queryDocuments([query], 2);
            const locations = results?.documents?.[0] ?? [];
            const ids = results?.ids?.[0] ?? [];
            const metadatas = results?.metadatas?.[0] ?? [];

            if (!locations || locations.length < 2) {
                throw new AppError(
                    400,
                    locations.length === 0
                        ? "Tidak ada lokasi yang ditemukan. Silakan tentukan dua lokasi berbeda."
                        : "Hanya satu lokasi yang ditemukan. Silakan tentukan dua lokasi berbeda untuk perhitungan jarak."
                );
            }

            // Extract coordinates from both locations
            const location1 = {
                name: metadatas[0]?.nama || `Location ${ids[0]}`,
                lat: metadatas[0]?.latitude || metadatas[0]?.lat,
                lng: metadatas[0]?.longitude || metadatas[0]?.long || metadatas[0]?.lng,
            };

            const location2 = {
                name: metadatas[1]?.nama || `Location ${ids[1]}`,
                lat: metadatas[1]?.latitude || metadatas[1]?.lat,
                lng: metadatas[1]?.longitude || metadatas[1]?.long || metadatas[1]?.lng,
            };

            // Validate coordinates exist
            if (!location1.lat || !location1.lng || !location2.lat || !location2.lng) {
                throw new AppError(
                    400,
                    "Koordinat lokasi tidak ditemukan. Silakan coba dengan nama lokasi yang berbeda."
                );
            }

            // Check if coordinates are identical
            if (
                parseFloat(location1.lat) === parseFloat(location2.lat) &&
                parseFloat(location1.lng) === parseFloat(location2.lng)
            ) {
                throw new AppError(
                    400,
                    "Kedua lokasi memiliki koordinat yang sama. Silakan tentukan dua lokasi berbeda."
                );
            }

            console.log(`[DistanceService] Location 1: ${location1.name} (${location1.lat}, ${location1.lng})`);
            console.log(`[DistanceService] Location 2: ${location2.name} (${location2.lat}, ${location2.lng})`);

            // Calculate distance
            const distanceKm = await this.#calculateDistance(
                location1.lat,
                location1.lng,
                location2.lat,
                location2.lng
            );

            // Return formatted response
            const response = `Jarak dari ${location1.name} ke ${location2.name} adalah ${distanceKm} km.`;
            return response;
        } catch (error) {
            if (error instanceof AppError) {
                throw error;
            }
            console.error("[DistanceService] Error in getDistanceFromLocations:", error);
            throw new AppError(500, "Gagal menghitung jarak. Silakan coba lagi.");
        }
    }

    async #calculateDistance(startLat, startLong, endLat, endLong){
        const locations = `${startLat},${startLong}:${endLat},${endLong}`;
        const url = `${this.baseUrl}/${locations}/json?key=${this.apiKey}`;

        const maxRetries = 3;
        const timeoutMs = 15000; // 15 second timeout per request

        for (let attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                console.log(`[DistanceService] Attempt ${attempt}/${maxRetries} to fetch distance from TomTom`);

                // Create a timeout promise
                const timeoutPromise = new Promise((_, reject) =>
                    setTimeout(() => reject(new Error("TomTom API request timeout")), timeoutMs)
                );

                const fetchPromise = fetch(url);
                const response = await Promise.race([fetchPromise, timeoutPromise]);

                if (!response.ok) {
                    throw new AppError(response.status, `Gagal mengambil data jarak dari TomTom: ${response.statusText}`);
                }

                const data = await response.json();
                if (data.routes && data.routes.length > 0) {
                    const distanceMeters = data.routes[0].summary.lengthInMeters;
                    const distanceKm = (distanceMeters/1000).toFixed(2);
                    console.log(`[DistanceService] Successfully calculated distance: ${distanceKm} km`);
                    return distanceKm;
                } else {
                    throw new AppError(404, "Tidak ada rute yang ditemukan antara kedua lokasi");
                }
            } catch (error) {
                if (error instanceof AppError) {
                    throw error;
                }

                console.warn(`[DistanceService] Attempt ${attempt} failed: ${error.message}`);

                // If last attempt, throw error
                if (attempt === maxRetries) {
                    console.error("[DistanceService] All retry attempts failed:", error);
                    throw new AppError(500, "Gagal menghitung jarak. API TomTom sedang tidak tersedia. Silakan coba lagi nanti.");
                }

                // Wait before retry (exponential backoff)
                const delayMs = Math.min(1000 * Math.pow(2, attempt - 1), 5000);
                console.log(`[DistanceService] Retrying in ${delayMs}ms...`);
                await new Promise(resolve => setTimeout(resolve, delayMs));
            }
        }
    }
}