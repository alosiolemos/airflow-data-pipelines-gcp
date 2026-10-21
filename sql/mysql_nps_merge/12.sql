SELECT 
                id,
                MAX(status) AS status,
                MAX(scheduled_time) AS scheduled_time,
                MAX(create_time) AS create_time,
                MAX(update_time) AS update_time,
                MAX(delete_time) AS delete_time,
                MAX(create_DT) as create_DT,
                MAX(update_DT) as update_DT,
                MAX(delete_DT) as delete_DT
            FROM (
                SELECT 
                    s.id,
                    s.status,
                    s.scheduled_time,
                    s.create_time,
                    s.update_time,
                    s.delete_time,   
                    FROM_UNIXTIME(s.create_time) AS create_DT,
                    FROM_UNIXTIME(s.update_time) AS update_DT,
                    FROM_UNIXTIME(s.delete_time) AS delete_DT
                FROM schedule s
                LEFT JOIN post_sale_lot psl ON psl.schedule_id = s.id
                LEFT JOIN post_sale_dispatch psd1 ON psd1.post_sale_lot_id = psl.id
                WHERE psd1.organization_id IN (1001, 1002, 1003, 1004, 1005, 1006)
                    AND FROM_UNIXTIME(s.create_time) >= NOW() - INTERVAL 30 DAY
                    AND FROM_UNIXTIME(s.create_time) <= NOW()
            ) sub
            GROUP BY id
        ;
