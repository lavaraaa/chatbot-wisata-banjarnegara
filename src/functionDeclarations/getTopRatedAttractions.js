export const getTopRatedAttractionsFunctionDeclaration = {
    name: "get_top_rated_attractions",
    description:
        "Get tourist attractions ranked by average rating. Use this when users ask about the highest rated attractions, best rated places, or lowest rated attractions.",
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
                    "Sort order: 'desc' for highest rating first (default), 'asc' for lowest rating first. Use 'asc' when user asks about lowest rated or worst rated attractions.",
                enum: ["desc", "asc"],
            },
        },
        required: [],
    },
};
