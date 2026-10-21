CREATE TABLE IF NOT EXISTS `demo-project.analytics.interaction_metadata` AS 
            SELECT * FROM `demo-project.analytics.demo_interaction_metadata_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.interaction_metadata` AS target
            USING `demo-project.analytics.demo_interaction_metadata_temp` AS source
            ON target.interaction_uuid = source.interaction_uuid
            WHEN MATCHED THEN
            UPDATE SET 
                target.metadata_uuid = source.metadata_uuid,
                target.value = source.value,
                target.created_at = source.created_at,
                target.created_dt = source.created_dt,
                target.extracted_at = source.extracted_at
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
