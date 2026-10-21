CREATE TABLE IF NOT EXISTS `demo-project.analytics.customers` AS 
            SELECT * FROM `demo-project.analytics.demo_customers_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.customers` AS target
            USING `demo-project.analytics.demo_customers_temp` AS source
            ON target.uuid = source.uuid
            WHEN MATCHED THEN
            UPDATE SET 
                target.name = source.name,
                target.email = source.email,
                target.phone = source.phone,
                target.last_interaction_unified_score = source.last_interaction_unified_score,
                target.last_interaction_date = source.last_interaction_date,
                target.created_at = source.created_at,
                target.modified_at = source.modified_at,
                target.deleted_at = source.deleted_at,
                target.created_dt = source.created_dt,
                target.modified_dt = source.modified_dt,
                target.deleted_dt = source.deleted_dt,
                target.extracted_at = source.extracted_at
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
