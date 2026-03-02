INSERT INTO "workflow_history" (
    "versionId",
    "workflowId",
    "nodes",
    "connections",
    "createdAt",
    "updatedAt",
    "authors",
    "name"
)
SELECT
    w."versionId",
    w."id",
    w."nodes",
    w."connections",
    now(),
    now(),
    'cleanup-script',
    w."name"
FROM "workflow_entity" w
WHERE NOT EXISTS (
    SELECT 1 FROM "workflow_history" wh
    WHERE wh."versionId" = w."versionId"
);

\q
