CREATE TABLE IF NOT EXISTS `demo-project.analytics.interaction_answers` AS 
            SELECT * FROM `demo-project.analytics.demo_interactions_answers_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.interaction_answers` AS target
            USING `demo-project.analytics.demo_interactions_answers_temp` AS source
            ON target.interaction_uuid = source.interaction_uuid
            AND target.survey_item_uuid = source.survey_item_uuid
            WHEN MATCHED THEN
            UPDATE SET 
                target.answer = source.answer,
                target.comment = source.comment,
                target.created_at = source.created_at,
                target.deleted_at = source.deleted_at,
                target.created_dt = source.created_dt,
                target.deleted_dt = source.deleted_dt,
                target.extracted_at = source.extracted_at
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
