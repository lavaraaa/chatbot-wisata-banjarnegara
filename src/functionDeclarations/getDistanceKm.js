export const getDistanceKmFunctionDeclaration = {
  name: "get_distance_km",
  description: "Calculate the distance in kilometers between two locations. The system will automatically find the locations and return the distance. Useful when user asks for distance between two places.",
  parameters: {
    type: "OBJECT",
    properties: {
      query: {
        type: "STRING",
        description: "Natural language query describing two locations and distance request, e.g., 'distance from Surya Yudha Park to Curug Pitu' or 'berapa jarak dari kawah sikidang ke curug pitu'",
      },
    },
    required: ["query"],
  },
};
