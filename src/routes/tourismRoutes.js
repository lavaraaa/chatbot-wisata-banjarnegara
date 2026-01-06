import { Router } from "express";

export function createTourismRouter(tourismService) {
  const router = Router();

  router.post("/documents", async (req, res, next) => {
    try {
      const { ids, documents, metadatas } = req.body;
      const result = await tourismService.addDocuments(
        ids,
        documents,
        metadatas
      );
      res.json({
        success: true,
        message: "Documents added successfully",
        count: result.count,
      });
    } catch (error) {
      next(error);
    }
  });

  router.post("/query", async (req, res, next) => {
    try {
      const { queries, nResults } = req.body;
      const result = await tourismService.queryDocuments(queries, nResults);
      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  });

  router.delete("/documents", async (req, res, next) => {
    try {
      const { ids } = req.body;
      const result = await tourismService.deleteDocuments(ids);
      res.json({
        success: true,
        message: "Documents deleted successfully",
        count: result.count,
      });
    } catch (error) {
      next(error);
    }
  });

  return router;
}
