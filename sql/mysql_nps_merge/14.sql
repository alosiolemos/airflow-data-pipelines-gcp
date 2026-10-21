CREATE TABLE IF NOT EXISTS `demo-project.analytics.question_answer_nps` AS 
            SELECT * FROM `demo-project.analytics.demo_question_answer_nps_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.question_answer_nps` AS target
            USING `demo-project.analytics.demo_question_answer_nps_temp` AS source
            ON target.id = source.id
            WHEN MATCHED THEN
            UPDATE SET 
                target.question_answer_id = source.question_answer_id,
                target.status = source.status,
                target.nps_comment = source.nps_comment,
                target.nps_answer = source.nps_answer,
                target.last_nps_answer = source.last_nps_answer,
                target.create_time = source.create_time,
                target.update_time = source.update_time,
                target.organization_id = source.organization_id,
                target.create_DT = source.create_DT,
                target.update_DT = source.update_DT
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
