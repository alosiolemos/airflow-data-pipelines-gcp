CREATE TABLE IF NOT EXISTS `demo-project.analytics.post_sale_action` AS 
            SELECT * FROM `demo-project.analytics.demo_post_sale_action_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.post_sale_action` AS target
            USING `demo-project.analytics.demo_post_sale_action_temp` AS source
            ON target.id = source.id
            WHEN MATCHED THEN
            UPDATE SET 
                target.post_sale_dispatch_id = source.post_sale_dispatch_id,
                target.customer_id = source.customer_id,
                target.campaign_id = source.campaign_id,
                target.organization_id = source.organization_id,
                target.status = source.status,
                target.status_id = source.status_id,
                target.analytics_status = source.analytics_status,
                target.priority = source.priority,
                target.category_text = source.category_text,
                target.create_time = source.create_time,
                target.update_time = source.update_time,
                target.delete_time = source.delete_time,
                target.answer_elapsed_time = source.answer_elapsed_time,
                target.create_DT = source.create_DT,
                target.update_DT = source.update_DT,
                target.delete_DT = source.delete_DT
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
