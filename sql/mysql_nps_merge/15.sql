CREATE TABLE IF NOT EXISTS `demo-project.analytics.post_sale_dispatch` AS 
            SELECT * FROM `demo-project.analytics.demo_post_sale_dispatch_temp`
            WHERE 1 = 0;

            MERGE INTO `demo-project.analytics.post_sale_dispatch` AS target
            USING `demo-project.analytics.demo_post_sale_dispatch_temp` AS source
            ON target.id = source.id
            WHEN MATCHED THEN
            UPDATE SET 
                target.status = source.status,
                target.dispatched = source.dispatched,
                target.post_sale_lot_id = source.post_sale_lot_id,
                target.customer_id = source.customer_id,
                target.organization_id = source.organization_id,
                target.campaign_id = source.campaign_id,
                target.type = source.type,
                target.custom_fields = source.custom_fields,
                target.second_dispatch_time = source.second_dispatch_time,
                target.dispatch_time = source.dispatch_time,
                target.create_time = source.create_time,
                target.update_time = source.update_time,
                target.delete_time = source.delete_time,
                target.create_DT = source.create_DT,
                target.dispatch_DT = source.dispatch_DT,
                target.update_DT = source.update_DT,
                target.delete_DT = source.delete_DT
            WHEN NOT MATCHED THEN
            INSERT ROW;
        ;
