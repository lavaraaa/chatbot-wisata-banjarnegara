export const getWeatherFunctionDeclaration = {
  name: "get_weather",
  description: "Get weather forecast information based on region code (kode wilayah tingkat IV).",
  parameters: {
    type: "OBJECT",
    properties: {
      kode_wilayah: {
        type: "STRING",
        description: "The region code (kode wilayah tingkat IV) for the weather forecast (e.g., '31.71.03.1001' for a specific area).",
      },
    },
    required: ["kode_wilayah"],
  },
};

