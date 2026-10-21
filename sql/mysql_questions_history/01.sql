SELECT 
                id,
                question_id,
                organization_id,
                campaign_id,
                type,
                status,
                create_time,
                update_time,
                FROM_UNIXTIME(create_time) AS create_DT,
                FROM_UNIXTIME(update_time) AS update_DT
            FROM 
                question_answer            
            WHERE 
                FROM_UNIXTIME(create_time) BETWEEN '2021-06-30 23:59:59' AND '2021-12-31 23:59:59'
        ;
