import "dotenv/config";
import express from "express";
import cors from "cors";
import { createChatRouter } from "./routes/chatRoutes.js";
import { createTourismRouter } from "./routes/tourismRoutes.js";
import { LlmService } from "./services/llmService.js";
import { TourismService } from "./services/tourismService.js";
import { TourismDBService } from "./services/tourismDBService.js";
import { WeatherService } from "./services/weatherService.js";
import { DistanceService } from "./services/distanceService.js";
import { ChatService } from "./services/chatService.js";
import { errorHandler } from "./utils/errorHandler.js";

const app = express();
app.use(cors({
  origin: [
    "https://be-wisata-banjarnegara.vercel.app",
    "https://fe-wisata-banjarnegara.vercel.app"
  ]
}));
app.use(express.json({ limit: "1mb" }));

const tourismService = new TourismService();
const llmService = new LlmService();
const tourismDBService = new TourismDBService();
const weatherService = new WeatherService();
const distanceService = new DistanceService(tourismService);
const chatService = new ChatService(
  llmService,
  tourismService,
  tourismDBService,
  weatherService,
  distanceService
);

app.get("/health", (_, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

async function bootstrap() {
  try {
    await tourismService.init();
    await llmService.init();

    app.use("/tourism", createTourismRouter(tourismService));
    app.use("/chat", createChatRouter(chatService));

    app.use(errorHandler);

    const port = Number(process.env.PORT) || 3000;
    app.listen(port, "0.0.0.0", () => {
      console.log(`Server listening on port ${port} and host 0.0.0.0`);
    });
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
}

bootstrap();
