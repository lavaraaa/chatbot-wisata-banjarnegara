export const getMostLikedAttractionsFunctionDeclaration = {
    name: "get_most_liked_attractions",
    description:
        "Get tourist attractions ranked by number of likes. Use this when users ask about the most popular attractions, most liked places, or least popular attractions. Can return attractions sorted by most likes (descending) or least likes (ascending).",
    parameters: {
        type: "OBJECT",
        properties: {
            limit: {
                type: "NUMBER",
                description:
                    "Number of attractions to return. Default is 3 if not specified by the user.",
            },
            order: {
                type: "STRING",
                description:
                    "Sort order: 'desc' for most likes first (default), 'asc' for least likes first. Use 'asc' when user asks about least popular or unpopular attractions.",
                enum: ["desc", "asc"],
            },
        },
        required: [],
    },
};
