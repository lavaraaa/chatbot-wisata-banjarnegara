import { AppError } from "../utils/appError.js";

export class WeatherService {
  constructor() {
    this.baseUrl = "https://api.bmkg.go.id/publik/prakiraan-cuaca";
  }

  /**
   * Mengambil data cuaca berdasarkan kode wilayah tingkat IV
   * @param {string} kodeWilayah - Kode wilayah (contoh: 31.71.03.1001)
   * @returns {Promise<Object>} Data cuaca dari BMKG
   */
  async getWeatherByCode(kodeWilayah) {
    if (!kodeWilayah || typeof kodeWilayah !== "string") {
      throw new AppError(400, "Kode wilayah is required and must be a string");
    }

    try {
      console.log(`[WeatherService] Fetching weather for code: ${kodeWilayah}`);
      
      const response = await fetch(`${this.baseUrl}?adm4=${kodeWilayah}`);

      if (!response.ok) {
        throw new AppError(
          response.status, 
          `Failed to fetch weather data from BMKG: ${response.statusText}`
        );
      }

      const data = await response.json();
      
      // Basic validation if data exists
      if (!data || (data.data && data.data.length === 0)) {
         console.warn(`[WeatherService] No weather data found for code: ${kodeWilayah}`);
      }

      return data;
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      console.error("[WeatherService] Error fetching weather:", error);
      throw new AppError(500, "Failed to get weather information");
    }
  }
}

