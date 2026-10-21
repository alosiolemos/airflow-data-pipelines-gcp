CREATE TABLE IF NOT EXISTS `demo-project.analytics.interactions` AS 
            SELECT * FROM `demo-project.analytics.demo_interactions_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.interactions` AS target
            USING `demo-project.analytics.demo_interactions_temp` AS source
            ON target.uuid = source.uuid
            WHEN MATCHED THEN
            UPDATE SET 
                target.customer_uuid = source.customer_uuid,
                target.survey_uuid = source.survey_uuid,
                target.distribution_uuid = source.distribution_uuid,
                target.out_status = source.out_status,
                target.out_channel = source.out_channel,
                target.out_at = source.out_at,
                target.in_status = source.in_status,
                target.in_channel = source.in_channel,
                target.answered_at = source.answered_at,
                target.opened_at = source.opened_at,
                target.created_at = source.created_at,
                target.answered_dt = source.answered_dt,
                target.modified_at = source.modified_at,
                target.opened_dt = source.opened_dt,
                target.deleted_at = source.deleted_at,
                target.extracted_at = source.extracted_at,
                target.out_data = source.out_data,
                target.opened_data = source.opened_data,
                target.created_data = source.created_data,
                target.modified_data = source.modified_data,
                target.answered_data = source.answered_data,
                target.deleted_data = source.deleted_data
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
