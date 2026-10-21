CREATE OR REPLACE TABLE `demo-project.analytics.metadata_pivot` AS
                SELECT
                    customer_uuid,
                    created_dt,
                    MAX(CASE WHEN name_hash = 'id_contato' THEN value END) AS id_contato
                FROM (
                    SELECT
                        cts.customer_uuid AS customer_uuid,
                        mtd.name AS name,
                        mtd.public_hash,
                        CASE 
                            WHEN mtd.public_hash IS NULL OR mtd.public_hash = '' THEN mtd.name
                            ELSE CONCAT(
                                COALESCE(NULLIF(mtd.name, ''), ''), '_', COALESCE(NULLIF(mtd.public_hash, ''), '')
                            )
                        END AS name_hash,
                        cts.value AS value,
                        cts.created_dt
                    FROM `demo-project.analytics.customer_metadata` AS cts
                    LEFT JOIN `demo-project.analytics.metadata` AS mtd
                        ON cts.metadata_uuid = mtd.uuid
                ) AS sub
                GROUP BY customer_uuid, created_dt
            ;
