CREATE TABLE IF NOT EXISTS `demo-project.analytics.question_answer` AS 
            SELECT * FROM `demo-project.analytics.demo_question_answer_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.question_answer` AS target
            USING `demo-project.analytics.demo_question_answer_temp` AS source
            ON target.id = source.id
            WHEN MATCHED THEN
            UPDATE SET 
                target.question_id = source.question_id,
                target.organization_id = source.organization_id,
                target.campaign_id = source.campaign_id,
                target.post_sale_action_id = source.post_sale_action_id,
                target.type = source.type,
                target.status = source.status,
                target.create_time = source.create_time,
                target.update_time = source.update_time,
                target.create_DT = source.create_DT,
                target.update_DT = source.update_DT
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
