CREATE TABLE IF NOT EXISTS `demo-project.analytics.customer` AS 
            SELECT * FROM `demo-project.analytics.demo_customer_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.customer` AS target
            USING `demo-project.analytics.demo_customer_temp` AS source
            ON target.id = source.id
            WHEN MATCHED THEN
            UPDATE SET 
                target.name = source.name,
                target.email = source.email,
                target.organization_id = source.organization_id,
                target.create_time = source.create_time,
                target.dt_create_time = source.dt_create_time
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
