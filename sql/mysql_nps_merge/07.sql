SELECT 
                id,
                question_id,
                organization_id,
                campaign_id,                
                post_sale_action_id,
                type,
                status,
                create_time,
                update_time,
                FROM_UNIXTIME(create_time) AS create_DT,
                FROM_UNIXTIME(update_time) AS update_DT
            FROM 
                question_answer
            WHERE 
                FROM_UNIXTIME(create_time) >= NOW() - INTERVAL 30 DAY
            AND 
                FROM_UNIXTIME(create_time) <= NOW()
            AND 
            	organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
