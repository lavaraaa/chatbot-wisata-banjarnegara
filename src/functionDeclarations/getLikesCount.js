export const getLikesCountFunctionDeclaration = {
  name: "get_likes_count",
  description:
    "Get the number of likes for a specific tourist attraction. Use this when users ask about how many likes, popularity count, or how popular a tourist destination is. The wisata_id will be automatically extracted from the previous get_recommendations or get_information call if not provided.",
  parameters: {
    type: "OBJECT",
    properties: {
      wisata_id: {
        type: "NUMBER",
        description:
          "The ID of the tourist attraction to get likes count for. Optional - will be extracted from previous query if not provided.",
      },
    },
    required: [],
  },
};
