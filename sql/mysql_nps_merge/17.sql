CREATE TABLE IF NOT EXISTS `demo-project.analytics.schedule` AS 
            SELECT * FROM `demo-project.analytics.demo_schedule_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.schedule` AS target
            USING `demo-project.analytics.demo_schedule_temp` AS source
            ON target.id = source.id
            WHEN MATCHED THEN
            UPDATE SET 
                target.status = source.status,
                target.scheduled_time = source.scheduled_time,
                target.create_time = source.create_time,
                target.update_time = source.update_time,
                target.delete_time = source.delete_time,
                target.create_DT = source.create_DT,
                target.update_DT = source.update_DT,
                target.delete_DT = source.delete_DT
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
