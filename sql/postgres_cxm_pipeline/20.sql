CREATE TABLE IF NOT EXISTS `demo-project.analytics.customer_metadata` AS 
            SELECT * FROM `demo-project.analytics.demo_customer_metadata_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.customer_metadata` AS target
            USING `demo-project.analytics.demo_customer_metadata_temp` AS source
            ON target.customer_uuid = source.customer_uuid
            AND target.metadata_uuid = source.metadata_uuid
            WHEN MATCHED THEN
            UPDATE SET
                target.value = source.value,
                target.created_at = source.created_at,
                target.created_dt = source.created_dt,
                target.extracted_at = source.extracted_at
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
